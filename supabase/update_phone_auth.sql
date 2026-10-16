-- ==============================================================================
-- National Hospital Chattogram: Phone Authentication Update
-- Run this in: Supabase Dashboard > SQL Editor > Click "Run"
--
-- Features:
-- 1. Users can register with JUST phone number and password (email is optional).
-- 2. Users can log in using either their phone number OR email.
-- 3. Bypasses Supabase email rate limits and SMTP confirmation issues.
-- ==============================================================================

-- 1. Enable pgcrypto for password hashing
create extension if not exists "pgcrypto";

-- 2. Ensure indexes on public.profiles for fast phone/email lookup
create index if not exists idx_profiles_phone on public.profiles(phone);
create index if not exists idx_profiles_email on public.profiles(email);

-- 3. Function to resolve phone number or email to Supabase Auth email
create or replace function public.get_auth_email_for_login(p_identifier text)
returns text
language plpgsql
security definer set search_path = public, auth, extensions
as $$
declare
  v_clean_phone text;
  v_email text;
begin
  if p_identifier is null or trim(p_identifier) = '' then
    return null;
  end if;

  -- If input is an email address
  if p_identifier like '%@%' then
    -- Check if it directly matches an auth.users email
    select email into v_email
      from auth.users
     where lower(email) = lower(trim(p_identifier))
     limit 1;
    if v_email is not null then
      return v_email;
    end if;

    -- Check if it matches an email stored in public.profiles
    select u.email into v_email
      from public.profiles p
      join auth.users u on u.id = p.id
     where lower(p.email) = lower(trim(p_identifier))
     limit 1;
    if v_email is not null then
      return v_email;
    end if;

    return trim(p_identifier);
  end if;

  -- Otherwise treated as a phone number
  v_clean_phone := regexp_replace(p_identifier, '[^0-9]', '', 'g');

  -- Look up user in public.profiles by cleaned phone
  select u.email into v_email
    from public.profiles p
    join auth.users u on u.id = p.id
   where regexp_replace(p.phone, '[^0-9]', '', 'g') = v_clean_phone
   limit 1;
  if v_email is not null then
    return v_email;
  end if;

  -- Look up directly in auth.users by phone
  select email into v_email
    from auth.users
   where regexp_replace(coalesce(phone, ''), '[^0-9]', '', 'g') = v_clean_phone
   limit 1;
  if v_email is not null then
    return v_email;
  end if;

  -- Fallback canonical auth email pattern
  return v_clean_phone || '@patient.nationalhospital.com';
end;
$$;

grant execute on function public.get_auth_email_for_login(text) to anon, authenticated;

-- 4. Function to register user directly with phone number (email optional)
--    Auto-confirms the user so no confirmation email or SMTP rate limit is triggered!
create or replace function public.register_user_with_phone(
  p_phone text,
  p_password text,
  p_full_name text,
  p_email text default null,
  p_age int default null,
  p_gender text default null
)
returns jsonb
language plpgsql
security definer set search_path = public, auth, extensions
as $$
declare
  v_user_id uuid;
  v_clean_phone text;
  v_auth_email text;
  v_clean_email text;
  v_encrypted_pw text;
begin
  -- Validate phone
  v_clean_phone := regexp_replace(p_phone, '[^0-9]', '', 'g');
  if length(v_clean_phone) < 11 then
    raise exception 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন (যেমন: 01712345678)';
  end if;

  -- Validate password
  if length(p_password) < 6 then
    raise exception 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
  end if;

  -- Clean optional email
  v_clean_email := nullif(trim(coalesce(p_email, '')), '');

  -- Canonical internal auth email for GoTrue JWT session management
  v_auth_email := v_clean_phone || '@patient.nationalhospital.com';

  -- Check if phone already registered in profiles or auth.users
  if exists (
    select 1 from public.profiles
     where regexp_replace(phone, '[^0-9]', '', 'g') = v_clean_phone
  ) or exists (
    select 1 from auth.users
     where email = v_auth_email
        or (phone is not null and regexp_replace(phone, '[^0-9]', '', 'g') = v_clean_phone)
  ) then
    raise exception 'এই মোবাইল নম্বরটি দিয়ে ইতিমধ্যে একটি অ্যাকাউন্ট রয়েছে। লগইন করুন।';
  end if;

  -- Generate user ID
  v_user_id := gen_random_uuid();

  -- Encrypt password using pgcrypto blowfish crypt
  v_encrypted_pw := crypt(p_password, gen_salt('bf'));

  -- Insert directly into auth.users (Pre-confirmed: email_confirmed_at & phone_confirmed_at are set)
  insert into auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    phone,
    phone_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    recovery_token
  ) values (
    '00000000-0000-0000-0000-000000000000',
    v_user_id,
    'authenticated',
    'authenticated',
    v_auth_email,
    v_encrypted_pw,
    now(),
    v_clean_phone,
    now(),
    jsonb_build_object('provider', 'email', 'providers', array['email']),
    jsonb_build_object(
      'full_name', p_full_name,
      'phone', v_clean_phone,
      'email', v_clean_email,
      'age', p_age,
      'gender', p_gender
    ),
    now(),
    now(),
    '',
    ''
  );

  -- Upsert into public.profiles
  insert into public.profiles (
    id,
    full_name,
    age,
    gender,
    phone,
    email
  ) values (
    v_user_id,
    p_full_name,
    p_age,
    p_gender,
    v_clean_phone,
    v_clean_email
  )
  on conflict (id) do update set
    full_name = excluded.full_name,
    phone = excluded.phone,
    email = excluded.email,
    age = excluded.age,
    gender = excluded.gender;

  return jsonb_build_object(
    'success', true,
    'user_id', v_user_id,
    'auth_email', v_auth_email
  );
end;
$$;

grant execute on function public.register_user_with_phone(text, text, text, text, int, text) to anon, authenticated;

-- 5. Update handle_new_user trigger function to safely handle optional email
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, age, gender, phone, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', 'রোগী'),
    nullif(new.raw_user_meta_data->>'age', '')::int,
    new.raw_user_meta_data->>'gender',
    coalesce(new.raw_user_meta_data->>'phone', coalesce(new.phone, '')),
    case 
      when new.raw_user_meta_data->>'email' is not null and new.raw_user_meta_data->>'email' <> ''
        then new.raw_user_meta_data->>'email'
      when new.email like '%@patient.nationalhospital.com' or new.email like '%@nationalhospital.local'
        then null
      else new.email
    end
  )
  on conflict (id) do update set
    full_name = excluded.full_name,
    phone = coalesce(nullif(excluded.phone, ''), public.profiles.phone),
    email = coalesce(nullif(excluded.email, ''), public.profiles.email),
    age = coalesce(excluded.age, public.profiles.age),
    gender = coalesce(excluded.gender, public.profiles.gender);
  return new;
end;
$$;
