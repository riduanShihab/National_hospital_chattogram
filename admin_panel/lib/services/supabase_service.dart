import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hospital_models.dart';

class SupabaseService {
  SupabaseService._();

  static bool get isInitialized {
    try {
      Supabase.instance;
      return true;
    } catch (_) {
      return false;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;

  // ========== AUTHENTICATION ==========

  static User? get currentUser {
    if (!isInitialized) return null;
    try {
      return client.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  static bool get isAuthenticated => currentUser != null;

  /// Sign up with phone and password (email optional)
  static Future<AuthResponse> signUp({
    required String phone,
    required String password,
    required String fullName,
    int? age,
    String? gender,
    String? email,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final cleanEmail = (email != null && email.trim().isNotEmpty) ? email.trim() : null;
    final canonicalAuthEmail = '$cleanPhone@patient.nationalhospital.com';

    // 1. First attempt: Direct RPC registration (bypasses SMTP rate limits & auto-confirms user)
    try {
      final rpcResult = await client.rpc('register_user_with_phone', params: {
        'p_phone': cleanPhone,
        'p_password': password,
        'p_full_name': fullName,
        'p_email': cleanEmail,
        'p_age': age,
        'p_gender': gender,
      });

      if (rpcResult != null) {
        // Automatically sign in with the new credentials to establish an active session
        return await client.auth.signInWithPassword(
          email: canonicalAuthEmail,
          password: password,
        );
      }
    } catch (e) {
      debugPrint('register_user_with_phone RPC notice: $e');
      final errorStr = e.toString();
      if (errorStr.contains('ইতিমধ্যে একটি অ্যাকাউন্ট রয়েছে') ||
          errorStr.contains('সঠিক ১১ ডিজিটের') ||
          errorStr.contains('পাসওয়ার্ড কমপক্ষে')) {
        rethrow;
      }
    }

    // 2. Fallback: Standard client.auth.signUp
    final metadata = <String, dynamic>{
      'full_name': fullName,
      'phone': cleanPhone,
    };
    if (cleanEmail != null) metadata['email'] = cleanEmail;
    if (age != null) metadata['age'] = age.toString();
    if (gender != null) metadata['gender'] = gender;

    final response = await client.auth.signUp(
      email: canonicalAuthEmail,
      password: password,
      data: metadata,
    );

    // If session is null (e.g. Supabase delayed session creation), attempt immediate sign in
    if (response.session == null) {
      try {
        return await client.auth.signInWithPassword(
          email: canonicalAuthEmail,
          password: password,
        );
      } catch (_) {
        // Return original response if sign in fails
      }
    }

    return response;
  }

  /// Sign in with phone number or email and password
  static Future<AuthResponse> signIn({
    required String phoneOrEmail,
    required String password,
  }) async {
    final trimmed = phoneOrEmail.trim();
    String targetEmail = '';

    // 1. Try resolving via RPC helper (supports phone lookup and custom profile email lookup)
    try {
      final resolved = await client.rpc('get_auth_email_for_login', params: {
        'p_identifier': trimmed,
      });
      if (resolved != null && resolved.toString().isNotEmpty) {
        targetEmail = resolved.toString();
      }
    } catch (e) {
      debugPrint('get_auth_email_for_login RPC notice: $e');
    }

    // 2. Fallback email determination if RPC helper is not available
    if (targetEmail.isEmpty) {
      if (trimmed.contains('@')) {
        targetEmail = trimmed;
      } else {
        final cleanPhone = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
        targetEmail = '$cleanPhone@patient.nationalhospital.com';
      }
    }

    try {
      return await client.auth.signInWithPassword(
        email: targetEmail,
        password: password,
      );
    } catch (e) {
      // Legacy fallback: check if user was created with old @nationalhospital.local domain
      if (targetEmail.endsWith('@patient.nationalhospital.com')) {
        final cleanPhone = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
        try {
          return await client.auth.signInWithPassword(
            email: '$cleanPhone@nationalhospital.local',
            password: password,
          );
        } catch (_) {}
      }
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  // ========== PROFILES ==========

  /// Get current user profile from public.profiles
  static Future<Map<String, dynamic>?> getMyProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      return null;
    }
  }

  /// Update current user profile
  static Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? email,
    int? age,
    String? gender,
  }) async {
    final user = currentUser;
    if (user == null) return false;

    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (email != null) updates['email'] = email;
      if (age != null) updates['age'] = age;
      if (gender != null) updates['gender'] = gender;

      if (updates.isEmpty) return true;

      await client.from('profiles').update(updates).eq('id', user.id);
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  // ========== DOCTORS & SPECIALTIES ==========

  static const Map<int, String> _weekdayBengali = {
    0: 'রবিবার',
    1: 'সোমবার',
    2: 'মঙ্গলবার',
    3: 'বুধবার',
    4: 'বৃহস্পতিবার',
    5: 'শুক্রবার',
    6: 'শনিবার',
  };

  /// Format HH:mm:ss to Bengali display string
  static String _formatTimeBn(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return 'বিকাল ৫:০০ টা – রাত ৮:০০ টা';
    final parts = timeStr.split(':');
    final hour = int.tryParse(parts[0]) ?? 17;
    final min = parts.length > 1 ? parts[1] : '00';
    
    final period = hour >= 12 ? (hour >= 18 ? 'রাত' : 'বিকাল') : 'সকাল';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$period $displayHour:$min টা';
  }

  /// Fetch active specialties from public.specialties
  static Future<List<Map<String, dynamic>>> getSpecialties() async {
    try {
      final response = await client
          .from('specialties')
          .select()
          .order('name_bn', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching specialties: $e');
      return [];
    }
  }

  /// Fetch active doctors with their specialty info and schedules
  static Future<List<Doctor>> getDoctors({int? specialtyId, String? searchQuery}) async {
    try {
      var query = client
          .from('doctors')
          .select('*, specialties(name_bn), doctor_schedules(weekday, start_time, end_time, slot_minutes)')
          .eq('is_active', true);

      if (specialtyId != null) {
        query = query.eq('specialty_id', specialtyId);
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.or('name_bn.ilike.%$searchQuery%,degree.ilike.%$searchQuery%');
      }

      final List<dynamic> response = await query.order('name_bn');

      if (response.isEmpty) {
        return Doctor.sampleDoctors;
      }

      return response.map<Doctor>((doc) => mapDoctorFromDb(doc as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error fetching doctors from Supabase: $e');
      return Doctor.sampleDoctors;
    }
  }

  /// Map raw DB row to Doctor model
  static Doctor mapDoctorFromDb(Map<String, dynamic> doc) {
    final specialtyMap = doc['specialties'] as Map<String, dynamic>?;
    final specialtyName = specialtyMap?['name_bn'] ?? 'সাধারণ চিকিৎসা';

    // Parse schedules
    final schedulesList = (doc['doctor_schedules'] as List<dynamic>?) ?? [];
    final List<String> days = [];
    String chamberTimeDisplay = 'বিকাল ৫:০০ টা – রাত ৮:০০ টা';

    if (schedulesList.isNotEmpty) {
      final sortedDays = schedulesList
          .map((s) => s['weekday'] as int?)
          .whereType<int>()
          .toSet()
          .toList()
        ..sort();

      for (final day in sortedDays) {
        if (_weekdayBengali.containsKey(day)) {
          days.add(_weekdayBengali[day]!);
        }
      }

      final firstSched = schedulesList.first;
      final startTime = firstSched['start_time']?.toString();
      final endTime = firstSched['end_time']?.toString();
      if (startTime != null && endTime != null) {
        chamberTimeDisplay = '${_formatTimeBn(startTime)} – ${_formatTimeBn(endTime)}';
      }
    }

    if (days.isEmpty) {
      days.addAll(['শনিবার', 'রবিবার', 'মঙ্গলবার', 'বুধবার']);
    }

    final photo = doc['photo_url']?.toString();
    final avatar = (photo != null && photo.startsWith('http'))
        ? photo
        : 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80';

    return Doctor(
      id: doc['id']?.toString() ?? '',
      name: doc['name_bn']?.toString() ?? '',
      degrees: doc['degree']?.toString() ?? '',
      specialty: specialtyName,
      hospital: 'ন্যাশনাল হাসপাতাল চট্টগ্রাম',
      avatarUrl: avatar,
      rating: 4.9,
      totalReviews: 120,
      availableDays: days,
      chamberTime: chamberTimeDisplay,
      roomNo: doc['room_no']?.toString() ?? '৪০২ নং রুম (৪র্থ তলা)',
      fee: (doc['fee'] as num?)?.toInt() ?? 1000,
      nextAvailableDate: 'আজ, $chamberTimeDisplay',
      isAvailableToday: true,
    );
  }

  /// Fetch active featured doctors ordered by display_order ASC
  static Future<List<FeaturedDoctor>> getFeaturedDoctors() async {
    try {
      // Query featured_doctors joining doctors and specialties
      final List<dynamic> response = await client
          .from('featured_doctors')
          .select('*, doctors(*, specialties(name_bn), doctor_schedules(weekday, start_time, end_time, slot_minutes))')
          .eq('is_active', true)
          .order('display_order', ascending: true);

      final List<FeaturedDoctor> featuredList = [];
      for (final item in response) {
        final row = item as Map<String, dynamic>;
        
        // Date scheduling validation
        final startsAtStr = row['starts_at']?.toString();
        final endsAtStr = row['ends_at']?.toString();
        if (startsAtStr != null) {
          final startsAt = DateTime.tryParse(startsAtStr);
          if (startsAt != null && startsAt.isAfter(DateTime.now())) continue;
        }
        if (endsAtStr != null) {
          final endsAt = DateTime.tryParse(endsAtStr);
          if (endsAt != null && endsAt.isBefore(DateTime.now())) continue;
        }

        final doctorRow = row['doctors'] as Map<String, dynamic>?;
        if (doctorRow == null) continue;
        final doc = mapDoctorFromDb(doctorRow);

        featuredList.add(FeaturedDoctor.fromMap(row, doc));
      }

      return featuredList;
    } catch (e) {
      debugPrint('Error fetching featured doctors: $e');
      return [];
    }
  }

  // ========== APPOINTMENTS ==========

  /// Get current user's appointments
  static Future<List<AppointmentBooking>> getMyAppointments() async {
    final user = currentUser;
    if (user == null) return [];

    try {
      final List<dynamic> response = await client
          .from('appointments')
          .select('*, doctors(name_bn, room_no, fee, specialties(name_bn))')
          .eq('user_id', user.id)
          .order('appointment_date', ascending: false);

      return response.map<AppointmentBooking>((row) {
        final doc = row['doctors'] as Map<String, dynamic>?;
        final spec = doc?['specialties'] as Map<String, dynamic>?;

        final serialNum = row['serial_no'] != null ? 'নং ${row['serial_no']}' : 'নিশ্চিত';
        final statusBn = row['status'] == 'cancelled' ? 'বাতিল' : 'নিশ্চিত';

        return AppointmentBooking(
          serialNo: serialNum,
          doctorName: doc?['name_bn']?.toString() ?? 'ডাক্তার',
          doctorSpecialty: spec?['name_bn']?.toString() ?? 'সাধারণ চিকিৎসা',
          appointmentDate: row['appointment_date']?.toString() ?? '',
          appointmentTime: row['slot_time']?.toString() ?? '',
          roomNo: doc?['room_no']?.toString() ?? 'চেম্বার রুম',
          patientName: user.userMetadata?['full_name']?.toString() ?? 'রোগী',
          patientPhone: user.userMetadata?['phone']?.toString() ?? '',
          fee: (doc?['fee'] as num?)?.toInt() ?? 1000,
          status: statusBn,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      return [];
    }
  }

  /// Book an appointment
  static Future<AppointmentBooking?> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String doctorSpecialty,
    required String roomNo,
    required int fee,
    required DateTime appointmentDate,
    required String slotTime,
    required String patientName,
    required String patientPhone,
  }) async {
    final user = currentUser;
    final dateStr = appointmentDate.toIso8601String().split('T')[0];

    try {
      if (user != null) {
        final inserted = await client.from('appointments').insert({
          'user_id': user.id,
          'doctor_id': doctorId,
          'appointment_date': dateStr,
          'slot_time': slotTime,
          'status': 'booked',
        }).select().single();

        final serialNo = inserted['serial_no'] != null
            ? 'নং ${inserted['serial_no']}'
            : '১২';

        return AppointmentBooking(
          serialNo: serialNo,
          doctorName: doctorName,
          doctorSpecialty: doctorSpecialty,
          appointmentDate: dateStr,
          appointmentTime: slotTime,
          roomNo: roomNo,
          patientName: patientName,
          patientPhone: patientPhone,
          fee: fee,
          status: 'নিশ্চিত',
        );
      }
    } catch (e) {
      debugPrint('Error booking appointment in Supabase: $e');
    }

    // Fallback confirmation for guest
    return AppointmentBooking(
      serialNo: 'নং ১৫',
      doctorName: doctorName,
      doctorSpecialty: doctorSpecialty,
      appointmentDate: dateStr,
      appointmentTime: slotTime,
      roomNo: roomNo,
      patientName: patientName,
      patientPhone: patientPhone,
      fee: fee,
      status: 'নিশ্চিত',
    );
  }

  /// Get booked slots for a given doctor and date
  static Future<List<String>> getBookedSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().split('T')[0];
    try {
      final List<dynamic> result = await client.rpc(
        'get_booked_slots',
        params: {
          'p_doctor': doctorId,
          'p_date': dateStr,
        },
      );
      return result.map((e) => e['slot_time']?.toString() ?? '').toList();
    } catch (e) {
      debugPrint('Error getting booked slots: $e');
      return [];
    }
  }
}
