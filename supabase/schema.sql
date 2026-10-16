-- ==============================================================================
-- National Hospital Chattogram: Appointment App Schema
-- Optimized with Supabase Postgres Best Practices
-- Run in Supabase Dashboard > SQL Editor
-- ==============================================================================

-- Enable UUID extension if not already enabled
create extension if not exists "pgcrypto";

-- ========== 1. TABLES ==========

-- Specialties / Departments
create table if not exists public.specialties (
  id serial primary key,
  name_bn text not null unique
);

-- Patient Profiles (linked 1:1 with auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  age int check (age between 0 and 120),
  gender text check (gender in ('male', 'female', 'other')),
  phone text not null,
  email text,
  created_at timestamptz default now()
);

-- Doctors
create table if not exists public.doctors (
  id uuid primary key default gen_random_uuid(),
  name_bn text not null,
  degree text,
  specialty_id int not null references public.specialties(id),
  experience_years int,
  bio text,
  photo_url text,
  is_active boolean default true,
  fee int default 1000,
  room_no text,
  created_at timestamptz default now()
);

-- Doctor Weekly Schedules
create table if not exists public.doctor_schedules (
  id uuid primary key default gen_random_uuid(),
  doctor_id uuid not null references public.doctors(id) on delete cascade,
  weekday int not null check (weekday between 0 and 6), -- 0 = Sunday, 6 = Saturday
  start_time time not null,
  end_time time not null,
  slot_minutes int not null default 15,
  check (end_time > start_time)
);

-- Appointments
create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  doctor_id uuid not null references public.doctors(id),
  appointment_date date not null,
  slot_time time not null,
  status text not null default 'booked'
    check (status in ('booked', 'cancelled', 'completed')),
  serial_no int,
  created_at timestamptz default now()
);

-- ========== 2. INDEXES (Performance & Integrity) ==========

-- Prevent double-booking for the same active slot
create unique index if not exists uniq_active_slot
  on public.appointments (doctor_id, appointment_date, slot_time)
  where status <> 'cancelled';

-- Foreign key & query performance indexes
create index if not exists idx_doctors_specialty on public.doctors(specialty_id);
create index if not exists idx_doctor_schedules_doctor on public.doctor_schedules(doctor_id);
create index if not exists idx_appt_user on public.appointments(user_id);
create index if not exists idx_appt_doctor_date on public.appointments(doctor_id, appointment_date);
create index if not exists idx_profiles_phone on public.profiles(phone);
create index if not exists idx_profiles_email on public.profiles(email);

-- ========== 3. TRIGGERS & FUNCTIONS ==========

-- Auto-create profile on signup
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

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Phone Authentication: Direct registration bypassing email verification / rate limits
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
  v_clean_phone := regexp_replace(p_phone, '[^0-9]', '', 'g');
  if length(v_clean_phone) < 11 then
    raise exception 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন (যেমন: 01712345678)';
  end if;

  if length(p_password) < 6 then
    raise exception 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
  end if;

  v_clean_email := nullif(trim(coalesce(p_email, '')), '');
  v_auth_email := v_clean_phone || '@patient.nationalhospital.com';

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

  v_user_id := gen_random_uuid();
  v_encrypted_pw := crypt(p_password, gen_salt('bf'));

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

-- Phone Authentication: Resolve phone or email to auth email
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

  if p_identifier like '%@%' then
    select email into v_email
      from auth.users
     where lower(email) = lower(trim(p_identifier))
     limit 1;
    if v_email is not null then
      return v_email;
    end if;

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

  v_clean_phone := regexp_replace(p_identifier, '[^0-9]', '', 'g');

  select u.email into v_email
    from public.profiles p
    join auth.users u on u.id = p.id
   where regexp_replace(p.phone, '[^0-9]', '', 'g') = v_clean_phone
   limit 1;
  if v_email is not null then
    return v_email;
  end if;

  select email into v_email
    from auth.users
   where regexp_replace(coalesce(phone, ''), '[^0-9]', '', 'g') = v_clean_phone
   limit 1;
  if v_email is not null then
    return v_email;
  end if;

  return v_clean_phone || '@patient.nationalhospital.com';
end;
$$;

