import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';
import '../../services/admin_service.dart';

class AdminAuditLogsScreen extends StatefulWidget {
  const AdminAuditLogsScreen({super.key});

  @override
  State<AdminAuditLogsScreen> createState() => _AdminAuditLogsScreenState();
}

class _AdminAuditLogsScreenState extends State<AdminAuditLogsScreen> {
  List<AdminAuditLog> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final list = await AdminService.getAuditLogs();
      if (mounted) {
        setState(() {
          _logs = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('অ্যাডমিন অডিট লগ (Audit Logs)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  SizedBox(height: 4),
                  Text('প্রশাসনিক কার্যক্রম, পরিবর্তন ও রেকর্ড ট্র্যাকিং',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _loadLogs),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _logs.isEmpty
                    ? const Center(
                        child: Text(
                          'এখনও কোনো অডিট লগ রেকর্ড নেই।',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      )
                    : Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        child: ListView.separated(
                          itemCount: _logs.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final log = _logs[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFF1F5F9),
                                child: Icon(Icons.history, color: Color(0xFF475569), size: 20),
                              ),
                              title: Text(log.action, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Entity: ${log.entityType} • ID: ${log.entityId ?? "-"} • ${log.createdAt.toLocal()}'),
                              trailing: log.metadata != null
                                  ? Text('${log.metadata}', style: const TextStyle(fontSize: 11, color: Colors.grey))
                                  : null,
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
