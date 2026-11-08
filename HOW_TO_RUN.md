# 🏥 National Hospital Chattogram — Execution & Admin Access Guide
> **User & Developer Guide: Running the Patient App & Web Admin Management Portal**

---

## 📌 1. Ecosystem Overview

This ecosystem consists of two decoupled Flutter projects connecting to a shared Supabase PostgreSQL backend:

| Application | Path | Target Platforms | Key Purpose |
| :--- | :--- | :--- | :--- |
| **📱 Patient App** | `/` (Root directory) | Android, iOS, Chrome (Web), Windows Desktop | Doctor discovery, chamber schedule lookup, phone-first registration, and digital serial appointment booking. |
| **💻 Web Admin Panel** | `/admin_panel` | Web (Google Chrome / Edge / Firefox / Safari) | Doctor roster CRUD, visiting hours configuration, Top Doctors rank reordering, daily serial queue monitoring, and security audit logs. |

---

## 🔑 2. Admin Web Portal Credentials

The Standalone Admin Panel (`/admin_panel`) enforces **Role-Based Access Control (RBAC)** via the `public.user_roles` table and the `is_admin()` database function.

### 🔐 Primary Admin Credentials

* **Admin Portal URL**: `http://localhost:8080` (or the local port assigned by Flutter Web)
* **Admin Email**: `admin@nationalhospital.com`
* **Admin Password**: `<YOUR_CONFIGURED_ADMIN_PASSWORD>` *(min 6 characters, set in Supabase)*
* **Alternative Phone Login**: Your registered phone number *(with your account password)*

---

### 🛡️ Creating or Resetting the Admin Account in Supabase

Because Supabase handles authentication in its own `auth.users` schema, the admin user must exist in your Supabase project with an encrypted password.

To create or reset the admin account, choose either method below:

#### Option 1: Run SQL in Supabase Dashboard (Recommended - 1 Click)
Open your **Supabase Dashboard > SQL Editor**, copy and paste the script from [`supabase/create_admin_user.sql`](supabase/create_admin_user.sql) (or run the snippet below with your password), and click **RUN**:

```sql
create extension if not exists "pgcrypto";

do $$
declare
  v_user_id uuid;
  v_email text := 'admin@nationalhospital.com';
  v_password text := '<YOUR_DESIRED_ADMIN_PASSWORD>'; -- Choose a secure password (min 6 chars)
  v_encrypted_pw text := crypt(v_password, gen_salt('bf'));
begin
  -- 1. Check or create in auth.users
  select id into v_user_id from auth.users where email = v_email;

  if v_user_id is not null then
    update auth.users
       set encrypted_password = v_encrypted_pw,
           email_confirmed_at = coalesce(email_confirmed_at, now()),
           updated_at = now()
     where id = v_user_id;
  else
    v_user_id := gen_random_uuid();
    insert into auth.users (
      instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
      raw_app_meta_data, raw_user_meta_data, created_at, updated_at
    ) values (
      '00000000-0000-0000-0000-000000000000', v_user_id, 'authenticated', 'authenticated',
      v_email, v_encrypted_pw, now(),
      jsonb_build_object('provider', 'email', 'providers', array['email']),
      jsonb_build_object('full_name', 'Hospital Admin'), now(), now()
    );
  end if;

  -- 2. Ensure profile exists in public.profiles
  insert into public.profiles (id, full_name, phone, email)
  values (v_user_id, 'Hospital Admin', '01700000000', v_email)
  on conflict (id) do update set email = v_email;

  -- 3. Grant super_admin & admin permissions
  insert into public.user_roles (user_id, role)
  values (v_user_id, 'super_admin'), (v_user_id, 'admin')
  on conflict (user_id, role) do nothing;
end $$;
```

#### Option 2: Create via Supabase Dashboard UI
1. Go to your **Supabase Dashboard** > **Authentication** > **Users**.
2. Click **Add User** > **Create User**.
3. **Email**: `admin@nationalhospital.com`
4. **Password**: `<YOUR_DESIRED_ADMIN_PASSWORD>`
5. Turn on **"Auto Confirm User?"** (Checked).
6. Click **Create User**.
7. In the **SQL Editor**, grant admin permissions:
   ```sql
   insert into public.user_roles (user_id, role)
   select id, 'super_admin' from auth.users where email = 'admin@nationalhospital.com'
   on conflict (user_id, role) do nothing;
   ```

#### Option 3: Use an Existing Registered Phone Account
If you already registered an account in the Patient App (e.g., with mobile `01712345678` and your password):
1. In Supabase **SQL Editor**, run:
   ```sql
   insert into public.user_roles (user_id, role)
   select id, 'super_admin' from auth.users
   on conflict (user_id, role) do nothing;
   ```
2. Now log in to the admin panel using that mobile number and password!

---

## 🚀 3. Step-by-Step Execution Guide

### 📋 Prerequisites
Make sure your environment has:
- **Flutter SDK**: `v3.13.2` or newer (`flutter --version`)
- **Google Chrome**: For running the web clients
- **Android Studio / VS Code**: With Flutter & Dart extensions installed
- **Connected Android Device / Emulator**: (If testing mobile)

---

### 📱 A. How to Run the Patient App (`/`)

#### 1. Open Terminal in the Root Directory:
```bash
cd e:\National_hospital_chattogram
```

#### 2. Get Dependencies:
```bash
flutter pub get
```

#### 3. Run on Your Desired Platform:

* **Run on Web (Google Chrome)**:
  ```bash
  flutter run -d chrome
  ```

