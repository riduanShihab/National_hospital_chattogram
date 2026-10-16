import 'package:flutter/material.dart';

class SpecialtyItem {
  final String id;
  final String nameBn;
  final String nameEn;
  final IconData icon;
  final int doctorCount;

  const SpecialtyItem({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.icon,
    required this.doctorCount,
  });
}

class AppSpecialties {
  AppSpecialties._();

  static const List<SpecialtyItem> list = [
    SpecialtyItem(
      id: 'gastro',
      nameBn: 'গ্যাস্ট্রোএন্টারোলজি',
      nameEn: 'Gastroenterology',
      icon: Icons.monitor_heart_rounded,
      doctorCount: 6,
    ),
    SpecialtyItem(
      id: 'medicine',
      nameBn: 'মেডিসিন',
      nameEn: 'Internal Medicine',
      icon: Icons.medication_rounded,
      doctorCount: 12,
    ),
    SpecialtyItem(
      id: 'cardiology',
      nameBn: 'হৃদরোগ',
      nameEn: 'Cardiology',
      icon: Icons.favorite_rounded,
      doctorCount: 8,
    ),
    SpecialtyItem(
      id: 'pediatrics',
      nameBn: 'শিশু বিশেষজ্ঞ',
      nameEn: 'Pediatrics',
      icon: Icons.child_care_rounded,
      doctorCount: 7,
    ),
    SpecialtyItem(
      id: 'gynae',
      nameBn: 'গাইনী ও প্রসূতি',
      nameEn: 'Gynecology & Obstetrics',
      icon: Icons.pregnant_woman_rounded,
      doctorCount: 9,
    ),
    SpecialtyItem(
      id: 'neuro',
      nameBn: 'নিউরোমেডিসিন',
      nameEn: 'Neurology',
      icon: Icons.psychology_rounded,
      doctorCount: 5,
    ),
    SpecialtyItem(
      id: 'ortho',
      nameBn: 'অর্থোপেডিকস',
      nameEn: 'Orthopedics',
      icon: Icons.accessibility_new_rounded,
      doctorCount: 6,
    ),
    SpecialtyItem(
      id: 'ent',
      nameBn: 'ইএনটি / নাক-কান-গলা',
      nameEn: 'ENT / Otolaryngology',
      icon: Icons.hearing_rounded,
      doctorCount: 4,
    ),
  ];
}
