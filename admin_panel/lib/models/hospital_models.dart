import 'package:flutter/foundation.dart';

class Doctor {
  final String id;
  final String name;
  final String degrees;
  final String specialty;
  final String hospital;
  final String avatarUrl;
  final double rating;
  final int totalReviews;
  final List<String> availableDays;
  final String chamberTime;
  final String roomNo;
  final int fee;
  final String nextAvailableDate;
  final bool isAvailableToday;

  String get displayAvatarUrl {
    if (avatarUrl.isEmpty) {
      return 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80';
    }
    if (kIsWeb && avatarUrl.contains('nationalhospital.com.bd')) {
      return 'https://wsrv.nl/?url=${Uri.encodeComponent(avatarUrl)}';
    }
    return avatarUrl;
  }

  const Doctor({
    required this.id,
    required this.name,
    required this.degrees,
    required this.specialty,
    required this.hospital,
    required this.avatarUrl,
    this.rating = 5.0,
    this.totalReviews = 120,
    required this.availableDays,
    required this.chamberTime,
    required this.roomNo,
    required this.fee,
    required this.nextAvailableDate,
    this.isAvailableToday = true,
  });

  static List<Doctor> sampleDoctors = [
    const Doctor(
      id: 'doc_1',
      name: 'ডা. তাসবীরুল হাসান জিহান',
      degrees: 'এমবিবিএস (সিএমসি), বিসিএস (স্বাস্থ্য), এমডি (গ্যাস্ট্রোএন্টারোলজি), বিএসএমএমইউ, এমআরসিপি (পেসিস)',
      specialty: 'গ্যাস্ট্রোলিভার ও মেডিসিন বিশেষজ্ঞ',
      hospital: 'চট্টগ্রাম মেডিকেল কলেজ হাসপাতাল',
      avatarUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80',
      rating: 4.9,
      totalReviews: 245,
      availableDays: ['শনিবার', 'রবিবার', 'মঙ্গলবার', 'বুধবার'],
      chamberTime: 'বিকাল ৫:০০ টা – সন্ধ্যা ৭:০০ টা',
      roomNo: '৪০২ নং রুম (৪র্থ তলা)',
      fee: 1000,
      nextAvailableDate: 'আজ, বিকাল ৫:০০',
      isAvailableToday: true,
    ),
    const Doctor(
      id: 'doc_2',
      name: 'ডা. মোহাম্মদ জসিম উদ্দিন',
      degrees: 'এমবিবিএস, এফসিপিএস (মেডিসিন), এমডি (ইন্টারনাল মেডিসিন)',
      specialty: 'মেডিসিন ও ডায়াবেটিস বিশেষজ্ঞ',
      hospital: 'ন্যাশনাল হাসপাতাল চট্টগ্রাম',
      avatarUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80',
      rating: 4.8,
      totalReviews: 180,
      availableDays: ['শনিবার', 'রবিবার', 'সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার'],
      chamberTime: 'সন্ধ্যা ৬:০০ টা – রাত ৯:০০ টা',
      roomNo: '৩০৫ নং রুম (৩য় তলা)',
      fee: 800,
      nextAvailableDate: 'আগামীকাল, সন্ধ্যা ৬:০০',
      isAvailableToday: false,
    ),
    const Doctor(
      id: 'doc_3',
      name: 'অধ্যাপক ডা. ফাতেমা খাতুন',
      degrees: 'এমবিবিএস, ডিজিও, এফসিপিএস (গাইনী ও প্রসূতি)',
      specialty: 'গাইনী ও বন্ধ্যাত্ব বিশেষজ্ঞ',
      hospital: 'চট্টগ্রাম মা ও শিশু হাসপাতাল',
      avatarUrl: 'https://images.unsplash.com/photo-1594824813637-4560b452601c?w=400&auto=format&fit=crop&q=80',
      rating: 5.0,
      totalReviews: 310,
      availableDays: ['রবিবার', 'মঙ্গলবার', 'বৃহস্পতিবার'],
      chamberTime: 'বিকাল ৪:০০ টা – সন্ধ্যা ৬:৩০ টা',
      roomNo: '২০১ নং রুম (২য় তলা)',
      fee: 1200,
      nextAvailableDate: 'আজ, বিকাল ৪:০০',
      isAvailableToday: true,
    ),
    const Doctor(
      id: 'doc_4',
      name: 'ডা. আনোয়ারুল হক',
      degrees: 'এমবিবিএস, এমডি (কার্ডিওলজি), এফএসিসি (আমেরিকা)',
      specialty: 'হৃদরোগ ও ইন্টারভেনশনাল কার্ডিওলজিস্ট',
      hospital: 'ন্যাশনাল হার্ট ফাউন্ডেশন চট্টগ্রাম',
      avatarUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&auto=format&fit=crop&q=80',
      rating: 4.9,
      totalReviews: 195,
      availableDays: ['প্রতিদিন (শুক্রবার ব্যতীত)'],
      chamberTime: 'বিকাল ৫:৩০ টা – রাত ৮:০০ টা',
      roomNo: '৫০১ নং রুম (৫ম তলা)',
      fee: 1200,
      nextAvailableDate: 'আজ, বিকাল ৫:৩০',
      isAvailableToday: true,
    ),
  ];
}

