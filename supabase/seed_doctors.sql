-- ==============================================================================
-- National Hospital Chattogram: Insert Doctors & Schedules
-- Run in Supabase Dashboard > SQL Editor
-- ==============================================================================

-- 1. Ensure specialties exist
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

-- 2. Insert Doctors (with specialty_id lookup and photo_url)
insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
values
  (
    'ডা. তাসবীরুল হাসান জিহান',
    'এমবিবিএস (সিএমসি), বিসিএস (স্বাস্থ্য), এমডি (গ্যাস্ট্রোএন্টারোলজি), বিএসএমএমইউ, এমআরসিপি (পেসিস)',
    (select id from public.specialties where name_bn = 'গ্যাস্ট্রোএন্টারোলজি'),
    12,
    'পরিপাকতন্ত্র, লিভার ও মেডিসিন বিশেষজ্ঞ চিকিৎসক।',
    'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80',
    1000,
    '৪০২ নং রুম (৪র্থ তলা)',
    true
  ),
  (
    'ডা. মোহাম্মদ জসিম উদ্দিন',
    'এমবিবিএস, এফসিপিএস (মেডিসিন), এমডি (ইন্টারনাল মেডিসিন)',
    (select id from public.specialties where name_bn = 'মেডিসিন'),
    15,
    'মেডিসিন ও ডায়াবেটিস বিশেষজ্ঞ চিকিৎসক।',
    'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80',
    800,
    '৩০৫ নং রুম (৩য় তলা)',
    true
  ),
  (
    'অধ্যাপক ডা. ফাতেমা খাতুন',
    'এমবিবিএস, ডিজিও, এফসিপিএস (গাইনী ও প্রসূতি)',
    (select id from public.specialties where name_bn = 'গাইনী ও প্রসূতি'),
    20,
    'স্ত্রীরোগ, প্রসূতি ও বন্ধ্যাত্ব বিশেষজ্ঞ সার্জন।',
    'https://images.unsplash.com/photo-1594824813637-4560b452601c?w=400&auto=format&fit=crop&q=80',
    1200,
    '২০১ নং রুম (২য় তলা)',
    true
  ),
  (
    'ডা. আনোয়ারুল হক',
    'এমবিবিএস, এমডি (কার্ডিওলজি), এফএসিসি (আমেরিকা)',
    (select id from public.specialties where name_bn = 'হৃদরোগ'),
    18,
    'হৃদরোগ, উচ্চ রক্তচাপ ও ইন্টারভেনশনাল কার্ডিওলজিস্ট।',
    'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&auto=format&fit=crop&q=80',
    1200,
    '৫০১ নং রুম (৫ম তলা)',
    true
  );

-- 3. Insert Schedules for the doctors
-- Weekday mapping: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
select id, 6, '17:00:00', '20:00:00', 15 from public.doctors where name_bn = 'ডা. তাসবীরুল হাসান জিহান' union all -- Saturday
select id, 0, '17:00:00', '20:00:00', 15 from public.doctors where name_bn = 'ডা. তাসবীরুল হাসান জিহান' union all -- Sunday
select id, 2, '17:00:00', '20:00:00', 15 from public.doctors where name_bn = 'ডা. তাসবীরুল হাসান জিহান' union all -- Tuesday
select id, 6, '18:00:00', '21:00:00', 15 from public.doctors where name_bn = 'ডা. মোহাম্মদ জসিম উদ্দিন' union all
select id, 1, '18:00:00', '21:00:00', 15 from public.doctors where name_bn = 'ডা. মোহাম্মদ জসিম উদ্দিন' union all
select id, 0, '16:00:00', '19:00:00', 15 from public.doctors where name_bn = 'অধ্যাপক ডা. ফাতেমা খাতুন' union all
select id, 2, '16:00:00', '19:00:00', 15 from public.doctors where name_bn = 'অধ্যাপক ডা. ফাতেমা খাতুন';