* **Run on Android (Physical Device or Emulator)**:
  ```bash
  flutter run -d android
  ```

* **Run on Windows Desktop**:
  ```bash
  flutter run -d windows
  ```

#### 4. Patient Login / Registration Testing:
- Open the app (displays the 4-second animated brand launch splash screen).
- **Register a New Patient**:
  - **Mobile Number**: `01712345678` (any valid 11-digit Bangladeshi number)
  - **Full Name**: `আব্দুর রহিম`
  - **Password**: `123456`
  - **Email**: *(Optional - can be left blank)*
- Tap **"নিবন্ধন করুন" (Register)** — the app uses custom PostgreSQL RPCs to instantly pre-confirm your account without email verification delays.

---

### 💻 B. How to Run the Web Admin Panel (`/admin_panel`)

#### 1. Navigate to the Admin Panel Directory:
```bash
cd e:\National_hospital_chattogram\admin_panel
```

#### 2. Get Admin Dependencies:
```bash
flutter pub get
```

#### 3. Launch in Google Chrome:
```bash
# Run with a fixed local port (recommended for bookmarking):
flutter run -d chrome --web-port 8080

# Or run with dynamic port:
flutter run -d chrome
```

#### 4. Log in to the Admin Dashboard:
1. When Chrome opens, you will see the **National Hospital Admin Portal Login Gate**.
2. Enter the admin credentials:
   - **ইমেইল বা মোবাইল**: `admin@nationalhospital.com`
   - **পাসওয়ার্ড**: `<YOUR_CONFIGURED_ADMIN_PASSWORD>`
3. Click **"অ্যাডমিন লগইন"**.
4. You will be redirected to the **Admin Dashboard** (`/admin/dashboard`), featuring:
   - 📊 Operational KPI Cards (Total Doctors, Active Chambers, Featured Specialists, Appointments)
   - 🏆 **Top Doctors Manager**: Reorder featured doctors with `▲ উপরে` / `▼ নিচে` buttons and inspect the live mobile preview.
   - 🩺 **Doctor Directory**: Toggle active status, edit degrees, fees, and chamber room numbers.
   - 🏢 **Specialties Manager**: Add and manage hospital clinical departments.
   - ⏰ **Chamber Schedules**: Configure weekly visiting hours and per-patient slot durations.
   - 📋 **Appointment Queue**: Search by serial number or phone, inspect appointments, and update booking status.
   - 📜 **Security Audit Logs**: Real-time immutable record of administrative actions.

---

## 🏗️ 4. Production Web Build & Vercel Deployment

Both the **Admin Panel** and the **Patient Web App** can be deployed to **Vercel** as static single-page applications (SPAs).

### ⚙️ Step 4.1: Single-Page App (SPA) Routing with `vercel.json`
To ensure that refreshing any sub-route (e.g., `/admin/dashboard` or `/appointments`) does not return a 404 error, a `vercel.json` file has been placed in both projects:
```json
{
  "version": 2,
  "cleanUrls": true,
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

---

### 🚀 Step 4.2: Deploying to Vercel (Fastest Method — Via Vercel CLI)

Since Node.js is installed on your machine, you can deploy the pre-built web bundles directly in less than 1 minute:

#### A. Deploy the Web Admin Panel:
```bash
# 1. Build the Admin Panel
cd e:\National_hospital_chattogram\admin_panel
flutter build web --release

# 2. Deploy the build directory directly to Vercel Production
cd build\web
npx vercel --prod
```

#### B. Deploy the Patient Web App:
```bash
# 1. Build the Patient App
cd e:\National_hospital_chattogram
flutter build web --release

# 2. Deploy to Vercel Production
cd build\web
npx vercel --prod
```

> **First-time prompt tips for Vercel CLI:**
> - `Set up and deploy?` → Type **`y`** (Enter)
> - `Which scope?` → Select your Vercel account
> - `Link to existing project?` → Type **`n`**
> - `Project name?` → e.g. `national-hospital-admin` (or `national-hospital-patient`)
> - `In which directory is your code located?` → Press **Enter** (`.`)
> 
> Vercel will upload the bundle and immediately provide a live production HTTPS URL (e.g. `https://national-hospital-admin.vercel.app`).

---

### 🌐 Step 4.3: Deploying via GitHub on Vercel Dashboard

If connecting your GitHub repository to Vercel:
1. Go to [vercel.com](https://vercel.com) and click **"Add New Project"**.
2. Import your `National_hospital_chattogram` repository.
3. Configure the Project Settings:
   * **Root Directory**: `admin_panel` *(for Admin)* OR `.` *(for Patient App)*.
   * **Framework Preset**: `Other`.
   * **Build Command**: Custom Flutter build or leave blank if deploying pre-built `build/web`.
   * **Output Directory**: `build/web`.
4. Click **Deploy**.

---

## 🧪 5. Testing & Code Quality Verification

To verify that all routes, models, and UI components are functional without errors:

```bash
# 1. Test Patient Application
cd e:\National_hospital_chattogram
flutter analyze
flutter test

# 2. Test Admin Panel Application
cd e:\National_hospital_chattogram\admin_panel
flutter analyze
flutter test
```

---

## 🛠️ 6. Troubleshooting & Reset

### Clean Build Cache
If you encounter caching or dependency mismatches:
```powershell
# Using the bundled PowerShell cleanup script:
.\clean.ps1

# Or manually:
flutter clean
flutter pub get
```

### Port Already in Use
If port `8080` is occupied, run with a different port:
```bash
flutter run -d chrome --web-port 8085
```