class Department {
  final String id;
  final String name;
  final String iconName;
  final int doctorCount;

  const Department({
    required this.id,
    required this.name,
    required this.iconName,
    required this.doctorCount,
  });

  static const List<Department> list = [
    Department(id: 'gastro', name: 'গ্যাস্ট্রোএন্টারোলজি', iconName: 'vital_signs', doctorCount: 6),
    Department(id: 'medicine', name: 'মেডিসিন', iconName: 'medical_services', doctorCount: 12),
    Department(id: 'cardiology', name: 'হৃদরোগ', iconName: 'favorite', doctorCount: 8),
    Department(id: 'pediatrics', name: 'শিশু বিশেষজ্ঞ', iconName: 'child_care', doctorCount: 7),
    Department(id: 'gynae', name: 'গাইনী ও প্রসূতি', iconName: 'pregnant_woman', doctorCount: 9),
    Department(id: 'neuro', name: 'নিউরোমেডিসিন', iconName: 'psychology', doctorCount: 5),
    Department(id: 'ortho', name: 'অর্থোপেডিকস', iconName: 'personal_injury', doctorCount: 6),
    Department(id: 'ent', name: 'ইএনটি / নাক-কান-গলা', iconName: 'hearing', doctorCount: 4),
  ];
}

class AppointmentBooking {
  final String serialNo;
  final String doctorName;
  final String doctorSpecialty;
  final String appointmentDate;
  final String appointmentTime;
  final String roomNo;
  final String patientName;
  final String patientPhone;
  final int fee;
  final String status;

  const AppointmentBooking({
    required this.serialNo,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.roomNo,
    required this.patientName,
    required this.patientPhone,
    required this.fee,
    this.status = 'নিশ্চিত',
  });
}

class FeaturedDoctor {
  final String id;
  final String doctorId;
  final String? title;
  final int displayOrder;
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final Doctor doctor;

  const FeaturedDoctor({
    required this.id,
    required this.doctorId,
    this.title,
    required this.displayOrder,
    this.isActive = true,
    this.startsAt,
    this.endsAt,
    required this.doctor,
  });

  bool get isCurrentlyVisible {
    if (!isActive) return false;
    final now = DateTime.now();
    if (startsAt != null && startsAt!.isAfter(now)) return false;
    if (endsAt != null && endsAt!.isBefore(now)) return false;
    return true;
  }

  factory FeaturedDoctor.fromMap(Map<String, dynamic> map, Doctor doctor) {
    return FeaturedDoctor(
      id: map['id']?.toString() ?? '',
      doctorId: map['doctor_id']?.toString() ?? doctor.id,
      title: map['title']?.toString(),
      displayOrder: (map['display_order'] as num?)?.toInt() ?? 0,
      isActive: map['is_active'] == true,
      startsAt: map['starts_at'] != null ? DateTime.tryParse(map['starts_at'].toString()) : null,
      endsAt: map['ends_at'] != null ? DateTime.tryParse(map['ends_at'].toString()) : null,
      doctor: doctor,
    );
  }
}

class DoctorScheduleItem {
  final String id;
  final String doctorId;
  final int weekday;
  final String startTime;
  final String endTime;
  final int slotMinutes;

  const DoctorScheduleItem({
    required this.id,
    required this.doctorId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    this.slotMinutes = 15,
  });

  factory DoctorScheduleItem.fromMap(Map<String, dynamic> map) {
    return DoctorScheduleItem(
      id: map['id']?.toString() ?? '',
      doctorId: map['doctor_id']?.toString() ?? '',
      weekday: (map['weekday'] as num?)?.toInt() ?? 0,
      startTime: map['start_time']?.toString() ?? '',
      endTime: map['end_time']?.toString() ?? '',
      slotMinutes: (map['slot_minutes'] as num?)?.toInt() ?? 15,
    );
  }
}

class AdminDashboardStats {
  final int totalDoctors;
  final int activeDoctors;
  final int featuredDoctors;
  final int totalAppointments;
  final int todayAppointments;
  final int totalSpecialties;

  const AdminDashboardStats({
    required this.totalDoctors,
    required this.activeDoctors,
    required this.featuredDoctors,
    required this.totalAppointments,
    required this.todayAppointments,
    required this.totalSpecialties,
  });
}

class AdminAuditLog {
  final String id;
  final String? adminId;
  final String action;
  final String entityType;
  final String? entityId;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const AdminAuditLog({
    required this.id,
    this.adminId,
    required this.action,
    required this.entityType,
    this.entityId,
    this.metadata,
    required this.createdAt,
  });

  factory AdminAuditLog.fromMap(Map<String, dynamic> map) {
    return AdminAuditLog(
      id: map['id']?.toString() ?? '',
      adminId: map['admin_id']?.toString(),
      action: map['action']?.toString() ?? '',
      entityType: map['entity_type']?.toString() ?? '',
      entityId: map['entity_id']?.toString(),
      metadata: map['metadata'] as Map<String, dynamic>?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

typedef DoctorModel = Doctor;
typedef AppointmentModel = AppointmentBooking;

