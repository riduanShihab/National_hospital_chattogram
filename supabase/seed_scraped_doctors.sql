-- ==============================================================================
-- National Hospital Chattogram: Scraped Doctors & Schedules Import
-- Total Doctors: 113
-- Source: https://nationalhospital.com.bd/Doctors
-- Validated 24h format times and PostgreSQL time ranges
-- ==============================================================================

-- 1. Insert All Specialties
insert into public.specialties (name_bn) values
  ('জনস্বাস্থ্য ও সাধারণ চিকিৎসা'),
  ('গ্যাস্ট্রোএন্টারোলজি'),
  ('নিউরোমেডিসিন'),
  ('মেডিসিন'),
  ('ক্যান্সার বিশেষজ্ঞ (অনকোলজি)'),
  ('শিশু সার্জারি'),
  ('চর্ম ও যৌন রোগ'),
  ('ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন'),
  ('ইউরোলজি'),
  ('পুষ্টি ও খাদ্য বিশেষজ্ঞ'),
  ('ইএনটি / নাক-কান-গলা'),
  ('চক্ষু রোগ বিশেষজ্ঞ'),
  ('গাইনী ও প্রসূতি'),
  ('অর্থোপেডিকস'),
  ('নিউরোসার্জারি (ব্রেন ও স্পাইন)'),
  ('হৃদরোগ (কার্ডিওলজি)'),
  ('কিডনি রোগ (নেফ্রোলজি)'),
  ('মনোরোগ বিশেষজ্ঞ (সাইকিয়াট্রি)'),
  ('জেনারেল সার্জারি'),
  ('কার্ডিওভাসকুলার সার্জারি'),
  ('রক্তরোগ বিশেষজ্ঞ (হেমাটোলজি)'),
  ('ডায়াবেটিস ও থাইরয়েড'),
  ('বক্ষব্যাধি ও খাদ্যনালী'),
  ('শিশু বিশেষজ্ঞ'),
  ('হেপাটোলজি / লিভার'),
  ('বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন'),
  ('বাতরোগ বিশেষজ্ঞ (রিউমাটোলজি)'),
  ('প্লাস্টিক ও বার্ন সার্জারি')
on conflict (name_bn) do nothing;

-- 2. Insert Doctors & Schedules

