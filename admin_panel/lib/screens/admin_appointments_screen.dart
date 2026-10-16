import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../theme/app_theme.dart';

class AdminAppointmentsScreen extends StatefulWidget {
  const AdminAppointmentsScreen({super.key});

  @override
  State<AdminAppointmentsScreen> createState() => _AdminAppointmentsScreenState();
}

class _AdminAppointmentsScreenState extends State<AdminAppointmentsScreen> {
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);
    try {
      final list = await AdminService.getAllAppointmentsAdmin(status: _selectedStatus);
      if (mounted) {
        setState(() {
          _appointments = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _changeStatus(String id, String newStatus) async {
    try {
      await AdminService.updateAppointmentStatus(id, newStatus);
      await _loadAppointments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('স্ট্যাটাস আপডেট ব্যর্থ: $e'), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('অ্যাপয়েন্টমেন্ট ট্র্যাকার (Appointments)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text('হাসপাতালের লাইভ সিরিয়াল ও রোগী বুকিংস (${_appointments.length} টি)',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              Row(
                children: [
                  DropdownButton<String?>(
                    value: _selectedStatus,
                    hint: const Text('সকল স্ট্যাটাস'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('সকল স্ট্যাটাস')),
                      DropdownMenuItem(value: 'booked', child: Text('বুকড (Booked)')),
                      DropdownMenuItem(value: 'completed', child: Text('সম্পন্ন (Completed)')),
                      DropdownMenuItem(value: 'cancelled', child: Text('বাতিল (Cancelled)')),
                    ],
                    onChanged: (v) {
                      setState(() => _selectedStatus = v);
                      _loadAppointments();
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAppointments),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                            columns: const [
                              DataColumn(label: Text('সিরিয়াল')),
                              DataColumn(label: Text('রোগী (Patient)')),
                              DataColumn(label: Text('ডাক্তার')),
                              DataColumn(label: Text('তারিখ ও সময়')),
                              DataColumn(label: Text('বর্তমান স্ট্যাটাস')),
                              DataColumn(label: Text('পরিবর্তন')),
                            ],
                            rows: _appointments.map((appt) {
                              final doc = appt['doctors'] as Map<String, dynamic>?;
                              final profile = appt['profiles'] as Map<String, dynamic>?;
                              final status = appt['status']?.toString() ?? 'booked';
                              final serialNo = appt['serial_no'] != null ? '#${appt['serial_no']}' : '-';

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryFixed.withAlpha(80),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(serialNo, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(profile?['full_name']?.toString() ?? 'রোগী', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(profile?['phone']?.toString() ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(doc?['name_bn']?.toString() ?? 'ডাক্তার', style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ),
                                  DataCell(
                                    Text('${appt['appointment_date']} • ${appt['slot_time']}', style: const TextStyle(fontSize: 12)),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: status == 'completed'
                                            ? const Color(0xFFDCFCE7)
                                            : status == 'cancelled'
                                                ? const Color(0xFFFEE2E2)
                                                : const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        status == 'completed'
                                            ? 'সম্পন্ন'
                                            : status == 'cancelled'
                                                ? 'বাতিল'
                                                : 'বুকড',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: status == 'completed'
                                              ? const Color(0xFF15803D)
                                              : status == 'cancelled'
                                                  ? const Color(0xFFB91C1C)
                                                  : const Color(0xFFB45309),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      onSelected: (val) => _changeStatus(appt['id'].toString(), val),
                                      itemBuilder: (ctx) => [
                                        const PopupMenuItem(value: 'booked', child: Text('বুকড (Booked)')),
                                        const PopupMenuItem(value: 'completed', child: Text('সম্পন্ন (Completed)')),
                                        const PopupMenuItem(value: 'cancelled', child: Text('বাতিল (Cancelled)')),
                                      ],
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('বদলান', style: TextStyle(color: AppTheme.primary, fontSize: 12)),
                                          Icon(Icons.arrow_drop_down, size: 18, color: AppTheme.primary),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
