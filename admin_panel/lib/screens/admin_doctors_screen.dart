import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';
import '../../services/admin_service.dart';
import '../../theme/app_theme.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => _AdminDoctorsScreenState();
}

class _AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  List<Doctor> _doctors = [];
  List<Map<String, dynamic>> _specialties = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int? _selectedSpecialtyId;
  bool? _filterActive;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        AdminService.getAllDoctorsAdmin(
          searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
          specialtyId: _selectedSpecialtyId,
          isActive: _filterActive,
        ),
        AdminService.getAllSpecialtiesAdmin(),
      ]);
      if (mounted) {
        setState(() {
          _doctors = results[0] as List<Doctor>;
          _specialties = results[1] as List<Map<String, dynamic>>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openDoctorDialog([Doctor? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final degreeController = TextEditingController(text: existing?.degrees ?? '');
    final feeController = TextEditingController(text: '${existing?.fee ?? 1000}');
    final roomController = TextEditingController(text: existing?.roomNo ?? '৪০২ নং রুম');
    final avatarController = TextEditingController(text: existing?.avatarUrl ?? '');
    
    int selectedSpecId = _specialties.isNotEmpty ? (_specialties.first['id'] as int) : 1;
    if (existing != null) {
      final match = _specialties.firstWhere(
        (s) => s['name_bn'] == existing.specialty,
        orElse: () => _specialties.isNotEmpty ? _specialties.first : {'id': 1},
      );
      selectedSpecId = match['id'] as int;
    }
    bool isActive = existing?.isAvailableToday ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text(existing == null ? 'নতুন ডাক্তার যুক্ত করুন' : 'ডাক্তার সম্পাদনা: ${existing.name}'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'ডাক্তারের নাম (বাংলায়)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: degreeController,
                    decoration: const InputDecoration(labelText: 'ডিগ্রী / পদবী', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: selectedSpecId,
                    decoration: const InputDecoration(labelText: 'বিভাগ / স্পেশালটি', border: OutlineInputBorder()),
                    items: _specialties.map((s) {
                      return DropdownMenuItem<int>(
                        value: s['id'] as int,
                        child: Text(s['name_bn']?.toString() ?? ''),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setDlgState(() => selectedSpecId = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: feeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'পরামর্শ ফি (৳)', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: roomController,
                          decoration: const InputDecoration(labelText: 'চেম্বার রুম নং', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: avatarController,
                    decoration: const InputDecoration(labelText: 'ছবির লিংক (Photo URL - ঐচ্ছিক)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('সক্রিয় স্ট্যাটাস (Active):'),
                      const Spacer(),
                      Switch(value: isActive, onChanged: (v) => setDlgState(() => isActive = v)),
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
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                final fee = int.tryParse(feeController.text.trim()) ?? 1000;
                Navigator.pop(ctx);
                try {
                  await AdminService.saveDoctor(
                    id: existing?.id,
                    nameBn: name,
                    degree: degreeController.text.trim(),
                    specialtyId: selectedSpecId,
                    fee: fee,
                    roomNo: roomController.text.trim(),
                    photoUrl: avatarController.text.trim().isNotEmpty ? avatarController.text.trim() : null,
                    isActive: isActive,
                  );
                  await _loadData();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ডাক্তার তথ্য সংরক্ষিত হয়েছে')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('সংরক্ষণ ব্যর্থ: $e'), backgroundColor: AppTheme.error),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ডাক্তার ডিরেক্টরি ব্যবস্থাপনা',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  Text('হাসপাতালের সকল চিকিৎসকের তালিকা ও চেম্বার নিয়ন্ত্রণ (${_doctors.length} জন)',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              FilledButton.icon(
                onPressed: () => _openDoctorDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('নতুন ডাক্তার যোগ করুন'),
                style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filters Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'ডাক্তারের নাম বা পদবী খুঁজুন...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    _searchQuery = val;
                    _loadData();
                  },
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<int?>(
                value: _selectedSpecialtyId,
                hint: const Text('সকল বিভাগ'),
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('সকল বিভাগ')),
                  ..._specialties.map((s) => DropdownMenuItem<int?>(
                        value: s['id'] as int,
                        child: Text(s['name_bn']?.toString() ?? ''),
                      )),
                ],
                onChanged: (val) {
                  setState(() => _selectedSpecialtyId = val);
                  _loadData();
                },
              ),
              const SizedBox(width: 12),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
            ],
          ),
          const SizedBox(height: 16),

          // Doctor Table
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
                              DataColumn(label: Text('ডাক্তার')),
                              DataColumn(label: Text('বিভাগ')),
                              DataColumn(label: Text('রুম নং')),
                              DataColumn(label: Text('ফি')),
                              DataColumn(label: Text('স্ট্যাটাস')),
                              DataColumn(label: Text('অ্যাকশন')),
                            ],
                            rows: _doctors.map((doc) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(doc.displayAvatarUrl),
                                          onBackgroundImageError: (_, _) {},
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                            Text(doc.degrees, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(doc.specialty, style: const TextStyle(fontSize: 12))),
                                  DataCell(Text(doc.roomNo, style: const TextStyle(fontSize: 12))),
                                  DataCell(Text('৳${doc.fee}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                                  DataCell(
                                    InkWell(
                                      onTap: () async {
                                        await AdminService.toggleDoctorActive(doc.id, !doc.isAvailableToday);
                                        _loadData();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: doc.isAvailableToday ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          doc.isAvailableToday ? 'সক্রিয়' : 'নিষ্ক্রিয়',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: doc.isAvailableToday ? const Color(0xFF15803D) : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18),
                                      onPressed: () => _openDoctorDialog(doc),
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
