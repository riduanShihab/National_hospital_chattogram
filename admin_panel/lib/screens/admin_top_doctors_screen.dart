import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';
import '../../services/admin_service.dart';
import '../../theme/app_theme.dart';

class AdminTopDoctorsScreen extends StatefulWidget {
  const AdminTopDoctorsScreen({super.key});

  @override
  State<AdminTopDoctorsScreen> createState() => _AdminTopDoctorsScreenState();
}

class _AdminTopDoctorsScreenState extends State<AdminTopDoctorsScreen> {
  List<FeaturedDoctor> _topDoctors = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTopDoctors();
  }

  Future<void> _loadTopDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await AdminService.getAllFeaturedDoctorsAdmin();
      if (mounted) {
        setState(() {
          _topDoctors = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'টপ ডাক্তার তালিকা লোড করা যায়নি: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _moveUp(FeaturedDoctor item, int currentIndex) async {
    if (currentIndex <= 0) return;
    final targetRank = currentIndex; // Previous 1-based rank
    try {
      await AdminService.reorderFeaturedDoctor(id: item.id, newOrder: targetRank);
      await _loadTopDoctors();
    } catch (e) {
      _showSnackbar('র‌্যাংক পরিবর্তন ব্যর্থ: $e', isError: true);
    }
  }

  Future<void> _moveDown(FeaturedDoctor item, int currentIndex) async {
    if (currentIndex >= _topDoctors.length - 1) return;
    final targetRank = currentIndex + 2; // Next 1-based rank
    try {
      await AdminService.reorderFeaturedDoctor(id: item.id, newOrder: targetRank);
      await _loadTopDoctors();
    } catch (e) {
      _showSnackbar('র‌্যাংক পরিবর্তন ব্যর্থ: $e', isError: true);
    }
  }

  Future<void> _toggleStatus(FeaturedDoctor item) async {
    try {
      final newStatus = !item.isActive;
      await AdminService.toggleFeaturedDoctorStatus(item.id, newStatus);
      await _loadTopDoctors();
      _showSnackbar(newStatus ? 'ডাক্তার সক্রিয় করা হয়েছে' : 'ডাক্তার নিষ্ক্রিয় করা হয়েছে');
    } catch (e) {
      _showSnackbar('স্ট্যাটাস আপডেট ব্যর্থ: $e', isError: true);
    }
  }

  Future<void> _deleteDoctor(FeaturedDoctor item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('টপ ডাক্তার অপসারণ'),
        content: Text('আপনি কি নিশ্চিত যে "${item.doctor.name}"-কে সেরা ডাক্তার তালিকা থেকে সরাতে চান?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('বাতিল')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('অপসারণ করুন'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AdminService.deleteFeaturedDoctor(item.id);
        await _loadTopDoctors();
        _showSnackbar('টপ ডাক্তার তালিকা থেকে অপসারিত হয়েছে');
      } catch (e) {
        _showSnackbar('অপসারণ ব্যর্থ: $e', isError: true);
      }
    }
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.error : const Color(0xFF16A34A),
      ),
    );
  }

  void _openAddTopDoctorDialog() async {
    // Fetch available doctors that are not yet featured
    final allDoctors = await AdminService.getAllDoctorsAdmin();
    final featuredDocIds = _topDoctors.map((f) => f.doctorId).toSet();
    final availableDoctors = allDoctors.where((d) => !featuredDocIds.contains(d.id)).toList();

    if (!mounted) return;

    if (availableDoctors.isEmpty) {
      _showSnackbar('সকল ডাক্তার ইতিমধ্যে টপ ডাক্তার হিসেবে অন্তর্ভুক্ত রয়েছেন অথবা ডাক্তার তালিকা খালি।');
      return;
    }

    Doctor? selectedDoctor = availableDoctors.first;
    final titleController = TextEditingController(text: 'সিনিয়র কনসালট্যান্ট');
    final orderController = TextEditingController(text: '${_topDoctors.length + 1}');
    bool isActive = true;
    DateTime? startsAt;
    DateTime? endsAt;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('নতুন সেরা (Top) ডাক্তার যোগ করুন'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ডাক্তার নির্বাচন করুন:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<Doctor>(
                    initialValue: selectedDoctor,
                    isExpanded: true,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: availableDoctors.map((doc) {
                      return DropdownMenuItem<Doctor>(
                        value: doc,
                        child: Text('${doc.name} (${doc.specialty})', overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDlgState(() => selectedDoctor = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  const Text('ফিচার্ড শিরোনাম (Featured Title):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'যেমন: সিনিয়র কনসালট্যান্ট / হেড অফ ডিপার্টমেন্ট',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('ডিসপ্লে র‍্যাংক / ক্রম (Display Order):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: orderController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '১, ২, ৩...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Text('সক্রিয় (Active):', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (v) => setDlgState(() => isActive = v),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  const Text('তারিখ শিডিউলিং (ঐচ্ছিক):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            startsAt == null ? 'শুরুর তারিখ' : '${startsAt!.day}/${startsAt!.month}/${startsAt!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: startsAt ?? DateTime.now(),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setDlgState(() => startsAt = d);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.event_busy, size: 16),
                          label: Text(
                            endsAt == null ? 'শেষের তারিখ' : '${endsAt!.day}/${endsAt!.month}/${endsAt!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: endsAt ?? DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setDlgState(() => endsAt = d);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
            FilledButton(
              onPressed: () async {
                if (selectedDoctor == null) return;
                final order = int.tryParse(orderController.text.trim()) ?? (_topDoctors.length + 1);
                Navigator.pop(ctx);
                try {
                  await AdminService.addFeaturedDoctor(
                    doctorId: selectedDoctor!.id,
                    title: titleController.text.trim(),
                    displayOrder: order,
                    isActive: isActive,
                    startsAt: startsAt,
                    endsAt: endsAt,
                  );
                  await _loadTopDoctors();
                  _showSnackbar('টপ ডাক্তার সফলভাবে যোগ করা হয়েছে');
                } catch (e) {
                  _showSnackbar('যোগ করতে ব্যর্থ: $e', isError: true);
                }
              },
              child: const Text('সংরক্ষণ করুন'),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditDialog(FeaturedDoctor item) async {
    final titleController = TextEditingController(text: item.title ?? 'সিনিয়র কনসালট্যান্ট');
    final orderController = TextEditingController(text: '${item.displayOrder}');
    bool isActive = item.isActive;
    DateTime? startsAt = item.startsAt;
    DateTime? endsAt = item.endsAt;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text('সম্পাদনা: ${item.doctor.name}'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('বিভাগ: ${item.doctor.specialty}', style: const TextStyle(color: AppTheme.primary)),
                  const SizedBox(height: 14),

                  const Text('ফিচার্ড শিরোনাম (Featured Title):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 14),

                  const Text('ডিসপ্লে র‍্যাংক (Display Order):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: orderController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Text('সক্রিয় (Active):', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (v) => setDlgState(() => isActive = v),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  const Text('তারিখ শিডিউলিং (ঐচ্ছিক):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            startsAt == null ? 'শুরুর তারিখ' : '${startsAt!.day}/${startsAt!.month}/${startsAt!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: startsAt ?? DateTime.now(),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setDlgState(() => startsAt = d);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.event_busy, size: 16),
                          label: Text(
                            endsAt == null ? 'শেষের তারিখ' : '${endsAt!.day}/${endsAt!.month}/${endsAt!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: endsAt ?? DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setDlgState(() => endsAt = d);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
            FilledButton(
              onPressed: () async {
                final order = int.tryParse(orderController.text.trim()) ?? item.displayOrder;
                Navigator.pop(ctx);
                try {
                  await AdminService.updateFeaturedDoctor(
                    id: item.id,
                    title: titleController.text.trim(),
                    displayOrder: order,
                    isActive: isActive,
                    startsAt: startsAt,
                    endsAt: endsAt,
                  );
                  await _loadTopDoctors();
                  _showSnackbar('টপ ডাক্তার আপডেট করা হয়েছে');
                } catch (e) {
                  _showSnackbar('আপডেট ব্যর্থ: $e', isError: true);
                }
              },
              child: const Text('আপডেট করুন'),
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'টপ / হিরো ডাক্তার ব্যবস্থাপনা (Top Doctors)',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'পেশেন্ট অ্যাপের হোম পেজে প্রদর্শিত সেরা ডাক্তারদের ক্রম ও স্ট্যাটাস পরিচালনা করুন (${_topDoctors.length} জন)',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'রিফ্রেশ',
                    onPressed: _loadTopDoctors,
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _openAddTopDoctorDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('টপ ডাক্তার যোগ করুন'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFB91C1C))),
            ),

          // Main Table / List Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _topDoctors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.stars_rounded, size: 64, color: Color(0xFFCBD5E1)),
                            const SizedBox(height: 12),
                            const Text(
                              'কোনো সেরা ডাক্তার নির্ধারণ করা নেই',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text('উপরের বাটনে ক্লিক করে নতুন সেরা ডাক্তার যোগ করুন।'),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: _openAddTopDoctorDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('টপ ডাক্তার যোগ করুন'),
                            ),
                          ],
                        ),
                      )
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
                                columnSpacing: 20,
                                columns: const [
                                  DataColumn(label: Text('ক্রম / র‍্যাংক', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('ডাক্তার', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('বিভাগ ও চেম্বার', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('তারিখ সীমা', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('অ্যাকশন', style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: _topDoctors.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  final doc = item.doctor;

                                  return DataRow(
                                    cells: [
                                      // Rank Column with up/down arrows
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppTheme.tertiaryFixed,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '#${item.displayOrder}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.tertiary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: index > 0 ? () => _moveUp(item, index) : null,
                                                  child: Icon(
                                                    Icons.arrow_drop_up,
                                                    size: 20,
                                                    color: index > 0 ? Colors.black87 : Colors.grey.shade300,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: index < _topDoctors.length - 1 ? () => _moveDown(item, index) : null,
                                                  child: Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 20,
                                                    color: index < _topDoctors.length - 1 ? Colors.black87 : Colors.grey.shade300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Doctor Photo & Name
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundImage: NetworkImage(doc.displayAvatarUrl),
                                              onBackgroundImageError: (_, _) {},
                                              child: doc.displayAvatarUrl.isEmpty ? const Icon(Icons.person, size: 20) : null,
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  doc.name,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                ),
                                                if (item.title != null)
                                                  Text(
                                                    item.title!,
                                                    style: const TextStyle(color: AppTheme.primary, fontSize: 11),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Specialty & Room
                                      DataCell(
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(doc.specialty, style: const TextStyle(fontSize: 12)),
                                            Text(doc.roomNo, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                          ],
                                        ),
                                      ),

                                      // Status Badge
                                      DataCell(
                                        InkWell(
                                          onTap: () => _toggleStatus(item),
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: item.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: item.isActive ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  item.isActive ? Icons.check_circle : Icons.pause_circle_outline,
                                                  size: 14,
                                                  color: item.isActive ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  item.isActive ? 'সক্রিয়' : 'নিষ্ক্রিয়',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: item.isActive ? const Color(0xFF15803D) : const Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Date Range
                                      DataCell(
                                        Text(
                                          (item.startsAt == null && item.endsAt == null)
                                              ? 'সর্বদা দৃশ্যমান'
                                              : '${item.startsAt != null ? "${item.startsAt!.day}/${item.startsAt!.month}" : "শুরু"} – ${item.endsAt != null ? "${item.endsAt!.day}/${item.endsAt!.month}" : "অনির্দিষ্ট"}',
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                                        ),
                                      ),

                                      // Actions
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit_outlined, size: 18),
                                              tooltip: 'সম্পাদনা',
                                              onPressed: () => _openEditDialog(item),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.error),
                                              tooltip: 'অপসারণ',
                                              onPressed: () => _deleteDoctor(item),
                                            ),
                                          ],
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
