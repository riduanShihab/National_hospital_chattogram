import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../theme/app_theme.dart';

class AdminSpecialtiesScreen extends StatefulWidget {
  const AdminSpecialtiesScreen({super.key});

  @override
  State<AdminSpecialtiesScreen> createState() => _AdminSpecialtiesScreenState();
}

class _AdminSpecialtiesScreenState extends State<AdminSpecialtiesScreen> {
  List<Map<String, dynamic>> _specialties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    setState(() => _isLoading = true);
    try {
      final list = await AdminService.getAllSpecialtiesAdmin();
      if (mounted) {
        setState(() {
          _specialties = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openSpecialtyDialog([Map<String, dynamic>? item]) {
    final controller = TextEditingController(text: item?['name_bn']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item == null ? 'নতুন বিভাগ যোগ করুন' : 'বিভাগ সম্পাদনা'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'বিভাগের নাম (বাংলায়)',
            hintText: 'যেমন: হৃদরোগ, শিশু বিশেষজ্ঞ...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(ctx);
              try {
                await AdminService.saveSpecialty(id: item?['id'] as int?, nameBn: name);
                await _loadSpecialties();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('বিভাগ সংরক্ষিত হয়েছে')),
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
                    'বিশেষজ্ঞ বিভাগসমূহ (Specialties)',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  Text('হাসপাতালের সকল ক্লিনিক্যাল ডিপার্টমেন্ট পরিচালনা (${_specialties.length}টি)',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              FilledButton.icon(
                onPressed: () => _openSpecialtyDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('নতুন বিভাগ যোগ করুন'),
              ),
            ],
          ),
          const SizedBox(height: 20),

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
                      padding: const EdgeInsets.all(8),
                      itemCount: _specialties.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _specialties[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryFixed.withAlpha(80),
                            child: const Icon(Icons.local_hospital, color: AppTheme.primary, size: 20),
                          ),
                          title: Text(item['name_bn']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('ID: ${item['id']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () => _openSpecialtyDialog(item),
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
