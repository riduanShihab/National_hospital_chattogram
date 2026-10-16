import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hospital_models.dart';
import 'supabase_service.dart';

class AdminService {
  AdminService._();

  static SupabaseClient get _client => SupabaseService.client;

  // ========== AUTH & ROLE VERIFICATION ==========

  /// Check if the currently signed in user has an authorized admin role
  static Future<bool> isCurrentUserAdmin() async {
    final user = SupabaseService.currentUser;
    if (user == null) return false;

    try {
      // 1. Try is_admin RPC function
      final dynamic rpcResult = await _client.rpc('is_admin', params: {
        'p_user_id': user.id,
      });
      if (rpcResult == true) return true;
    } catch (e) {
      debugPrint('is_admin RPC notice: $e');
    }

    try {
      // 2. Query user_roles table directly
      final roles = await _client
          .from('user_roles')
          .select('role')
          .eq('user_id', user.id);
      
      final hasAdminRole = roles.any((r) =>
          r['role'] == 'admin' ||
          r['role'] == 'super_admin' ||
          r['role'] == 'staff');
      if (hasAdminRole) return true;

      // 3. Fallback for bootstrapping: If user_roles is completely empty, allow initial authenticated user
      final allRoles = await _client.from('user_roles').select('user_id').limit(1);
      if (allRoles.isEmpty) {
        // Auto-assign admin role to the first user
        try {
          await _client.from('user_roles').insert({
            'user_id': user.id,
            'role': 'super_admin',
          });
          return true;
        } catch (_) {
          return true;
        }
      }
    } catch (e) {
      debugPrint('user_roles query notice: $e');
    }

    return false;
  }

  // ========== DASHBOARD METRICS ==========

  static Future<AdminDashboardStats> getDashboardStats() async {
    int totalDoctors = 0;
    int activeDoctors = 0;
    int featuredDoctors = 0;
    int totalAppointments = 0;
    int todayAppointments = 0;
    int totalSpecialties = 0;

    try {
      final docRes = await _client.from('doctors').select('id, is_active');
      totalDoctors = docRes.length;
      activeDoctors = docRes.where((d) => d['is_active'] == true).length;
    } catch (e) {
      debugPrint('Error getting doctors stats: $e');
    }

    try {
      final featRes = await _client.from('featured_doctors').select('id');
      featuredDoctors = featRes.length;
    } catch (e) {
      debugPrint('Error getting featured doctors count: $e');
    }

    try {
      final specRes = await _client.from('specialties').select('id');
      totalSpecialties = specRes.length;
    } catch (e) {
      debugPrint('Error getting specialties count: $e');
    }

    try {
      final todayStr = DateTime.now().toIso8601String().split('T')[0];
      final apptRes = await _client.from('appointments').select('id, appointment_date, status');
      totalAppointments = apptRes.length;
      todayAppointments = apptRes.where((a) => a['appointment_date'] == todayStr).length;
    } catch (e) {
      debugPrint('Error getting appointments stats: $e');
    }

    return AdminDashboardStats(
      totalDoctors: totalDoctors,
      activeDoctors: activeDoctors,
      featuredDoctors: featuredDoctors,
      totalAppointments: totalAppointments,
      todayAppointments: todayAppointments,
      totalSpecialties: totalSpecialties,
    );
  }

  // ========== TOP / FEATURED DOCTORS ==========

  /// Get all featured doctors (active & inactive) ordered by display_order
  static Future<List<FeaturedDoctor>> getAllFeaturedDoctorsAdmin() async {
    try {
      final List<dynamic> response = await _client
          .from('featured_doctors')
          .select('*, doctors(*, specialties(name_bn), doctor_schedules(weekday, start_time, end_time, slot_minutes))')
          .order('display_order', ascending: true);

      final List<FeaturedDoctor> list = [];
      for (final item in response) {
        final row = item as Map<String, dynamic>;
        final docRow = row['doctors'] as Map<String, dynamic>?;
        if (docRow == null) continue;
        final doc = SupabaseService.mapDoctorFromDb(docRow);
        list.add(FeaturedDoctor.fromMap(row, doc));
      }
      return list;
    } catch (e) {
      debugPrint('Error getting all featured doctors for admin: $e');
      return [];
    }
  }

  /// Add a doctor to Top Doctors
  static Future<bool> addFeaturedDoctor({
    required String doctorId,
    String? title,
    required int displayOrder,
    bool isActive = true,
    DateTime? startsAt,
    DateTime? endsAt,
  }) async {
    try {
      final data = <String, dynamic>{
        'doctor_id': doctorId,
        'title': (title != null && title.trim().isNotEmpty) ? title.trim() : 'সিনিয়র কনসালট্যান্ট',
        'display_order': displayOrder,
        'is_active': isActive,
        'starts_at': startsAt?.toIso8601String(),
        'ends_at': endsAt?.toIso8601String(),
      };

      await _client.from('featured_doctors').insert(data);
      await logAction(
        action: 'add_top_doctor',
        entityType: 'featured_doctors',
        entityId: doctorId,
        metadata: {'order': displayOrder, 'title': title},
      );
      return true;
    } catch (e) {
      debugPrint('Error adding featured doctor: $e');
      rethrow;
    }
  }

