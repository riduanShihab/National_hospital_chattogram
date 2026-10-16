import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';
import '../../services/admin_service.dart';
import '../../theme/app_theme.dart';

class AdminSchedulesScreen extends StatefulWidget {
  const AdminSchedulesScreen({super.key});

  @override
  State<AdminSchedulesScreen> createState() => _AdminSchedulesScreenState();
}

class _AdminSchedulesScreenState extends State<AdminSchedulesScreen> {
  List<Map<String, dynamic>> _schedules = [];
  List<Doctor> _doctors = [];
  bool _isLoading = true;
  String? _selectedDoctorId;

  static const Map<int, String> _weekdays = {
    0: 'রবিবার (Sunday)',
    1: 'সোমবার (Monday)',
    2: 'মঙ্গলবার (Tuesday)',
    3: 'বুধবার (Wednesday)',
    4: 'বৃহস্পতিবার (Thursday)',
    5: 'শুক্রবার (Friday)',
    6: 'শনিবার (Saturday)',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        AdminService.getAllSchedulesAdmin(doctorId: _selectedDoctorId),
        AdminService.getAllDoctorsAdmin(),
      ]);
      if (mounted) {
        setState(() {
          _schedules = results[0] as List<Map<String, dynamic>>;
          _doctors = results[1] as List<Doctor>;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openScheduleDialog() {
    if (_doctors.isEmpty) return;
    String docId = _selectedDoctorId ?? _doctors.first.id;
    int weekday = 6; // Saturday default
    final startController = TextEditingController(text: '17:00:00');
    final endController = TextEditingController(text: '20:00:00');
    final slotController = TextEditingController(text: '15');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('নতুন চেম্বার শিডিউল যোগ করুন'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: docId,
                    decoration: const InputDecoration(labelText: 'ডাক্তার নির্বাচন', border: OutlineInputBorder()),
                    items: _doctors.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                    onChanged: (v) {
                      if (v != null) setDlgState(() => docId = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: weekday,
                    decoration: const InputDecoration(labelText: 'সপ্তাহের বার', border: OutlineInputBorder()),
                    items: _weekdays.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                    onChanged: (v) {
                      if (v != null) setDlgState(() => weekday = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startController,
                          decoration: const InputDecoration(labelText: 'শুরু (যেমন: 17:00:00)', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: endController,
                          decoration: const InputDecoration(labelText: 'সমাপ্তি (যেমন: 20:00:00)', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: slotController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'প্রতি স্লট মিনিট (Slot Minutes)', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await AdminService.saveSchedule(
                    doctorId: docId,
                    weekday: weekday,
                    startTime: startController.text.trim(),
                    endTime: endController.text.trim(),
                    slotMinutes: int.tryParse(slotController.text.trim()) ?? 15,
                  );
                  await _loadData();
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('শিডিউল সংরক্ষণ ব্যর্থ: $e'), backgroundColor: AppTheme.error),
                  );
                }
              },
              child: const Text('সংরক্ষণ করুন'),
            ),
          ],
        ),
      ),
    );
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ডাক্তারদের চেম্বার শিডিউল (Schedules)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  SizedBox(height: 4),
                  Text('সাপ্তাহিক ভিজিটিং ডে ও সময়সূচী পরিচালনা', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              FilledButton.icon(
                onPressed: _openScheduleDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('শিডিউল যোগ করুন'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Doctor filter
          Row(
            children: [
              Expanded(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: _selectedDoctorId,
                  hint: const Text('সকল ডাক্তারের শিডিউল'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('সকল ডাক্তারের শিডিউল')),
                    ..._doctors.map((d) => DropdownMenuItem<String?>(value: d.id, child: Text(d.name))),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedDoctorId = v);
                    _loadData();
                  },
                ),
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
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
                    child: ListView.separated(
                      itemCount: _schedules.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final s = _schedules[index];
                        final doc = s['doctors'] as Map<String, dynamic>?;
                        final weekdayInt = s['weekday'] as int? ?? 0;
                        final dayName = _weekdays[weekdayInt] ?? 'বার $weekdayInt';

                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFCCFBF1),
                            child: Icon(Icons.access_time_rounded, color: Color(0xFF0D9488)),
                          ),
                          title: Text(doc?['name_bn']?.toString() ?? 'ডাক্তার', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('$dayName • ${s['start_time']} হতে ${s['end_time']} (স্লট: ${s['slot_minutes']} মিনিট)'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                            onPressed: () async {
                              await AdminService.deleteSchedule(s['id'].toString());
                              _loadData();
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
