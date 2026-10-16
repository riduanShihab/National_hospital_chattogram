# 🏥 National Hospital Chattogram — Standalone Web Admin Panel

> **Dedicated Web Management Console for Hospital Staff & Medical Coordinators**  
> Decoupled Flutter Web application for managing doctor rosters, featured specialist rankings, visiting chamber schedules, and appointment queues.

---

## 📸 Real Application Screenshots

### 📊 Hospital Admin Dashboard (ড্যাশবোর্ড ও লাইভ পরিসংখ্যান)
![Hospital Admin Dashboard](../docs/screenshots/admin_dashboard.png)

### 🏆 Top Doctors & Hero Specialists Manager (সেরা ডাক্তার ব্যবস্থাপনা)
![Top Doctors Manager](../docs/screenshots/admin_top_doctors.png)

### 🔐 Admin Authentication Gate (নিরাপদ অ্যাডমিন লগইন)
![Admin Login Screen](../docs/screenshots/admin_login.png)

### 📱 Patient Mobile App Ecosystem
| 🏠 হোম ও বিশেষজ্ঞ বিভাগসমূহ | 🩺 বিশেষজ্ঞ ডাক্তার ডিরেক্টরি | 📅 চেম্বার শিডিউল ও বুকিং |
|:---:|:---:|:---:|
| <img src="../docs/screenshots/app_home_top.png" width="280" alt="Patient App Home" /> | <img src="../docs/screenshots/app_doctor_directory.png" width="280" alt="Doctor Directory" /> | <img src="../docs/screenshots/app_doctor_profile.png" width="280" alt="Doctor Profile & Booking" /> |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.13.2+)
- Google Chrome (or modern desktop browser)

### Development Run
```bash
# Navigate to admin_panel directory
cd admin_panel

# Install dependencies
flutter pub get

# Launch on Chrome
flutter run -d chrome
```

### Production Build
```bash
# Compile optimized web bundle
flutter build web
```
The output will be placed in `build/web/`, ready to deploy to any static hosting provider (Vercel, Netlify, Firebase Hosting, Cloudflare Pages).

---

## 📂 Architecture Overview

```text
admin_panel/lib/
├── core/
│   ├── constants/             # Supabase credentials & config
│   └── routes/app_routes.dart # Admin routes & route generator
├── models/
│   └── hospital_models.dart   # Admin stats, audit logs, featured doctor & hospital models
├── screens/
│   ├── admin_login_screen.dart        # Admin staff credentials login
│   ├── admin_shell_screen.dart        # Collapsible responsive sidebar navigation
│   ├── admin_dashboard_screen.dart    # Live operational metric counters
│   ├── admin_top_doctors_screen.dart  # Top / Hero doctors ranking & scheduling
│   ├── admin_doctors_screen.dart      # Doctor directory CRUD & status toggles
│   ├── admin_specialties_screen.dart  # Clinical specialties manager
│   ├── admin_schedules_screen.dart    # Weekly chamber hours & slot configuration
│   ├── admin_appointments_screen.dart # Daily patient appointment queue oversight
│   └── admin_audit_logs_screen.dart   # Immutable security audit log stream
├── services/
│   ├── admin_service.dart     # Admin Top Doctors CRUD, reorder RPC, stats
│   └── supabase_service.dart  # Core Supabase client
├── theme/
│   └── app_theme.dart         # Clean responsive admin dashboard theme
└── main.dart                  # Admin auth state wrapper & entrypoint
```

---

## 🔐 Security & Access Control
- Access is strictly gated by role-based access control (RBAC).
- Verified via PostgreSQL security-definer function `is_admin(auth.uid())` against `public.user_roles`.
- Patient accounts without `admin` privilege are blocked at both UI and database RLS levels.
