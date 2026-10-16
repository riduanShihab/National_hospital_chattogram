-- ==============================================================================
-- National Hospital Chattogram: Top Doctors & Admin Panel Migration
-- Features:
--   1. public.user_roles table & public.is_admin() security function
--   2. public.featured_doctors table (Top Doctors / Hero Doctors)
--   3. public.admin_audit_logs table
--   4. Reordering RPC public.reorder_featured_doctors()
--   5. Row Level Security (RLS) for public view and admin management
--   6. Initial seed for featured doctors
-- ==============================================================================

-- Enable UUID / Crypto if not already enabled
create extension if not exists "pgcrypto";

-- ========== 1. USER ROLES & ADMIN AUTHORIZATION ==========

create table if not exists public.user_roles (
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('admin', 'staff', 'super_admin')),
  created_at timestamptz not null default now(),
  primary key (user_id, role)
);

create index if not exists idx_user_roles_user on public.user_roles(user_id);

-- Helper function to check if a user is an authorized admin
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

-- ========== 2. FEATURED DOCTORS (TOP / HERO DOCTORS) ==========

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

-- Indexes for fast ordering, active filtering, and doctor joins
create index if not exists idx_featured_doctors_doc on public.featured_doctors(doctor_id);
create index if not exists idx_featured_doctors_order on public.featured_doctors(display_order);
create index if not exists idx_featured_doctors_active on public.featured_doctors(is_active);
create index if not exists idx_featured_doctors_visibility 
  on public.featured_doctors(display_order) 
  where is_active = true;

-- Auto-update updated_at timestamp trigger
create or replace function public.update_featured_doctor_timestamp()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_featured_doctors_timestamp on public.featured_doctors;
create trigger trg_featured_doctors_timestamp
  before update on public.featured_doctors
  for each row execute function public.update_featured_doctor_timestamp();

-- ========== 3. REORDERING & RANK NORMALIZATION RPC ==========

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

  -- Dense normalization (1, 2, 3...)
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

-- ========== 4. ADMIN AUDIT LOGS ==========

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
create index if not exists idx_admin_audit_entity on public.admin_audit_logs(entity_type, entity_id);

-- ========== 5. ROW LEVEL SECURITY (RLS) ==========

alter table public.user_roles enable row level security;
alter table public.featured_doctors enable row level security;
alter table public.admin_audit_logs enable row level security;

-- user_roles policies
drop policy if exists "user_roles read policy" on public.user_roles;
create policy "user_roles read policy" on public.user_roles
  for select to authenticated, anon
  using (user_id = auth.uid() or public.is_admin());

drop policy if exists "user_roles admin modify" on public.user_roles;
create policy "user_roles admin modify" on public.user_roles
  for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- featured_doctors policies
-- 1. Patients / Public can read active and unexpired top doctors
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

-- 2. Admins can insert/update/delete featured doctors
drop policy if exists "admin manage featured doctors" on public.featured_doctors;
create policy "admin manage featured doctors" on public.featured_doctors
  for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- Fallback for development / initial admin configuration (allow authenticated if user_roles empty)
drop policy if exists "allow bootstrap admin if no roles" on public.featured_doctors;
create policy "allow bootstrap admin if no roles" on public.featured_doctors
  for all to authenticated
  using ((select count(*) from public.user_roles) = 0)
  with check ((select count(*) from public.user_roles) = 0);

-- admin_audit_logs policies
drop policy if exists "admin view audit logs" on public.admin_audit_logs;
create policy "admin view audit logs" on public.admin_audit_logs
  for select to authenticated
  using (public.is_admin() or (select count(*) from public.user_roles) = 0);

drop policy if exists "admin insert audit logs" on public.admin_audit_logs;
create policy "admin insert audit logs" on public.admin_audit_logs
  for insert to authenticated
  with check (public.is_admin() or (select count(*) from public.user_roles) = 0);

-- Admin read on appointments (admins can view all appointments, not just their own)
drop policy if exists "admin read all appointments" on public.appointments;
create policy "admin read all appointments" on public.appointments
  for select to authenticated
  using (user_id = auth.uid() or public.is_admin() or (select count(*) from public.user_roles) = 0);

drop policy if exists "admin update any appointment" on public.appointments;
create policy "admin update any appointment" on public.appointments
  for update to authenticated
  using (user_id = auth.uid() or public.is_admin() or (select count(*) from public.user_roles) = 0)
  with check (user_id = auth.uid() or public.is_admin() or (select count(*) from public.user_roles) = 0);

-- ========== 6. SEED INITIAL TOP DOCTORS ==========

-- Automatically feature the top 3-5 existing active doctors if featured_doctors is empty
insert into public.featured_doctors (doctor_id, title, display_order, is_active)
select 
  d.id,
  'সিনিয়র কনসালট্যান্ট' as title,
  row_number() over (order by d.name_bn asc) as display_order,
  true as is_active
from public.doctors d
where d.is_active = true
limit 4
on conflict (doctor_id) do nothing;