grant execute on function public.get_auth_email_for_login(text) to anon, authenticated;

-- Auto serial number per doctor per day
create or replace function public.set_serial_no()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  select coalesce(max(serial_no), 0) + 1
    into new.serial_no
    from public.appointments
   where doctor_id = new.doctor_id
     and appointment_date = new.appointment_date;
  return new;
end;
$$;

drop trigger if exists appointments_serial on public.appointments;
create trigger appointments_serial
  before insert on public.appointments
  for each row execute function public.set_serial_no();

-- ========== 4. ROW LEVEL SECURITY (RLS) ==========

alter table public.specialties enable row level security;
alter table public.profiles enable row level security;
alter table public.doctors enable row level security;
alter table public.doctor_schedules enable row level security;
alter table public.appointments enable row level security;

-- Public read: specialties, doctors, schedules (allow both authenticated & guest browsing)
drop policy if exists "read specialties" on public.specialties;
create policy "read specialties" on public.specialties
  for select to authenticated, anon using (true);

drop policy if exists "admin insert specialties" on public.specialties;
create policy "admin insert specialties" on public.specialties
  for insert to authenticated, anon with check (true);

drop policy if exists "read doctors" on public.doctors;
create policy "read doctors" on public.doctors
  for select to authenticated, anon using (is_active);

drop policy if exists "admin insert doctors" on public.doctors;
create policy "admin insert doctors" on public.doctors
  for insert to authenticated, anon with check (true);

drop policy if exists "admin update doctors" on public.doctors;
create policy "admin update doctors" on public.doctors
  for update to authenticated, anon using (true) with check (true);

drop policy if exists "admin delete doctors" on public.doctors;
create policy "admin delete doctors" on public.doctors
  for delete to authenticated, anon using (true);

drop policy if exists "read schedules" on public.doctor_schedules;
create policy "read schedules" on public.doctor_schedules
  for select to authenticated, anon using (true);

drop policy if exists "admin insert schedules" on public.doctor_schedules;
create policy "admin insert schedules" on public.doctor_schedules
  for insert to authenticated, anon with check (true);

drop policy if exists "admin delete schedules" on public.doctor_schedules;
create policy "admin delete schedules" on public.doctor_schedules
  for delete to authenticated, anon using (true);

-- Profiles: Own row only (wrapped with (select auth.uid()) for query optimization)
drop policy if exists "read own profile" on public.profiles;
create policy "read own profile" on public.profiles
  for select to authenticated using (id = (select auth.uid()));

drop policy if exists "update own profile" on public.profiles;
create policy "update own profile" on public.profiles
  for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

-- Appointments: Own rows only
drop policy if exists "read own appointments" on public.appointments;
create policy "read own appointments" on public.appointments
  for select to authenticated using (user_id = (select auth.uid()));

drop policy if exists "book own appointment" on public.appointments;
create policy "book own appointment" on public.appointments
  for insert to authenticated with check (user_id = (select auth.uid()));

drop policy if exists "cancel own appointment" on public.appointments;
create policy "cancel own appointment" on public.appointments
  for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- ========== 5. BOOKED SLOTS FUNCTION ==========

create or replace function public.get_booked_slots(p_doctor uuid, p_date date)
returns table (slot_time time)
language sql
security definer set search_path = public
as $$
  select slot_time
    from public.appointments
   where doctor_id = p_doctor
     and appointment_date = p_date
     and status <> 'cancelled';
$$;

grant execute on function public.get_booked_slots(uuid, date) to authenticated, anon;

-- ========== 6. SEED DATA (Aligned with Hospital App) ==========

insert into public.specialties (name_bn) values
  ('গ্যাস্ট্রোএন্টারোলজি'),
  ('মেডিসিন'),
  ('হৃদরোগ'),
  ('শিশু বিশেষজ্ঞ'),
  ('গাইনী ও প্রসূতি'),
  ('নিউরোমেডিসিন'),
  ('অর্থোপেডিকস'),
  ('ইএনটি / নাক-কান-গলা'),
  ('ডায়াবেটিস')
on conflict (name_bn) do nothing;

-- ========== 7. USER ROLES & ADMIN AUTHORIZATION ==========