-- Doctor 1: Professor Dr. Mohammad Jalal Uddin (জনস্বাস্থ্য ও সাধারণ চিকিৎসা)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জনস্বাস্থ্য ও সাধারণ চিকিৎসা';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জনস্বাস্থ্য ও সাধারণ চিকিৎসা') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Mohammad Jalal Uddin',
    'MBBS, MPH, CCD',
    v_spec_id,
    15,
    'Professor Doctor Mohammad Jalal Uddin is a highly respected and experienced medical professional who has dedicated his career to improving healthcare. With degrees in MBBS, MPH, and CCD, he possesses a broad knowledge base in the medical field. As a Professor at Chattogram Maa-O-Shishu Hospital, he imparts his wisdom and expertise to the next generation of healthcare practitioners. Dr. Uddin''s commitment to patient care extends to his chambers at National Hospital Chattogram and Sigma Lab Ltd.,',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_73055448-dacc-43af-9be3-adc3fe0950e1.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 2: Dr. Shamim Boksha (গ্যাস্ট্রোএন্টারোলজি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গ্যাস্ট্রোএন্টারোলজি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গ্যাস্ট্রোএন্টারোলজি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Shamim Boksha',
    'MBBS,FCPS(Medicine), MD(Gastroenterology)',
    v_spec_id,
    15,
    'Dr. Shamim Boksha is a highly regarded specialist in gastroenterology, offering exceptional care and expertise in Chittagong. As a gastroenterologist, his scope of practice extends beyond the gastrointestinal tract, encompassing other crucial organs involved in digestion, such as the gallbladder, pancreas, and liver. With years of experience, Dr. Boksha has earned a reputation as the best in his field, particularly when it comes to managing chronic hepatitis infections. One of the essential serv',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_7a4beecd-4afc-41ab-9e10-c2c97ce20992.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 3: Dr. Mohammad Jashim Uddin (গ্যাস্ট্রোএন্টারোলজি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গ্যাস্ট্রোএন্টারোলজি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গ্যাস্ট্রোএন্টারোলজি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Jashim Uddin',
    'MBBS,FCPS (Medicine),MD (Gastroenterology)',
    v_spec_id,
    15,
    'Dr. Mohammad Jashim Uddin is a beacon of medical excellence in Chittagong, distinguished for his Gastroenterology and Medicine Specialist expertise. Holding an MBBS degree, FCPS in Medicine, and an MD in Gastroenterology, his qualifications showcase a deep comprehension of gastrointestinal health. As a Consultant in the Department of Gastroenterology at National Hospital, Chittagong, he provides specialized care, addressing a spectrum of gastrointestinal issues. Dr. Mohammad Jashim Uddin''s cham',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_b4972435-fb90-415c-a105-56d16e694766.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '14:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '14:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '14:00:00', '21:00:00', 15);
end $$;

-- Doctor 4: Dr. Tasbirul Hasan Zihan (গ্যাস্ট্রোএন্টারোলজি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গ্যাস্ট্রোএন্টারোলজি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গ্যাস্ট্রোএন্টারোলজি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Tasbirul Hasan Zihan',
    'MBBS (CMC), BCS (Health), MD (Gastroenterology), BSMMU, Dept. of Gastroenterology, Chittagong Medical College &amp; Hospital',
    v_spec_id,
    15,
    'Dr. Tasbirul Hasan Zihan, an accomplished Gastroliver and Medicine Specialist, shines as a prominent figure in the medical landscape of Chittagong. His qualifications, which include an MBBS degree, BCS in Health, MD in Gastroenterology, and MRCP (UK), attest to his extensive knowledge in the field. As a Consultant in the Gastroenterology Department at Chittagong Medical College Hospital, he is recognized for his contributions to specialized medical care. Patients seeking his expertise can benefi',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_d7604e40-8ade-4395-9eed-9e5ec685edcd.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:30:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:30:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:30:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:30:00', '17:00:00', 15);
end $$;

-- Doctor 5: Dr. Muhammad Mobinul Hoque Chowdhury (নিউরোমেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোমেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোমেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Muhammad Mobinul Hoque Chowdhury',
    'MBBS(CMC), BCS(HEALTH),MD(NEUROMEDICINE),BSMMU',
    v_spec_id,
    15,
    'Neuromedicine Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_63b17876-c9ee-4a7d-8f74-44c8d8e3ea98.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 6: Dr. Naima Masrura (নিউরোমেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোমেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোমেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Naima Masrura',
    'MBBS (CMC), BCS (Health), MD (Neurology)',
    v_spec_id,
    15,
    'Dr. Naima Masrura is a Brain & Neuromedicine Specialist in Chittagong, Bangladesh. With an M.B.B.S. (C.M.C.), B.C.S. (Health), M.D. (Neurology), and years of experience, she offers exceptional care for patients with brain-related conditions as an Assistant Professor at the Department of Neurology Chittagong Medical College Hospital. Dr. Naima Masrura''s expertise extends to various neurological disorders, including migraines, epilepsy, stroke, movement disorders, and neuropathies. Patients can c',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_6155ead5-d25f-4e41-8694-c6ca36c135ef.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 7: Professor Dr. Touhidur Rahman (নিউরোমেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোমেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোমেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Touhidur Rahman',
    'MBBS, BCS (Health),  MD(Neurology)',
    v_spec_id,
    15,
    'Central nervous system Peripheral nervous system Cerebrovascular disease, such as stroke Demyelinating diseases of the central nervous system, such as multiple sclerosis Headache disorders Infections of the brain and peripheral nervous system Movement disorders, such as Parkinson&#x2019;s disease Neurodegenerative disorders, such as Alzheimer&#x2019;s disease, Parkinson&#x2019;s disease, and Amyotrophic Lateral Sclerosis (Lou Gehrig&#x2019;s disease) Seizure disorders, such as epilepsy Spinal co',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_8074bb68-62b1-4f54-9f76-0e26b430f00d.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 8: Professor Dr. Mohammad Mohitul Islam (নিউরোমেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোমেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোমেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Mohammad Mohitul Islam',
    'MBBS, BCS(HEALTH),MD(NEUROMEDICINE),BSMMU',
    v_spec_id,
    15,
    'Dr. Mohammad Mohitul Islam is a Neuromedicine Specialist in Chittagong, Bangladesh. With an MD in Neuro Medicine and years of experience, he offers exceptional care for patients with brain-related conditions. As an Associate Professor at Chittagong Medical College Hospital, Dr. Mohammad Mohitul Islam expertise extends to various neurological disorders, including migraines, epilepsy, stroke, movement disorders, and neuropathies. Patients can consult him at National Hospital Chattagram, Room No. 4',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_91ddc381-ed30-4d42-9661-9436646baff3.webp',
    1000,
    '৪০২ নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 9: Professor  Dr. Muhammad Tayeb (নিউরোমেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোমেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোমেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor  Dr. Muhammad Tayeb',
    'MBBS, BCS (Health), MD(Neuro Medicine)',
    v_spec_id,
    15,
    'Central nervous system Peripheral nervous system Cerebrovascular disease, such as stroke Demyelinating diseases of the central nervous system, such as multiple sclerosis Headache disorders Infections of the brain and peripheral nervous system Movement disorders, such as Parkinson&#x2019;s disease Neurodegenerative disorders, such as Alzheimer&#x2019;s disease, Parkinson&#x2019;s disease, and Amyotrophic Lateral Sclerosis (Lou Gehrig&#x2019;s disease) Seizure disorders, such as epilepsy Spinal co',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_fc57d9d1-9f9e-4d19-859a-c8270bd00da1.webp',
    1000,
    '4005 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '21:00:00', 15);
end $$;

-- Doctor 10: Dr. Md. Shamchul Alam (নিউরোমেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোমেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোমেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Shamchul Alam',
    'MBBS, BCS (Health), MD(Neurology) BSMMU Neuromedicine Specialist',
    v_spec_id,
    15,
    'Neurology Specialist (Stroke, Headache, Epilepsy, Paralysis)',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_f6719934-fb38-4d46-9479-dc3b080c4587.webp',
    1000,
    '4009 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '19:00:00', 15);
end $$;

-- Doctor 11: Dr. Shamsuddin Ahmed Shiblu (নিউরোমেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোমেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোমেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Shamsuddin Ahmed Shiblu',
    'MBBS, BCS (Health), and MD (Neurology)',
    v_spec_id,
    15,
    'Neuro Medicine Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_4dbce5aa-0fc7-40cd-a805-0b133b46abc5.webp',
    1000,
    '2016 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 12: Dr. Murad Mohammed Faisal (Hero) (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Murad Mohammed Faisal (Hero)',
    'MBBS, BCS(Health), FCPS (Medicine), MACP(USA)',
    v_spec_id,
    15,
    'Dr. Murad Mohammed Faisal (Hero) is a highly regarded medical professional with a dedication to healthcare excellence. His qualifications include an MBBS degree, BCS (Health), and FCPS (Medicine), which reflect his deep knowledge and expertise in the field of medicine. Patients in need of medical care can find solace in his chambers at National Hospital Chattogram and Sigma Lab Ltd. Dr. Hero is known for his commitment to patient well-being, offering consultations every day from 7pm to 10pm, wit',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_c93bb303-b696-4825-854d-3724f2162d5f.webp',
    1000,
    '4023 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 13: Dr. Mohammad Forhad (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Forhad',
    'MBBS (SSMC), MRCP(London)',
    v_spec_id,
    15,
    'Medicine, Diabetes and Rheumatology',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_35649f22-5b81-409b-893d-cb3a8acf94b2.webp',
    1000,
    '2001 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '11:00:00', '14:00:00', 15);
end $$;

-- Doctor 14: Professor Dr. Md. Abu Naser Siddique (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Md. Abu Naser Siddique',
    'MBBS, BCS (Health), FCPS (Medicine)',
    v_spec_id,
    15,
    'Dr. Md. Abu Naser Siddique is a Medicine Specialist in Chittagong and holds impressive qualifications, including MBBS, BCS (Health), and FCPS (Medicine). Currently serving as an Assistant Professor in the Medicine Department at Chittagong Medical College & Hospital, he is committed to academic and medical excellence. With a regular practice at the National Hospital, Chittagong, Dr. Siddique extends his expertise to provide comprehensive treatment to his patients. Operating from 4.00 p.m. to 6.00',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_b4239bd9-4000-4685-a628-17ded6e06718.webp',
    1000,
    '4019 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '18:00:00', 15);
end $$;

-- Doctor 15: Dr. Mohammad Rezaul Karim (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Rezaul Karim',
    'MBBS, BCS (Health), MD (Internal Medicine)',
    v_spec_id,
    15,
    'Dr. Mohammad Rezaul Karim, an accomplished Medicine Specialist, is dedicated to providing comprehensive medical care in Chittagong. With an impressive educational background, including an MBBS, BCS (Health), and MD in Internal Medicine, Dr. Karim brings a wealth of knowledge to his practice. Currently serving as an Assistant Professor in the Department of Medicine at Chittagong Medical College & Hospital, he is deeply committed to advancing medical education and patient care. Patients seeking hi',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_8eafb5f3-c818-45ca-89d7-271a33d7ce9d.webp',
    1000,
    '3016 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 16: Dr. Md. Ferdous (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Ferdous',
    'MBBS, BCS (Health) Ex,  MD (Internal Medicine)',
    v_spec_id,
    15,
    'Dr. Md. Ferdous is a distinguished Medicine Specialist based in Chittagong, renowned for his exceptional medical expertise. With a comprehensive educational background, MBBS, BCS (Health), and MD in Internal Medicine, he has a solid medical practice foundation. Serving as a Consultant in the esteemed Department of Medicine at National Hospital, Chittagong, Dr. Ferdous brings his extensive knowledge to the forefront of patient care. Patients needing his expertise can avail themselves of his servi',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_1643b036-992e-4ff4-a2c8-77fe54728d06.webp',
    1000,
    '3020 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 17: Professor Dr. A.S.M Zahed (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. A.S.M Zahed',
    'MBBS, BCS (Health),  FCPS (Medicine)',
    v_spec_id,
    15,
    'Professor Dr. A.S.M Zahed a highly regarded Medicine Specialist whose expertise spans an impressive range of medical fields. He holds an MBBS and FCPS in Medicine and is an Professor at Chattogram Medical College Hospital. Prof. Dr. Zahed''s proficiency is evident in his extensive specialist areas, encompassing critical domains like cardiovascular disease, endocrinology, gastroenterology, infectious diseases, and more. With a focus on advanced heart failure, transplant cardiology, and critical c',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_28fd23e1-d382-47cb-a3a9-504694354892.webp',
    1000,
    '3023 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 18: Dr. Mosharraf Hossen (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mosharraf Hossen',
    'MBBS, BCS (Health), MD (Internal Medicine),Special training in Neuro-medicine.',
    v_spec_id,
    15,
    'Dr. Mosharraf Hossen stands as a prominent Medicine Specialist in Chittagong, armed with MBBS, BCS (Health), and MD (Internal Medicine). With a dedicated commitment to his field, he serves as an Assistant Professor (EX) in the Medicine Department at Chittagong Medical College Hospital. Patients seeking expert medical care can find solace in his expertise at National Hospital, Chittagong, where he offers treatment and guidance. Dr. Hossen''s chamber warmly welcomes patients on Sundays, Tuesdays, ',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_44738668-96b2-4ae5-9f05-057188824c3b.webp',
    1000,
    '2013 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 19: Dr. S.M Kamrul Haque (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. S.M Kamrul Haque',
    'MBBS,BCS(Health), MD (Int. Medicine)',
    v_spec_id,
    15,
    'Dr. S.M. Kamrul Haque, a distinguished Medicine and Diabetes Specialist, provides various medical services. With expertise in internal medicine, he is adept at diagnosing and managing multiple general medical conditions. Dr. S.M. Kamrul Haque possesses specialized knowledge in the diagnosis, treatment, and ongoing management of diabetes, making him a trusted resource for individuals with this metabolic disorder. Additionally, he offers comprehensive care for patients with chronic conditions such',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_3b5514e2-4f40-44df-b484-1db8e9d89821.webp',
    1000,
    '3007 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '21:00:00', 15);
end $$;

-- Doctor 20: Dr. A.M Shahed (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. A.M Shahed',
    'MBBS, BCS (Health), FCPS (Medicine)',
    v_spec_id,
    15,
    'Dr. A.M Shahed is a highly esteemed and accomplished medical professional, holding the impressive qualifications of an MBBS from CMC, BCS (Health), and FCPS (Medicine). As a Consultant in Medicine at Chittagong Medical College & Hospital, Dr. Shahed has earned a reputation for his expertise and dedication to patient care. He extends his medical acumen and compassionate approach to his chambers at National Hospital Chattogram and Sigma Lab Ltd., where patients can seek his services with the assur',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_f57292de-0a0b-422a-9e5b-4a2876f4d235.webp',
    1000,
    '2027 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '20:00:00', 15);
end $$;

-- Doctor 21: Dr. Farzin Akter (মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Farzin Akter',
    'MBBS (CMC), BCS ( Health), FCPS (Medicine)',
    v_spec_id,
    15,
    'Dr. Farzin Akter is a highly qualified Medicine Specialist with impressive credentials, including an MBBS from CMC, BCS (Health), and FCPS (Medicine). She offers her expertise and compassionate care at National Hospital Chattogram and Sigma Lab Ltd., with visiting hours available every day from 6pm to 9pm, ensuring accessibility for patients. While Dr. Farzin Akter provides her invaluable medical services throughout the week, she observes Thursdays and Fridays as her days of rest. Patients can s',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_ea66238d-d370-4d47-b3f2-a972d70207ee.webp',
    1000,
    '3004 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:30:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:30:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:30:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:30:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:30:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:30:00', '21:00:00', 15);
end $$;

-- Doctor 22: Dr. Mohammad Nasir Uddin (ক্যান্সার বিশেষজ্ঞ (অনকোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ক্যান্সার বিশেষজ্ঞ (অনকোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ক্যান্সার বিশেষজ্ঞ (অনকোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Nasir Uddin',
    'MBBS, BCS(Health), MCPS(Oncology),Special training in chemotherapy &amp; radiotherapy',
    v_spec_id,
    15,
    'Oncology',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_147ab974-5201-42f5-be6d-0dcbac4db603.webp',
    1000,
    '2018 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 23: DR. Nasir Uddin Mahamud (Shuvo) (ক্যান্সার বিশেষজ্ঞ (অনকোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ক্যান্সার বিশেষজ্ঞ (অনকোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ক্যান্সার বিশেষজ্ঞ (অনকোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'DR. Nasir Uddin Mahamud (Shuvo)',
    'MBBS, BCS (HEALTH), FCPS(Radiotherapy), Medical &amp; radiation Oncologist,  CLINICAL &amp; RADIATION ONCOLOGIST, CHOTTOGRAM MEDICAL COLLEGE HOSPITAL',
    v_spec_id,
    15,
    'Cancer Specialist (Oncologist)',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_1510421f-d157-4e8f-8f93-361129c52b95.webp',
    1000,
    '4022 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '20:00:00', '22:00:00', 15);
end $$;

-- Doctor 24: Dr. Md. Hasan Ullah (শিশু সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Hasan Ullah',
    'MBBS (CU),  MS- Pediatric Surgery (BSMMU)',
    v_spec_id,
    15,
    'PEDIATRIC  SURGERY',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_0f84a27b-4a5e-45eb-8ee2-932b587f01e7.webp',
    1000,
    '4021 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 25: Dr. M.A Mushfiqur Rahman (Piku) (শিশু সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. M.A Mushfiqur Rahman (Piku)',
    'MBBS,BCS(health),FCPS(Surgery) ,MS(Child Surgery)',
    v_spec_id,
    15,
    'Pediatric Surgery & Pediatric Urology',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_ef7ea336-3afe-45a1-82a0-5c1cc4c6b27e.webp',
    1000,
    '3006 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 26: Professor Dr. Mahfuzul Kabir (শিশু সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Mahfuzul Kabir',
    'MBBS,MS(Child Surgery)',
    v_spec_id,
    15,
    'Pediatric Surgery',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_9edbad87-85d5-4f9a-bfdd-e0af00c262d5.webp',
    1000,
    '4019 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:30:00', '21:30:00', 15);
end $$;

-- Doctor 27: Dr. Md. Amir Khasru (চর্ম ও যৌন রোগ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চর্ম ও যৌন রোগ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চর্ম ও যৌন রোগ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Amir Khasru',
    'MBBS, DDV',
    v_spec_id,
    15,
    'Dr. Amir Khasru is a distinguished Dermatology specialist renowned for his medical prowess and qualifications. He has degrees in MBBS, CCD, and DVD, so he exemplifies a comprehensive understanding of dermatological health. Within the medical landscape of Chittagong, Dr. Khasru has established his practice at the reputable National Hospital. The chamber''s location at 14/15 Dampara Lane, Mehedibag, Chattogram, becomes a hub of medical solace for those seeking expert dermatological care. Dr. Amir ',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_03ebad93-b848-46de-8550-7e9c9abbf0e2.webp',
    1000,
    '4018 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '22:00:00', 15);
end $$;

-- Doctor 28: Dr. Didaruzzaman (চর্ম ও যৌন রোগ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চর্ম ও যৌন রোগ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চর্ম ও যৌন রোগ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Didaruzzaman',
    'MBBS(Dhaka),DD(Thai-Japan),POST DOC-FELLOWSHIP IN STD &amp; AIDS (America)',
    v_spec_id,
    15,
    'Dermatology, Venereal Diseases, Allergy, Hair, Nail & AIDS Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_7cc11fc8-e334-4bda-afcb-2df0df4bae27.webp',
    1000,
    '2019 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '10:00:00', '13:00:00', 15);
end $$;

-- Doctor 29: Dr. Shamsun Nahar (চর্ম ও যৌন রোগ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চর্ম ও যৌন রোগ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চর্ম ও যৌন রোগ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Shamsun Nahar',
    'MBBS,D.D.V (CMC),FELLOW IN AESTHETIC DERMATOLOGY &amp; TRICOLOGY',
    v_spec_id,
    15,
    'SKIN,HAIR, NAIL AND ALLERGY SPECIALIST AND COSMETIC SURGEON',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_2af0f969-f8d9-4e32-a8c8-156cd9af27ce.webp',
    1000,
    '4002 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '14:00:00', '16:00:00', 15);
end $$;

-- Doctor 30: Dr. Mst. Nasrin Sultana (চর্ম ও যৌন রোগ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চর্ম ও যৌন রোগ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চর্ম ও যৌন রোগ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mst. Nasrin Sultana',
    'MBBS,MD (BSMMU),DARMATOLOGY &amp; VENEREOLOGY,FELLOWSHIP TRAINING ON DERMATOSURGERY',
    v_spec_id,
    15,
    'Dermatology, Venereal Diseases & Allergy Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_6af8d606-52bc-4a74-aa6d-7af81645dfb6.webp',
    1000,
    '4013 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:30:00', '20:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:30:00', '20:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:30:00', '20:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:30:00', '20:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:30:00', '20:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:30:00', '20:30:00', 15);
end $$;

-- Doctor 31: Dr. Md. Ismail Hossen Chowdhury (Ripon) (চর্ম ও যৌন রোগ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চর্ম ও যৌন রোগ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চর্ম ও যৌন রোগ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Ismail Hossen Chowdhury (Ripon)',
    'MBBS,BCS(Health),MD (Dermatology &amp; Venereal Diseases, BSMMU)',
    v_spec_id,
    15,
    'Dermatology, Venereal Diseases & Allergy Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_9cc19046-62df-4130-af6e-824131b53927.webp',
    1000,
    '4020 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '19:00:00', 15);
end $$;

-- Doctor 32: Dr. Kazi Khadija Akhtar (Rafat) (চর্ম ও যৌন রোগ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চর্ম ও যৌন রোগ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চর্ম ও যৌন রোগ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Kazi Khadija Akhtar (Rafat)',
    'MBBS (Dhaka Medical College), DDV (BSMMU)',
    v_spec_id,
    15,
    'Dermatologist and gynecologist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_fd6b621c-328c-4880-92e4-34877b2cabf0.webp',
    1000,
    '2015 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '10:00:00', '13:00:00', 15);
end $$;

-- Doctor 33: Dr. Tahmina Akther (চর্ম ও যৌন রোগ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চর্ম ও যৌন রোগ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চর্ম ও যৌন রোগ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Tahmina Akther',
    'MBBS, BCS (Health), DDV (BMU)',
    v_spec_id,
    15,
    'Dermatology Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_be26d098-055f-41c8-8d4e-868497fda786.webp',
    1000,
    '3014 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 34: Dr. M. A. Mazed (ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. M. A. Mazed',
    'MBBS, FCPS (Physical medicine and Rehabilitation)',
    v_spec_id,
    15,
    'Dr. M.A. Mazed is a dedicated and highly specialized medical professional, focusing on Physical Medicine with expertise in areas such as arthritis, pain management, paralysis, and sports injuries. With his qualifications including an MBBS and FCPS in Physical Medicine, he brings a deep understanding of the human body and its functions. As a Consultant in the Department of Physical Medicine at National Hospital Chattogram and Sigma Lab Ltd., Dr. Mazed provides expert care to patients, offering th',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_475508ed-e9ca-476a-bc75-ed434f622b72.webp',
    1000,
    '4020 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '11:00:00', '13:00:00', 15);
end $$;

-- Doctor 35: Professor Dr. Zahangir Alam Chowdhury (ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Zahangir Alam Chowdhury',
    'MBBS, FCPS (Physical Medicine)',
    v_spec_id,
    15,
    'Professor Doctor Zahangir Alam Chowdhury is a highly esteemed and accomplished medical professional specializing in Physical Medicine and Rehabilitation. With his qualifications, which include an MBBS and FCPS in Physical Medicine, he possesses a deep understanding of the human body and its functions. Notably, he serves as the Professor and Head of the Department of Physical Medicine and Rehabilitation at Chattogram Maa-O-Shishu Hospital, where he imparts his extensive knowledge to train future ',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_efe8663f-93e7-46a7-8a35-ee94dd1383ed.webp',
    1000,
    '3012 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '19:00:00', 15);
end $$;

-- Doctor 36: Dr. Shafiul Karim Md Elias (ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ফিজিক্যাল মেডিসিন ও রিহ্যাবিলিটেশন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Shafiul Karim Md Elias',
    'MBBS, FCPS (Physical Medicine)',
    v_spec_id,
    15,
    'Dr. Shafiul Karim Md. Elias is a highly accomplished and respected Physical Medicine Specialist in Chittagong. His impressive qualifications include an MBBS degree and the prestigious FCPS in Physical Medicine, demonstrating his expertise in the field. Dr. Elias serves as an Associate Professor and is the Head of the Department of Physical Medicine & Rehabilitation at CIMC Hospital. His specialization encompasses a wide range of areas, including pain management, arthritis, paralysis, and sports ',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_bc5df381-3876-471b-baad-6e9a081379e8.webp',
    1000,
    '3021 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '19:00:00', 15);
end $$;

-- Doctor 37: Professor Dr. Md.Mazharul Haque Nasim (ইউরোলজি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইউরোলজি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইউরোলজি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Md.Mazharul Haque Nasim',
    'MBBS,BCS(HEALTH),FCPS(SURGERY) MS(UROLOGY)',
    v_spec_id,
    15,
    'Urologist and Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_859d4313-2175-4e79-928b-ae0455ed9063.webp',
    1000,
    '3018 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '18:00:00', 15);
end $$;

-- Doctor 38: Professor Dr. Mofizur Rahman (ইউরোলজি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইউরোলজি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইউরোলজি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Mofizur Rahman',
    'MBBS,BCS(HEALTH),MS (Urology)',
    v_spec_id,
    15,
    'Specialist in Kidney Surgery and Urology, Urologist, Andrologist , Laparoscopic Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_45a6430f-22aa-4122-ad40-8ca969e0b05e.webp',
    1000,
    '3012 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '20:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '20:00:00', '22:00:00', 15);
end $$;

-- Doctor 39: Professor Dr. Abdus Salam (ইউরোলজি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইউরোলজি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইউরোলজি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Abdus Salam',
    'MBBS,BCS(HEALTH),FCPS (Surgery),MS(Urology).',
    v_spec_id,
    15,
    'Urologist and Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_abe13061-28ba-466d-803d-1c4a97c967a7.webp',
    1000,
    '4016 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 40: Nutritionist Md. Iqbal Hossain (পুষ্টি ও খাদ্য বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'পুষ্টি ও খাদ্য বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('পুষ্টি ও খাদ্য বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Nutritionist Md. Iqbal Hossain',
    'BSc(Honours), Msc(1st Class) Applied Nutrition and Food Technology,',
    v_spec_id,
    15,
    'Nutritionist Iqbal Hossain is a Nutritionist in Chittagong. His qualification is BCS (Hons) MSC (Applied Nutrition & Food Technology). He is a Consultant in nutrition and diet Management at Chittagong Diabetic General Hospital. He regularly provides treatment to his patients at National Hospital, Chittagong.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_082a7c8c-a97b-4a55-b470-92cebed15b62.webp',
    1000,
    '2020 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 41: Dr. Sharmin Sultana (পুষ্টি ও খাদ্য বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'পুষ্টি ও খাদ্য বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('পুষ্টি ও খাদ্য বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Sharmin Sultana',
    'MBBS,BCS(Health),MPhil(Biochemistry),MSC( Food &amp; Nutrition Science), Certified Course Therapeutic Diet',
    v_spec_id,
    15,
    'Nutrition Specialist & Lab Consaltant',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_34553bb5-9830-44ff-8c2d-f932c4d3c860.webp',
    1000,
    '3021 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 42: Dr. Mohammad Rezaul Karim (ইএনটি / নাক-কান-গলা)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইএনটি / নাক-কান-গলা';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইএনটি / নাক-কান-গলা') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Rezaul Karim',
    'MBBS(DU),MCPS(ENT),FCPS(ENT)',
    v_spec_id,
    15,
    'MICROEAR SURGERY, ENDOSCOPIC SINUS SURGERY, THYROID SURGERY,ALL ROUTINE & EMERGENCY IN EAR NOSE THROAT & HEAD NEEK SURGERY.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_f8d871d3-141e-4ca4-a79c-2cc6a1753187.webp',
    1000,
    '2001 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:30:00', '22:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '18:30:00', '22:30:00', 15);
end $$;

-- Doctor 43: Professor. Dr. Ziaul Ansar Chowdhury (ইএনটি / নাক-কান-গলা)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইএনটি / নাক-কান-গলা';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইএনটি / নাক-কান-গলা') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor. Dr. Ziaul Ansar Chowdhury',
    'MBBS, BCS (Health), DLO (BSMMU, Dhaka), MNS (Australia), Specialized Training Microsurgery (Australia)',
    v_spec_id,
    15,
    'ENT Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_94e37388-9083-4a67-b904-fafb612f6f81.webp',
    1000,
    '2016 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '10:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '10:00:00', '13:00:00', 15);
end $$;

-- Doctor 44: Professor Dr. Md. Abdus Sattar (ইএনটি / নাক-কান-গলা)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইএনটি / নাক-কান-গলা';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইএনটি / নাক-কান-গলা') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Md. Abdus Sattar',
    'MBBS, DLO, FCPS, MS (ENT), Head-Neck Fellow (America) , Higher Training (TMCH/MSKCC, NY)',
    v_spec_id,
    15,
    'Ear, Nose. Throat Specialist & Head-Neck Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_fc3d676e-b98e-46c2-b2fc-c070165f37bf.webp',
    1000,
    '4008 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 45: Professor Dr. Mohammad Jamal Hussain (ইএনটি / নাক-কান-গলা)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইএনটি / নাক-কান-গলা';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইএনটি / নাক-কান-গলা') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Mohammad Jamal Hussain',
    'MBBS, FCPS (ENT),  BCS(Health)',
    v_spec_id,
    15,
    'ENT Specialist Head, Neck and Thyroid Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_e5aba2e3-6f16-4ee7-a23b-b4e30b97f413.webp',
    1000,
    '4003 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 46: Dr. Mohammad Abul Bashar (ইএনটি / নাক-কান-গলা)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইএনটি / নাক-কান-গলা';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইএনটি / নাক-কান-গলা') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Abul Bashar',
    'MBBS,BCS(Health),DLO (BSMMU) CCD (BERDAM)',
    v_spec_id,
    15,
    'ENT',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_51092372-e458-45da-af81-922792dcfcee.webp',
    1000,
    '2015 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '19:00:00', 15);
end $$;

-- Doctor 47: Professor Dr. Ahmed Sharif (ইএনটি / নাক-কান-গলা)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ইএনটি / নাক-কান-গলা';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ইএনটি / নাক-কান-গলা') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Ahmed Sharif',
    'MBBS, MS (ENT)',
    v_spec_id,
    15,
    'Nose, Ear, Throat Specialist and Head Neck Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_90403155-b60e-4c43-8e54-99b4bcc88ee7.webp',
    1000,
    '4008 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 48: Dr. Mohammadul Haque Mezbah (চক্ষু রোগ বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'চক্ষু রোগ বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('চক্ষু রোগ বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammadul Haque Mezbah',
    'MBBS, BCS (Health), DO (BSMMU), MCPS (Eye)',
    v_spec_id,
    15,
    'Eye Specialist and Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_2ea77fc1-193d-4256-8a10-1612f55e2079.webp',
    1000,
    '4012 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '21:00:00', 15);
end $$;

-- Doctor 49: Professor Dr. Kamrun Nessa Runa (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Kamrun Nessa Runa',
    'MBBS,MS,MCPS,DGO,BCS(HEALTH)',
    v_spec_id,
    15,
    'Professor Dr. Kamrun Nessa as a distinguished Gynecologist and Obstetrician Specialist, illuminating the path to women''s health and fertility solutions. Appointment at  With MCPS and FCPS qualifications in Obstetrics and Gynecology, an MPH in Epidemiology, and specialized fellowships in Laparoscopy and Assisted Reproductive Technology, her expertise is vast and cutting-edge. As a Professor in Obstetrics, Gynecology, and Infertility, she imparts her knowledge while offering compassionate care at',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_e311d14c-e5d1-4280-80e6-693c766bfc40.webp',
    1000,
    '3015 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 50: Dr. Sarwat Ara (Riku) (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Sarwat Ara (Riku)',
    'MBBS, BCS (Health), MCPS, MS (OBS &amp; GYNE)',
    v_spec_id,
    15,
    'Gynecology, Obstetrics, Infertility Specialist & Laparoscopic Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_e07f94a7-760e-4631-b096-d8f6576cc296.webp',
    1000,
    '3009 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 51: Professor Dr. Tazin Sultana (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Tazin Sultana',
    'MBBS, BCS (Health),  FCPS(Gyne &amp; Obs)',
    v_spec_id,
    15,
    'Assistant Professor Dr. Tazeen Sultana is a Gynecologist in Chittagong. Her qualification is MBBS, FCPS (Gyne & Obs). She is working as a Gynecology Specialist &  Professor in Chittagong Medical College Hospital. She regularly provides treatment to her patients at National Hospital, Chittagong.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_627a0c0c-a353-4c4a-b3d4-24a0f1f49fdd.webp',
    1000,
    '3002 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '19:00:00', 15);
end $$;

-- Doctor 52: Dr. Nazneen Sultana (Lulu) (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Nazneen Sultana (Lulu)',
    'FCPS(Gynae &amp; Obs),  BCS(Health)',
    v_spec_id,
    15,
    'Best Gynecology & Obstetrics Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_9ba653ae-9fc2-4f1a-82b0-a0fd220ab64e.webp',
    1000,
    '4006 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 53: Dr. Musarat Naz (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Musarat Naz',
    'MBBS,MS(Gyne &amp; obs),BCS(Health)',
    v_spec_id,
    15,
    '.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_b57c3264-b2fb-437e-a77b-151944884eb8.webp',
    1000,
    '2015 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 54: Dr. Hafiza Marjan (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Hafiza Marjan',
    'MBBS, Bcs(Health), FCPS( GYNE &amp; OBS)',
    v_spec_id,
    15,
    'Dr. Hafiza Marjan, a highly accomplished medical professional, is a dedicated Gynae & Obs. Specialist and Surgeon with an impressive educational background, holding an MBBS degree, BCS (Health) certification, and FCPS (Gyn & Obs) qualification. She practices at the renowned Chattogram Medical College Hospital, where her expertise shines in the field of obstetrics and gynecology. Driven by a commitment to promoting natural childbirth, she actively strives for regular deliveries, prioritizing the ',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_a413da88-eac3-4b1b-b130-9f8c7d5c8a99.webp',
    1000,
    '3005 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '21:00:00', 15);
end $$;

-- Doctor 55: Dr. Naima Akter (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Naima Akter',
    'MBBS (CMC),Bcs(Health),DGO(BSMMU)',
    v_spec_id,
    15,
    'GYNE & OBS',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_7f57f40a-0c0e-4527-929f-271f30b99563.webp',
    1000,
    '2022 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 56: Dr. Nurjahan Begum (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Nurjahan Begum',
    'MBBS, MCPS, FCPS(GYNE &amp; OBS)',
    v_spec_id,
    15,
    'GYNE & OBS',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_abdb0455-53a7-49f0-b072-17220a171d7d.webp',
    1000,
    '4019 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '18:00:00', 15);
end $$;

-- Doctor 57: Dr. Sultana Rowshon (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Sultana Rowshon',
    'MBBS (DU), BCS (Health) DMU, &#x200B;&#x200B;FCGP, CCD (BARDEM), MS (GYN &amp; OB)',
    v_spec_id,
    15,
    'Gynaecology, Obstetrics and Infertility Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_d48c323c-0d29-4aa5-9b58-a63109f896b7.webp',
    1000,
    '2014 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '18:00:00', 15);
end $$;

-- Doctor 58: Dr. Sanjida Zerin (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Sanjida Zerin',
    'MBBS, MS (Gynae &amp; Obs)',
    v_spec_id,
    15,
    'Obstetrician, Gynecologist, & Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_ca2f8b1d-b619-4af2-81f4-85c584ba7771.webp',
    1000,
    '2023 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 59: Dr. Jasmin Akter (গাইনী ও প্রসূতি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'গাইনী ও প্রসূতি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('গাইনী ও প্রসূতি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Jasmin Akter',
    'MBBS, BCS (Health), and FCPS(Gyne &amp; Obs),Chittagong Medical College Hospital,Chittagong.',
    v_spec_id,
    15,
    'Gynae & Obs. Specialist & Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_bcc92f69-1a1c-4331-b1fc-a5d802f14ac4.webp',
    1000,
    '3022 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 60: Dr. A. K. M. Jolil Ahmed (অর্থোপেডিকস)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'অর্থোপেডিকস';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('অর্থোপেডিকস') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. A. K. M. Jolil Ahmed',
    'MBBS (CMC), CCD (Bardem), PGT, AO Basic Trauma, FCPS Part-2',
    v_spec_id,
    15,
    'Orthopedic and Traumatology Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_566064b8-d783-480d-8d36-3effb1507a1f.webp',
    1000,
    '2019 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 61: Dr. Muhammad Ramzan Ali (অর্থোপেডিকস)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'অর্থোপেডিকস';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('অর্থোপেডিকস') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Muhammad Ramzan Ali',
    'MBBS, BCS (Health), MS (Orthopedics Surgery), CMCH',
    v_spec_id,
    15,
    'ORTHOPEDICS',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_4784ab2f-0b1d-465c-b3de-2cbbf3f01149.webp',
    1000,
    '4020 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 62: Dr. Mohammed Selim (অর্থোপেডিকস)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'অর্থোপেডিকস';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('অর্থোপেডিকস') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammed Selim',
    'MBBS, D(ORTHO), MS (ORTHO)',
    v_spec_id,
    15,
    'Joint pain, Arthritis , Orthopedics & Spine Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_349cbca0-40f7-4c91-90ee-3e991a73e94f.webp',
    1000,
    '4013 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '11:00:00', '14:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '11:00:00', '14:00:00', 15);
end $$;

-- Doctor 63: Dr. Md. Jamal Uddin (অর্থোপেডিকস)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'অর্থোপেডিকস';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('অর্থোপেডিকস') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Jamal Uddin',
    'MBBS, MS (ORTHO), Special Training in Vascular Surgery (NICVD), Fellow Arthroscopy &amp; Arthroplasty (SIOR, PUNA,INDIA), Fellow Ilizarov Orthopaedic &amp;  Trauma (BIO Centre)',
    v_spec_id,
    15,
    'Joint pain, Arthritis , Orthopedics & Spine Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_7c726cc6-1bbc-4fa5-b74d-83dbae3a1cda.webp',
    1000,
    '4023 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '18:00:00', 15);
end $$;

-- Doctor 64: Dr. Md. Fahad Goni (অর্থোপেডিকস)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'অর্থোপেডিকস';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('অর্থোপেডিকস') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Fahad Goni',
    'MBBS (DHAKA),MS (ORTHOPEDIC-BSMMU),FACS(America)',
    v_spec_id,
    15,
    'Orthopaedic spine specialists',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_a0f12411-3c5e-4e6b-86f1-47a078a4f2e3.webp',
    1000,
    '2016 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 65: Dr. Md. Abdur Rob Faisal (অর্থোপেডিকস)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'অর্থোপেডিকস';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('অর্থোপেডিকস') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Abdur Rob Faisal',
    'MBBS,BCS(Health),D(ORTHO, BSMMU)',
    v_spec_id,
    15,
    'Orthopedics',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_4880801e-1770-46eb-a507-edde0b056268.webp',
    1000,
    '2013 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 66: Dr. Mohammad Mamun (অর্থোপেডিকস)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'অর্থোপেডিকস';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('অর্থোপেডিকস') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Mamun',
    'MBBS (CU),D-Ortho(BSMMU),AO Trauma (Basic) India. Fellowship in Ilizarb (India).',
    v_spec_id,
    15,
    'Joint pain, Arthritis , Orthopedics & Spine Surgeon .',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_4a775b53-52db-43b1-9059-2d1249cffa18.webp',
    1000,
    '2014 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 67: Dr. Md. Monzurul Islam (নিউরোসার্জারি (ব্রেন ও স্পাইন))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোসার্জারি (ব্রেন ও স্পাইন)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোসার্জারি (ব্রেন ও স্পাইন)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Monzurul Islam',
    'MBBS, MS(Neurosurgery)',
    v_spec_id,
    15,
    'Brain & Spine Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_09af2174-b5e5-48cd-bab2-866b9b9f07cb.webp',
    1000,
    '4021 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 68: Dr. Md. Saiful Alam (নিউরোসার্জারি (ব্রেন ও স্পাইন))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোসার্জারি (ব্রেন ও স্পাইন)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোসার্জারি (ব্রেন ও স্পাইন)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Saiful Alam',
    'MBBS, BCS (Health), MS (Neurosurgery)',
    v_spec_id,
    15,
    'Neurosurgery (Brain, Stroke, Spine Surgery) Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_cf0bd74d-7529-4b94-8f82-ec2cce8f6947.webp',
    1000,
    '2027 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '18:00:00', 15);
end $$;

-- Doctor 69: Dr. Abu Sadat Muhammad Shihab Uddin (নিউরোসার্জারি (ব্রেন ও স্পাইন))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'নিউরোসার্জারি (ব্রেন ও স্পাইন)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('নিউরোসার্জারি (ব্রেন ও স্পাইন)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Abu Sadat Muhammad Shihab Uddin',
    'MBBS, BCS (Health), MS in Neuro-Surgery',
    v_spec_id,
    15,
    'Brain, Spine, Stroke, and Neurological Disease Specialist & Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_18ff64d9-5db5-46fd-8ad6-0872e2420d84.webp',
    1000,
    '2025 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 70: Dr. Md. Shahidullah (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Shahidullah',
    'MBBS, BCS (Health), MD(Cardiology)',
    v_spec_id,
    15,
    'Cardiologist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_ea1c7d30-c7f4-4cce-901d-f0d5c0d6ce43.webp',
    1000,
    '3019 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 71: Dr. Muhammad Belal Hossain (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Muhammad Belal Hossain',
    'MBBS, BCS (Health), and MD in Cardiology',
    v_spec_id,
    15,
    'Dr. Muhammad Belal Hossain, a qualified Cardiologist with MBBS, BCS (Health), and MD in Cardiology, serves as a specialist at Chittagong Medical College & Hospital. He provides regular consultations at National Hospital Chattogram and Sigma Lab Ltd., where he treats patients every Sunday, Tuesday, and Thursday from 3:00 PM to 5:00 PM. His chamber is located in Room 4022 on the 4th floor of the New Building. For appointments, please contact 01827-402322 or 01822-685066.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_b661b8a4-db0e-42e3-9916-ff4584846959.webp',
    1000,
    '4022 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 72: Dr. A. M. Showkat Akbar (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. A. M. Showkat Akbar',
    'MBBS, BCS (Health), MD (Cardiology-BSMMU)',
    v_spec_id,
    15,
    'Dr. A. M. Showkat Akbar is a highly qualified Cardiologist with an MBBS, BCS (Health), and MD in Cardiology from BSMMU. He is trained in Interventional Cardiology and previously served as a Consultant at the National Institute of Cardiovascular Diseases. Dr. Akbar specializes in a wide range of cardiac conditions, including angiogram, angioplasty, pacemaker implantation, atrial fibrillation, arrhythmias, congenital and coronary heart diseases, congestive heart failure, high cholesterol, hyperten',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_137c6ee4-49e3-42c8-8ea6-919a75d4eb9a.webp',
    1000,
    '3012 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 73: Dr. KHONDOKAR Md. ISMAIL (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. KHONDOKAR Md. ISMAIL',
    'MBBS(CMC),BCS(Health) ,MD(CARDIOLOGY) (BSMMU), MRCP-UK(PACES)',
    v_spec_id,
    15,
    'Cardiology and Medicine',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_3d53af7c-47a2-419b-b4e7-b5e5ef1538ac.webp',
    1000,
    '4018 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '18:00:00', 15);
end $$;

-- Doctor 74: DR. Mohammed Abdul Jalil (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'DR. Mohammed Abdul Jalil',
    'MBBS, BCS(Health), D-Card (NICVD), FRSH(LONDON), DMU, CCD(BIRDEM)',
    v_spec_id,
    15,
    'Cardiology, Medicine and Diabetes Specialist in Chittagong',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_7c27eef5-9323-4916-8298-7a91f7a0d3b6.webp',
    1000,
    '3003 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '11:00:00', '13:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '11:00:00', '13:00:00', 15);
end $$;

-- Doctor 75: Dr. Md. Mostafizur Rahman (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Mostafizur Rahman',
    'MBBS (CMC), BCS (Health), MD (Cardiology)',
    v_spec_id,
    15,
    'Dr. Md. Mostafizur Rahman is a dedicated Medicine and  Cardiologist specializing in the Cardiology of Rheumatic Fever & Medicine. He holds degrees of MBBS, BCS (Health), and MD (Cardiology), reflecting his commitment to excellence in the medical field. Currently serving as an Assistant Professor in the Department of Cardiology at National Hospital, Dr. Mostafizur Rahman expertise and experience make him a valued healthcare professional. Chamber at the National Hospital during the visiting hours ',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_ad6acbb7-6507-4240-b41f-931697efb2e1.webp',
    1000,
    '4009 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 76: Dr. Habibul Islam Chowdhury (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Habibul Islam Chowdhury',
    'MBBS, BCS (Health),   MD(Cardiology)',
    v_spec_id,
    15,
    'Medicine & Heart Specialist Doctor',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_7f038807-500f-4690-bb8c-105b4f3d9846.webp',
    1000,
    '3014 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 77: DR. Md.  ABDUR RAZZAK (হৃদরোগ (কার্ডিওলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হৃদরোগ (কার্ডিওলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হৃদরোগ (কার্ডিওলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'DR. Md.  ABDUR RAZZAK',
    '.',
    v_spec_id,
    15,
    '.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_5ee5a327-1110-47ef-925c-0a18a28cf142.webp',
    1000,
    '3019 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 78: Professor Dr. A. M. M Ehteshamul Haque (কিডনি রোগ (নেফ্রোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'কিডনি রোগ (নেফ্রোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('কিডনি রোগ (নেফ্রোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. A. M. M Ehteshamul Haque',
    'MBBS, MD(Nephrology)',
    v_spec_id,
    15,
    'Dr. AMM Ehteshamul Haque is a highly skilled nephrologist with expertise in various nephrological conditions. He offers comprehensive patient care, specializing in amyloidosis, acute kidney failure, diabetic kidney disorder, electrolyte disorders, glomerulonephritis, hypertension, kidney disease and failure, lupus nephritis, nephrotic syndrome, pyelonephritis, polycystic kidney disorder, renal insufficiency, and kidney transplant and dialysis. With his profound knowledge and experience, Dr. Haqu',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_0822724d-02c6-4683-bb7e-385d5578e91b.webp',
    1000,
    '4015 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 79: Dr. Mohammad Abdul Kader (কিডনি রোগ (নেফ্রোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'কিডনি রোগ (নেফ্রোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('কিডনি রোগ (নেফ্রোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Abdul Kader',
    'MBBS, BCS (Health), MD(Nephrology)',
    v_spec_id,
    15,
    'Dr. Mohammad Abdul Kader is a distinguished Kidney Specialist renowned for his expertise in the field. Armed with an MBBS and BCS (Health) qualification and an M.D in Nephrology from Chittagong Medical College & Hospital, he stands as a beacon of medical proficiency. Dr. Kader''s dedicated focus on kidney diseases has made him a sought-after practitioner in Chittagong. His chamber is at National Hospital, Chittagong, where he provides top-notch medical care. With a visiting schedule from 6:30 pm',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_bc08662c-828d-4e55-8283-007a56f4c20d.webp',
    1000,
    '3013 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:30:00', '21:30:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:30:00', '21:30:00', 15);
end $$;

-- Doctor 80: Dr. Saddat Hossain (কিডনি রোগ (নেফ্রোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'কিডনি রোগ (নেফ্রোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('কিডনি রোগ (নেফ্রোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Saddat Hossain',
    'MBBS, BCS (Health), MD (Nephrology),Kidney Disease Dept. Chattogram Medical College Hospital.',
    v_spec_id,
    15,
    'Dr. Saddat Hossain a distinguished Kidney Specialist with an impressive medical background, including an MBBS, BCS (Health), and MD in Nephrology. He is a beacon of expertise in the Kidney Disease Department at Chittagong Medical College & Hospital, demonstrating his commitment to advancing kidney care. Renowned as one of Chittagong''s best Kidney Specialist Doctors, Dr. Hossain extends his services to National Hospital, Chittagong, where he welcomes patients in Room Number 2027. With a daily vi',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_3d6389ed-d4ef-401c-bb50-24e68a37f548.webp',
    1000,
    '2027 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 81: Prof. Dr. Md. Gias Uddin Sagor (মনোরোগ বিশেষজ্ঞ (সাইকিয়াট্রি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'মনোরোগ বিশেষজ্ঞ (সাইকিয়াট্রি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('মনোরোগ বিশেষজ্ঞ (সাইকিয়াট্রি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Prof. Dr. Md. Gias Uddin Sagor',
    'MBBS,M.Phil(Psychiatric)',
    v_spec_id,
    15,
    'Prof. Dr. Md. Gias Uddin Sagor is a distinguished psychiatrist renowned for his expertise in mental health, brain disorders, headaches, and epilepsy. Holding impressive credentials including an MBBS and an M.Phil in Psychiatry, he stands as a beacon of knowledge and innovation in his field. Currently serving as the Professor and Head of the Department of Mental Diseases at Chattogram Maa-O-Shishu Hospital Medical College, Prof. Dr. Sagor''s dedication to advancing psychiatric care is evident. Pa',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_0a8c228a-57c2-4cb9-949f-a7330cc5a913.webp',
    1000,
    '2023 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '16:00:00', '19:00:00', 15);
end $$;

-- Doctor 82: Dr. Md. Akramul Alam Simon (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Akramul Alam Simon',
    'MBBS, BCS (Health), MD (Psychiatry, NIMH) Psychiatrist &amp; Psychotherapist',
    v_spec_id,
    15,
    'General Surgery Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_513a7626-e8e9-4f47-9feb-e02d1015aa3a.webp',
    1000,
    '2025 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 83: Dr. Md. Abu Naser (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Abu Naser',
    'MBBS (CMC),MS(General Surgery)',
    v_spec_id,
    15,
    'General Surgery',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_5a98ce1f-e9e7-4185-b0f9-f6196b9ed604.webp',
    1000,
    '4004 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 84: Dr. Saira Banu Shiuli (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Saira Banu Shiuli',
    'MBBS,BCS(Health),FCPS(General Surgery), FMAS (INDIA)',
    v_spec_id,
    15,
    'General & Laparoscopic Surgery Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_86aeb864-3989-4066-8791-411090be1c7a.webp',
    1000,
    '3008 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 85: Dr. A.Z.M Farman Ullah (Sohel) (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. A.Z.M Farman Ullah (Sohel)',
    'MBBS,FCPS(Surgery)',
    v_spec_id,
    15,
    'GENERAL,LAPAROSCOPIC & COLORECTAL SURGERY',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_1cbbb922-ff1d-4ab0-b826-eb3344ce00be.webp',
    1000,
    '2017 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '20:00:00', 15);
end $$;

-- Doctor 86: Dr. Md. Omar Farooq (Tuhin) (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Omar Farooq (Tuhin)',
    'MBBS, BCS (Health), FCPS (Surgery)  FACS (USA)  EFIAGES (India)',
    v_spec_id,
    15,
    'General, Colorectal Endolaparoscopic and Laser Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_d9fe3c53-007e-4bb7-9b25-5ee6b794dbce.webp',
    1000,
    '4023 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 87: Dr. Kazi Md. Asif Hasnan (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Kazi Md. Asif Hasnan',
    'MBBS, MS (Surgery), BCS (Health)',
    v_spec_id,
    15,
    'General , Laparoscopic and Colorectal Surgery Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_badf6f9c-695b-48f1-ac03-d373de54ddbb.webp',
    1000,
    '2015 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 88: Professor Dr. Md. Motahar Hossain (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Md. Motahar Hossain',
    'MBBS, BCS (Health), MS (Surgery), FMAS (India) Plastic &amp; Cosmetic Surgeon',
    v_spec_id,
    15,
    'General, Laparoscopic and Colorectal Surgeon',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_146e7343-c4f0-4411-bb56-7df673f34ef2.webp',
    1000,
    '4002 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 89: Dr. Shahed Mohammed Anwar (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Shahed Mohammed Anwar',
    'MBBS , MS (General Surgery), DMAS (India), FMAS(India),',
    v_spec_id,
    15,
    'Dr Shahed Mohammed Anwar is a distinguished General, Laparoscopic and Colorectal Surgeon, holding degrees of MBBS, MS in General Surgery, DMAS, and FMAS from esteemed institutions in India. Currently serving as an Assistant Professor of General Surgery at Chattogram Maa-O-Shishu Hospital, his expertise extends to National Hospital Chattogram and Sigma Lab Ltd. With a commitment to patient care, he offers consultations from 7 pm to 10 pm daily, except Fridays. Dr Anwar''s dedication to his field ',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_d4836c05-1205-4166-ad8e-08d22ef9e72c.webp',
    1000,
    '3021 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 90: Dr. Shormin Akter (জেনারেল সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'জেনারেল সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('জেনারেল সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Shormin Akter',
    'MBBS,MS (General Surgery)',
    v_spec_id,
    15,
    'General Surgery',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_a84cfb1a-bf54-44b5-a743-021fb22457b1.webp',
    1000,
    '3009 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '19:00:00', 15);
end $$;

-- Doctor 91: Dr. Ahsan Uddin Mahmud (Munna) (কার্ডিওভাসকুলার সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'কার্ডিওভাসকুলার সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('কার্ডিওভাসকুলার সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Ahsan Uddin Mahmud (Munna)',
    'MBBS,BCS(Health),MS(Cardiovascular &amp; Thoracic Surgery)',
    v_spec_id,
    15,
    'Vascular Surgery',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_a5a3a119-b634-425a-b3bf-0d92353acba7.webp',
    1000,
    '2018 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 92: Dr. Md. Jamal Uddin Tanin (রক্তরোগ বিশেষজ্ঞ (হেমাটোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'রক্তরোগ বিশেষজ্ঞ (হেমাটোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('রক্তরোগ বিশেষজ্ঞ (হেমাটোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Jamal Uddin Tanin',
    'MBBS (CMC), MD (Hematology)',
    v_spec_id,
    15,
    'Dr. Jamal Uddin Tanin, an esteemed Hematologist, holds the degrees of MBBS and MD (Hematology), showcasing his extensive medical expertise. With a notable focus on blood cancers and blood-related disorders, he has emerged as a dedicated specialist in his field. Dr. Tanin serves as a Consultant in the Department of Hematology at the esteemed National Hospital in Chittagong. His commitment to patient care is evident through his regular provision of treatment to those in need. Located at 14/15 Damp',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_badf9e38-edba-4293-9c63-97a93ee93f2f.webp',
    1000,
    '2018 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '14:00:00', '16:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '14:00:00', '16:00:00', 15);
end $$;

-- Doctor 93: Dr. Muhammed Abu Bakar (ডায়াবেটিস ও থাইরয়েড)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'ডায়াবেটিস ও থাইরয়েড';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('ডায়াবেটিস ও থাইরয়েড') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Muhammed Abu Bakar',
    'MBBS, DEM (Endocrinology &amp; Metabolism), MACE (America)',
    v_spec_id,
    15,
    'Diabetes, Thyroid, Hormone, Obesity',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_738b53a1-6e01-41ad-8970-466183108e12.webp',
    1000,
    '4022 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 94: Professor Dr. Mohammad Zakir Hossen Bhuiyan (বক্ষব্যাধি ও খাদ্যনালী)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'বক্ষব্যাধি ও খাদ্যনালী';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('বক্ষব্যাধি ও খাদ্যনালী') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. Mohammad Zakir Hossen Bhuiyan',
    'MBBS (DMC) ,FCPS (Surgery), BCS (HEALTH),MCPS(SURGERY),MS(Chest), FMAS(India), FACS, FICS ( America), Highly trained on VATS, RATS, URATS (China, India)',
    v_spec_id,
    15,
    '.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_9947f324-ea50-4fd9-a152-6c165129b3aa.webp',
    1000,
    '4014 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 95: Professor Dr. A J M Sadeque (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Professor Dr. A J M Sadeque',
    'MBBS, FCPS(Pediatrics)',
    v_spec_id,
    15,
    'Best Child Specialist Doctor',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_e3554ed6-6b58-4a25-bb9a-7cf66eeea9ad.webp',
    1000,
    '4002 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '20:00:00', 15);
end $$;

-- Doctor 96: Dr. Nazrul Quader Shikder (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Nazrul Quader Shikder',
    'MBBS, DCH (BSMMU), MD (Paediatrics)',
    v_spec_id,
    15,
    'Dr. Nazrul Quader Shikder, a dedicated Child Diseases Specialist, brings a wealth of expertise to the Hospital in Chittagong, where he attends to patients with care and expertise. Located in the medical community in Chittagong. He is a beacon of knowledge and proficiency in his field, with qualifications encompassing an MBBS degree, a DCH from BSMMU, and an MD in Pediatrics. Serving as an Assistant Professor in Pediatrics and Dr. Shikder chamber at National Hospital',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_830c5eea-c96b-4db8-90de-4152693f6e44.webp',
    1000,
    '3017 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '17:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '21:00:00', 15);
end $$;

-- Doctor 97: Dr. Md. Abdullah Al Mamun (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Abdullah Al Mamun',
    'MBBS, BCS(Health),  FCPS(Child Health),  MD(Child Health)',
    v_spec_id,
    15,
    'Child Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_508fab25-a09d-433f-86a2-cdde7cd0af7f.webp',
    1000,
    '4007 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '19:00:00', 15);
end $$;

-- Doctor 98: Dr. Nazmul Huda Ripon (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Nazmul Huda Ripon',
    'MBBS, DCH(BSMMU), MCPS (Child Health)',
    v_spec_id,
    15,
    'Child Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_654bedce-234a-4f3a-84ed-d44ac67051cc.webp',
    1000,
    '2022 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '15:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '15:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '15:00:00', '18:00:00', 15);
end $$;

-- Doctor 99: Dr. Roksana Afrose (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Roksana Afrose',
    'MBBS, DCH (Child health), MRCPH (Course , Child health)',
    v_spec_id,
    15,
    'Neonate & Child Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_d1196099-acb3-436a-aa4b-0158cac15d85.webp',
    1000,
    '3008 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '21:00:00', 15);
end $$;

-- Doctor 100: Dr. Mumtahina Mahmuda (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mumtahina Mahmuda',
    'MBBS (DMCH),BCS(Health) FCPS(CHILD HEALTH)',
    v_spec_id,
    15,
    'Child Specialist, Chittagong Medical College & Hospital',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_d37f7904-da8e-43cf-bfc8-e8a1995a00be.webp',
    1000,
    '3006 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 101: Dr. Mohammed Hossain (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammed Hossain',
    'MBBS, BCS (Health), MD(PEDIATRICS, BSMMU), FCPS(PEDIATRICS), DCH, BSMMU',
    v_spec_id,
    15,
    'Neonatologist & Paediatrician Specialist, Chattogram Railway Hospital.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_03c002bf-76a0-4251-bbfb-5892248d9dfb.webp',
    1000,
    '4007 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 102: Dr. Selina Haque (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Selina Haque',
    'MBBS (Dhaka), BCS (Health) FCPS (Child Health)',
    v_spec_id,
    15,
    'Pediatric',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_86a543d6-5a1d-475b-8a2b-0583be8260e8.webp',
    1000,
    '3005 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '20:00:00', 15);
end $$;

-- Doctor 103: Dr. Mohammad Abdul Momen (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Abdul Momen',
    'MBBS, BCS (Health), DCH (PG Hospital-BSMMU, Dhaka),  FCPS(FP) (Child Health), CCD Diabetology, Burdem, Dhaka), PGPN (Boston, America)',
    v_spec_id,
    15,
    'Neonatologist and Child Specialist',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_0b8c36f1-868c-42bd-bf34-affa3ce204b1.webp',
    1000,
    '2001 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '14:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '14:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '14:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '14:00:00', '17:00:00', 15);
end $$;

-- Doctor 104: Dr. Mohammad Sajjadul Alam (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Sajjadul Alam',
    'MBBS, BCS (Health), MCPS (Pediatrics Health)  , MD (Neonatology)  , Bangabandhu Sheikh Mujib Medical University',
    v_spec_id,
    15,
    'Specialist in Neonatology and Pediatrics',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_1d57e48a-0d8d-487d-abae-71a5de566ae7.webp',
    1000,
    '3012 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '15:00:00', '17:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '15:00:00', '17:00:00', 15);
end $$;

-- Doctor 105: Dr. Mohammad Toufiqul Islam (শিশু বিশেষজ্ঞ)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'শিশু বিশেষজ্ঞ';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('শিশু বিশেষজ্ঞ') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Toufiqul Islam',
    'MBBS, BCS (Health), MD (Paediatrics) ,Chattogram General Haspatal Chattogram',
    v_spec_id,
    15,
    'PEDIATRIC SPECIALIST',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_c7a83643-7809-4001-aa13-ac7acdab2dc5.webp',
    1000,
    '4013 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '19:00:00', 15);
end $$;

-- Doctor 106: Dr. Musfikul Abrar (হেপাটোলজি / লিভার)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'হেপাটোলজি / লিভার';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('হেপাটোলজি / লিভার') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Musfikul Abrar',
    'MBBS,MD (Hepatology),Bangabandhu Sheikh Mujib Medical University (Former PG Hospital, Dhaka)',
    v_spec_id,
    15,
    'Dr. Mushfiqul Abrar, an accomplished Liver Diseases, Gastrointestinal Specialist, and Endoscopist, is a prominent name in the medical field. Holding an MBBS degree from Chattogram Medical College, he pursued an MD in Hepatology from Bangabandhu Sheikh Mujib Medical University. As an Associate Consultant in Hepatology at Bangabandhu Sheikh Mujib Medical University (Former PG Hospital, Dhaka), his contributions are invaluable. Dr. Abrar''s expertise spans Gastrointestinal Diagnostics and Therapeut',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_6aaa50e7-fed9-487d-8029-0daae2e38901.webp',
    1000,
    '4017 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '18:00:00', '21:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '21:00:00', 15);
end $$;

-- Doctor 107: Dr. Fazle Kibria Chowdhury (বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Fazle Kibria Chowdhury',
    'MBBS(DMC),MD(CHEST PAIN) ,FCCP (USA) ,CCD(BARDEM) ,FCCS (SINGAPORE)',
    v_spec_id,
    15,
    '.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_96da98d9-acdb-4e42-b3b6-a7e9733ad8de.webp',
    1000,
    '4005 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '18:00:00', '20:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '18:00:00', '20:00:00', 15);
end $$;

-- Doctor 108: Dr. Mohammad Joynal Abedin (বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammad Joynal Abedin',
    'MBBS (CMC), BCS(Health), MD (Chest), Assistant Professor, National Institute of Diseases of the Chest and Hospital (NIDCH), Dhaka',
    v_spec_id,
    15,
    'chest diseases, asthma, breathing issues, medicine, allergies, and tuberculosis (TB)',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_035ed0eb-03dc-4541-b79c-5547108810b8.webp',
    1000,
    '4008 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '19:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '19:00:00', '22:00:00', 15);
end $$;

-- Doctor 109: Dr. Mohammed Humayun Kabir (বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Mohammed Humayun Kabir',
    'MBBS, BCS (Health),  FCPS(Medicine), MD (Pulmonology)',
    v_spec_id,
    15,
    'Medicine & Pulmonology Specialist.',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_683e2338-a814-465c-a110-29f6ff45b366.webp',
    1000,
    '3012 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '19:00:00', 15);
end $$;

-- Doctor 110: Dr. Tanvir Uddin Ahmed (বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('বক্ষব্যাধি ও রেসপিরেটরি মেডিসিন') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Tanvir Uddin Ahmed',
    'MBBS, DTCD (Chest Diseases, BSMMU),National Institute of Chest Diseases &amp; Hospital, Dhaka',
    v_spec_id,
    15,
    'Specialist in Medicine, Allergy, TB (Tuberculosis)',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_6a231552-b731-4b27-b97f-2182ce03c2b7.webp',
    1000,
    '3013 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '16:00:00', '19:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '16:00:00', '19:00:00', 15);
end $$;

-- Doctor 111: Dr. Md. Gias Uddin (বাতরোগ বিশেষজ্ঞ (রিউমাটোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'বাতরোগ বিশেষজ্ঞ (রিউমাটোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('বাতরোগ বিশেষজ্ঞ (রিউমাটোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Md. Gias Uddin',
    'Rheumatology (Arthritis, Vasculitis, SLE, Osteoporosis) Specialist',
    v_spec_id,
    15,
    'Dr. Md. Gias Uddin is a highly qualified rheumatology (arthritis, vasculitis, SLE, osteoporosis) specialist in Chattagram, holding an MBBS from SSMC, BCS (Health), and an MD in Rheumatology. He is also an EULAR MSK Sonologist and currently serves as a Consultant in Rheumatology at the Directorate General of Health Services (DGHS).',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_2d0a08a4-8ae7-4e37-ad2c-1ab0f78a4bf3.webp',
    1000,
    '3022 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 0, '17:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 1, '17:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 2, '17:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 3, '17:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '17:00:00', '22:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 6, '17:00:00', '22:00:00', 15);
end $$;

-- Doctor 112: Dr. Abdul Mahin Tazbir (বাতরোগ বিশেষজ্ঞ (রিউমাটোলজি))
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'বাতরোগ বিশেষজ্ঞ (রিউমাটোলজি)';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('বাতরোগ বিশেষজ্ঞ (রিউমাটোলজি)') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Abdul Mahin Tazbir',
    'MBBS, MD (Rheumatology), BMU ESRD (Switzerland), MACP (America)',
    v_spec_id,
    15,
    'ORTHOPEDICS',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_a876acdd-5f38-4eea-8a50-db9210a5b20f.webp',
    1000,
    '4007 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 4, '15:00:00', '18:00:00', 15);
  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '15:00:00', '18:00:00', 15);
end $$;

-- Doctor 113: Dr. Abed Ar Rahman (প্লাস্টিক ও বার্ন সার্জারি)
do $$
declare
  v_spec_id int;
  v_doc_id uuid;
begin
  select id into v_spec_id from public.specialties where name_bn = 'প্লাস্টিক ও বার্ন সার্জারি';
  if v_spec_id is null then
    insert into public.specialties (name_bn) values ('প্লাস্টিক ও বার্ন সার্জারি') returning id into v_spec_id;
  end if;

  insert into public.doctors (name_bn, degree, specialty_id, experience_years, bio, photo_url, fee, room_no, is_active)
  values (
    'Dr. Abed Ar Rahman',
    'MBBS, BCS (Health), MS(Plastic Surgery), National Institute of Burn and Plastic Surgery',
    v_spec_id,
    15,
    'Plastic Surgeons or Burn Specialists',
    'https://admin.nationalhospital.com.bd/images/Doctors/NXGIT_8f63ce75-9748-4726-9da1-f1203f4ba1e2.webp',
    1000,
    '3021 নং রুম',
    true
  )
  returning id into v_doc_id;

  insert into public.doctor_schedules (doctor_id, weekday, start_time, end_time, slot_minutes)
  values (v_doc_id, 5, '14:00:00', '17:00:00', 15);
end $$;