  /// Update an existing Top Doctor
  static Future<bool> updateFeaturedDoctor({
    required String id,
    String? title,
    required int displayOrder,
    required bool isActive,
    DateTime? startsAt,
    DateTime? endsAt,
  }) async {
    try {
      final updates = <String, dynamic>{
        'title': title,
        'display_order': displayOrder,
        'is_active': isActive,
        'starts_at': startsAt?.toIso8601String(),
        'ends_at': endsAt?.toIso8601String(),
      };

      await _client.from('featured_doctors').update(updates).eq('id', id);
      await logAction(
        action: 'update_top_doctor',
        entityType: 'featured_doctors',
        entityId: id,
        metadata: updates,
      );
      return true;
    } catch (e) {
      debugPrint('Error updating featured doctor: $e');
      rethrow;
    }
  }

  /// Delete a Top Doctor
  static Future<bool> deleteFeaturedDoctor(String id) async {
    try {
      await _client.from('featured_doctors').delete().eq('id', id);
      await logAction(
        action: 'delete_top_doctor',
        entityType: 'featured_doctors',
        entityId: id,
      );
      return true;
    } catch (e) {
      debugPrint('Error deleting featured doctor: $e');
      rethrow;
    }
  }

  /// Reorder Top Doctor (Move up / down or explicit rank)
  static Future<void> reorderFeaturedDoctor({
    required String id,
    required int newOrder,
  }) async {
    try {
      // 1. Try RPC reordering
      await _client.rpc('reorder_featured_doctors', params: {
        'p_id': id,
        'p_new_order': newOrder,
      });
      await logAction(
        action: 'reorder_top_doctor',
        entityType: 'featured_doctors',
        entityId: id,
        metadata: {'new_order': newOrder},
      );
      return;
    } catch (e) {
      debugPrint('reorder RPC fallback: $e');
    }

    // 2. Client-side reordering fallback
    try {
      await _client.from('featured_doctors').update({'display_order': newOrder}).eq('id', id);
    } catch (e) {
      debugPrint('Direct reorder update failed: $e');
    }
  }

  /// Toggle top doctor status (Active / Inactive)
  static Future<bool> toggleFeaturedDoctorStatus(String id, bool isActive) async {
    try {
      await _client.from('featured_doctors').update({'is_active': isActive}).eq('id', id);
      await logAction(
        action: isActive ? 'activate_top_doctor' : 'deactivate_top_doctor',
        entityType: 'featured_doctors',
        entityId: id,
      );
      return true;
    } catch (e) {
      debugPrint('Error toggling featured status: $e');
      return false;
    }
  }

  // ========== DOCTORS DIRECTORY MANAGEMENT ==========