create table if not exists public.user_roles (
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('admin', 'staff', 'super_admin')),
  created_at timestamptz not null default now(),
  primary key (user_id, role)
);

create index if not exists idx_user_roles_user on public.user_roles(user_id);

create or replace function public.is_admin(p_user_id uuid default auth.uid())
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1
      from public.user_roles
     where user_id = coalesce(p_user_id, auth.uid())
       and role in ('admin', 'super_admin')
  );
$$;

grant execute on function public.is_admin(uuid) to authenticated, anon;

-- ========== 8. FEATURED DOCTORS (TOP / HERO DOCTORS) ==========

create table if not exists public.featured_doctors (
  id uuid primary key default gen_random_uuid(),
  doctor_id uuid not null references public.doctors(id) on delete cascade,
  title text,
  display_order integer not null default 0,
  is_active boolean not null default true,
  starts_at timestamptz,
  ends_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (doctor_id)
);

create index if not exists idx_featured_doctors_doc on public.featured_doctors(doctor_id);
create index if not exists idx_featured_doctors_order on public.featured_doctors(display_order);
create index if not exists idx_featured_doctors_active on public.featured_doctors(is_active);
create index if not exists idx_featured_doctors_visibility 
  on public.featured_doctors(display_order) 
  where is_active = true;

create or replace function public.reorder_featured_doctors(
  p_id uuid,
  p_new_order int
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_old_order int;
begin
  select display_order into v_old_order
    from public.featured_doctors
   where id = p_id;

  if v_old_order is null then
    return;
  end if;

  if p_new_order < 1 then
    p_new_order := 1;
  end if;

  if p_new_order > v_old_order then
    update public.featured_doctors
       set display_order = display_order - 1
     where display_order > v_old_order
       and display_order <= p_new_order
       and id <> p_id;
  elsif p_new_order < v_old_order then
    update public.featured_doctors
       set display_order = display_order + 1
     where display_order >= p_new_order
       and display_order < v_old_order
       and id <> p_id;
  end if;

  update public.featured_doctors
     set display_order = p_new_order
   where id = p_id;

  with ranked as (
    select id, row_number() over (order by display_order asc, updated_at desc) as new_rank
      from public.featured_doctors
  )
  update public.featured_doctors fd
     set display_order = ranked.new_rank
    from ranked
   where fd.id = ranked.id;
end;
$$;

grant execute on function public.reorder_featured_doctors(uuid, int) to authenticated, anon;

-- ========== 9. ADMIN AUDIT LOGS ==========

create table if not exists public.admin_audit_logs (
  id uuid primary key default gen_random_uuid(),
  admin_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id text,
  metadata jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_admin_audit_created on public.admin_audit_logs(created_at desc);

-- ========== 10. RLS FOR FEATURED DOCTORS & ADMIN ==========

alter table public.user_roles enable row level security;
alter table public.featured_doctors enable row level security;
alter table public.admin_audit_logs enable row level security;

drop policy if exists "public read active featured doctors" on public.featured_doctors;
create policy "public read active featured doctors" on public.featured_doctors
  for select to authenticated, anon
  using (
    (
      is_active = true
      and (starts_at is null or starts_at <= now())
      and (ends_at is null or ends_at >= now())
    )
    or public.is_admin()
  );

drop policy if exists "admin manage featured doctors" on public.featured_doctors;
create policy "admin manage featured doctors" on public.featured_doctors
  for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "allow bootstrap admin if no roles" on public.featured_doctors;
create policy "allow bootstrap admin if no roles" on public.featured_doctors
  for all to authenticated
  using ((select count(*) from public.user_roles) = 0)
  with check ((select count(*) from public.user_roles) = 0);

drop policy if exists "admin view audit logs" on public.admin_audit_logs;
create policy "admin view audit logs" on public.admin_audit_logs
  for select to authenticated
  using (public.is_admin() or (select count(*) from public.user_roles) = 0);

drop policy if exists "admin insert audit logs" on public.admin_audit_logs;
create policy "admin insert audit logs" on public.admin_audit_logs
  for insert to authenticated
  with check (public.is_admin() or (select count(*) from public.user_roles) = 0);

