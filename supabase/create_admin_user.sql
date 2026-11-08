-- ==============================================================================
-- Create or Reset Admin User: admin@nationalhospital.com
-- Run this in Supabase Dashboard > SQL Editor
-- Set your desired secure password below before running!
-- ==============================================================================

create extension if not exists "pgcrypto";

do $$
declare
  v_user_id uuid;
  v_email text := 'admin@nationalhospital.com';
  v_password text := '<YOUR_SECURE_ADMIN_PASSWORD>'; -- Replace with your strong password
  v_encrypted_pw text := crypt(v_password, gen_salt('bf'));
begin
  -- 1. Check if user already exists in auth.users
  select id into v_user_id from auth.users where email = v_email;

  if v_user_id is not null then
    -- User exists: Update password and ensure email is confirmed
    update auth.users
       set encrypted_password = v_encrypted_pw,
           email_confirmed_at = coalesce(email_confirmed_at, now()),
           updated_at = now()
     where id = v_user_id;
  else
    -- User does not exist: Create new authenticated user
    v_user_id := gen_random_uuid();
    insert into auth.users (
      instance_id,
      id,
      aud,
      role,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_app_meta_data,
      raw_user_meta_data,
      created_at,
      updated_at
    ) values (
      '00000000-0000-0000-0000-000000000000',
      v_user_id,
      'authenticated',
      'authenticated',
      v_email,
      v_encrypted_pw,
      now(),
      jsonb_build_object('provider', 'email', 'providers', array['email']),
      jsonb_build_object('full_name', 'Hospital Admin'),
      now(),
      now()
    );
  end if;

  -- 2. Ensure profile exists in public.profiles
  insert into public.profiles (id, full_name, phone, email)
  values (v_user_id, 'Hospital Admin', '01700000000', v_email)
  on conflict (id) do update 
    set full_name = 'Hospital Admin',
        email = v_email;

  -- 3. Grant super_admin and admin roles in public.user_roles
  insert into public.user_roles (user_id, role)
  values (v_user_id, 'super_admin')
  on conflict (user_id, role) do nothing;

  insert into public.user_roles (user_id, role)
  values (v_user_id, 'admin')
  on conflict (user_id, role) do nothing;

  raise notice 'Admin user created/updated successfully with ID: %', v_user_id;
end $$;