  static Future<List<Doctor>> getAllDoctorsAdmin({
    String? searchQuery,
    int? specialtyId,
    bool? isActive,
  }) async {
    try {
      var query = _client
          .from('doctors')
          .select('*, specialties(name_bn), doctor_schedules(weekday, start_time, end_time, slot_minutes)');

      if (specialtyId != null) {
        query = query.eq('specialty_id', specialtyId);
      }
      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.or('name_bn.ilike.%$searchQuery%,degree.ilike.%$searchQuery%');
      }

      final List<dynamic> response = await query.order('name_bn');
      return response.map<Doctor>((d) => SupabaseService.mapDoctorFromDb(d as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting doctors for admin: $e');
      return [];
    }
  }

  static Future<bool> saveDoctor({
    String? id,
    required String nameBn,
    String? degree,
    required int specialtyId,
    int? experienceYears,
    String? bio,
    String? photoUrl,
    bool isActive = true,
    int fee = 1000,
    String? roomNo,
  }) async {
    try {
      final payload = <String, dynamic>{
        'name_bn': nameBn,
        'degree': degree,
        'specialty_id': specialtyId,
        'experience_years': experienceYears,
        'bio': bio,
        'photo_url': photoUrl,
        'is_active': isActive,
        'fee': fee,
        'room_no': roomNo,
      };

      if (id != null && id.isNotEmpty) {
        await _client.from('doctors').update(payload).eq('id', id);
        await logAction(
          action: 'update_doctor',
          entityType: 'doctors',
          entityId: id,
          metadata: {'name': nameBn},
        );
      } else {
        final inserted = await _client.from('doctors').insert(payload).select('id').single();
        await logAction(
          action: 'create_doctor',
          entityType: 'doctors',
          entityId: inserted['id']?.toString(),
          metadata: {'name': nameBn},
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error saving doctor: $e');
      rethrow;
    }
  }

  static Future<bool> toggleDoctorActive(String id, bool isActive) async {
    try {
      await _client.from('doctors').update({'is_active': isActive}).eq('id', id);
      await logAction(
        action: isActive ? 'activate_doctor' : 'deactivate_doctor',
        entityType: 'doctors',
        entityId: id,
      );
      return true;
    } catch (e) {
      debugPrint('Error toggling doctor active: $e');
      return false;
    }
  }

  // ========== SPECIALTIES MANAGEMENT ==========

  static Future<List<Map<String, dynamic>>> getAllSpecialtiesAdmin() async {
    try {
      final response = await _client
          .from('specialties')
          .select('id, name_bn')
          .order('name_bn');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting specialties for admin: $e');
      return [];
    }
  }

  static Future<bool> saveSpecialty({int? id, required String nameBn}) async {
    try {
      if (id != null) {
        await _client.from('specialties').update({'name_bn': nameBn}).eq('id', id);
        await logAction(
          action: 'update_specialty',
          entityType: 'specialties',
          entityId: id.toString(),
          metadata: {'name_bn': nameBn},
        );
      } else {
        await _client.from('specialties').insert({'name_bn': nameBn});
        await logAction(
          action: 'create_specialty',
          entityType: 'specialties',
          metadata: {'name_bn': nameBn},
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error saving specialty: $e');
      rethrow;
    }
  }

  // ========== DOCTOR SCHEDULES MANAGEMENT ==========

  static Future<List<Map<String, dynamic>>> getAllSchedulesAdmin({String? doctorId}) async {
    try {
      var query = _client.from('doctor_schedules').select('*, doctors(name_bn, room_no, specialties(name_bn))');
      if (doctorId != null && doctorId.isNotEmpty) {
        query = query.eq('doctor_id', doctorId);
      }
      final response = await query.order('weekday');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting schedules: $e');
      return [];
    }
  }

  static Future<bool> saveSchedule({
    String? id,
    required String doctorId,
    required int weekday,
    required String startTime,
    required String endTime,
    int slotMinutes = 15,
  }) async {
    try {
      final payload = <String, dynamic>{
        'doctor_id': doctorId,
        'weekday': weekday,
        'start_time': startTime,
        'end_time': endTime,
        'slot_minutes': slotMinutes,
      };

      if (id != null && id.isNotEmpty) {
        await _client.from('doctor_schedules').update(payload).eq('id', id);
        await logAction(
          action: 'update_schedule',
          entityType: 'doctor_schedules',
          entityId: id,
          metadata: payload,
        );
      } else {
        await _client.from('doctor_schedules').insert(payload);
        await logAction(
          action: 'create_schedule',
          entityType: 'doctor_schedules',
          metadata: payload,
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error saving schedule: $e');
      rethrow;
    }
  }

  static Future<bool> deleteSchedule(String id) async {
    try {
      await _client.from('doctor_schedules').delete().eq('id', id);
      await logAction(
        action: 'delete_schedule',
        entityType: 'doctor_schedules',
        entityId: id,
      );
      return true;
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
      return false;
    }
  }

  // ========== APPOINTMENTS MANAGEMENT ==========

  static Future<List<Map<String, dynamic>>> getAllAppointmentsAdmin({
    String? status,
    String? doctorId,
    String? searchDate,
  }) async {
    try {
      var query = _client.from('appointments').select('*, doctors(name_bn, room_no, fee, specialties(name_bn)), profiles(full_name, phone, email)');
      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }
      if (doctorId != null && doctorId.isNotEmpty) {
        query = query.eq('doctor_id', doctorId);
      }
      if (searchDate != null && searchDate.isNotEmpty) {
        query = query.eq('appointment_date', searchDate);
      }

      final response = await query.order('appointment_date', ascending: false).limit(100);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting appointments for admin: $e');
      return [];
    }
  }

  static Future<bool> updateAppointmentStatus(String id, String newStatus) async {
    try {
      await _client.from('appointments').update({'status': newStatus}).eq('id', id);
      await logAction(
        action: 'update_appointment_status',
        entityType: 'appointments',
        entityId: id,
        metadata: {'new_status': newStatus},
      );
      return true;
    } catch (e) {
      debugPrint('Error updating appointment status: $e');
      return false;
    }
  }

  // ========== AUDIT LOGGING ==========

  static Future<List<AdminAuditLog>> getAuditLogs() async {
    try {
      final List<dynamic> response = await _client
          .from('admin_audit_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(50);
      return response.map((l) => AdminAuditLog.fromMap(l as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting audit logs: $e');
      return [];
    }
  }

  static Future<void> logAction({
    required String action,
    required String entityType,
    String? entityId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = SupabaseService.currentUser;
      await _client.from('admin_audit_logs').insert({
        'admin_id': user?.id,
        'action': action,
        'entity_type': entityType,
        'entity_id': entityId,
        'metadata': metadata,
      });
    } catch (e) {
      debugPrint('Audit logging notice (non-fatal): $e');
    }
  }
}
