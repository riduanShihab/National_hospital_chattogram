import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';
import '../../services/admin_service.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const AdminDashboardScreen({super.key, required this.onNavigateTab});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AdminDashboardStats? _stats;
  List<FeaturedDoctor> _topDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        AdminService.getDashboardStats(),
        AdminService.getAllFeaturedDoctorsAdmin(),
      ]);
      if (mounted) {
        setState(() {
          _stats = results[0] as AdminDashboardStats;
          _topDoctors = results[1] as List<FeaturedDoctor>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final stats = _stats ??
        const AdminDashboardStats(
          totalDoctors: 0,
          activeDoctors: 0,
          featuredDoctors: 0,
          totalAppointments: 0,
          todayAppointments: 0,
          totalSpecialties: 0,
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Refresh Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'অ্যাডমিন ড্যাশবোর্ড (Dashboard)',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ন্যাশনাল হাসপাতাল চট্টগ্রাম - প্রশাসনিক নিয়ন্ত্রণ কক্ষ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: _loadDashboardData,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('রিফ্রেশ'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100
                  ? 4
                  : constraints.maxWidth > 650
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.1,
                children: [
                  _buildStatCard(
                    title: 'মোট ডাক্তার',
                    value: '${stats.totalDoctors} জন',
                    subtitle: 'সক্রিয়: ${stats.activeDoctors} জন',
                    icon: Icons.medical_services_rounded,
                    color: const Color(0xFF0284C7),
                    bgColor: const Color(0xFFE0F2FE),
                    onTap: () => widget.onNavigateTab(2), // Doctors Tab
                  ),
                  _buildStatCard(
                    title: 'টপ / সেরা ডাক্তার',
                    value: '${stats.featuredDoctors} জন',
                    subtitle: 'হোমে অগ্রাধিকার প্রাপ্ত',
                    icon: Icons.stars_rounded,
                    color: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFEF3C7),
                    onTap: () => widget.onNavigateTab(1), // Top Doctors Tab
                  ),
                  _buildStatCard(
                    title: 'আজকের অ্যাপয়েন্টমেন্ট',
                    value: '${stats.todayAppointments} টি',
                    subtitle: 'মোট বুকিং: ${stats.totalAppointments} টি',
                    icon: Icons.calendar_today_rounded,
                    color: const Color(0xFF16A34A),
                    bgColor: const Color(0xFFDCFCE7),
                    onTap: () => widget.onNavigateTab(5), // Appointments Tab
                  ),
                  _buildStatCard(
                    title: 'বিশেষজ্ঞ বিভাগসমূহ',
                    value: '${stats.totalSpecialties} টি',
                    subtitle: 'ক্লিনিক্যাল ডিপার্টমেন্টস',
                    icon: Icons.category_rounded,
                    color: const Color(0xFF7C3AED),
                    bgColor: const Color(0xFFEDE9FE),
                    onTap: () => widget.onNavigateTab(3), // Specialties Tab
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // Quick Management Actions Row
          const Text(
            'দ্রুত কার্যক্রম (Quick Actions)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionChip(
                label: 'টপ ডাক্তার ব্যবস্থাপনা',
                icon: Icons.star_rate_rounded,
                color: const Color(0xFFD97706),
                onTap: () => widget.onNavigateTab(1),
              ),
              _buildActionChip(
                label: 'সকল ডাক্তার ডিরেক্টরি',
                icon: Icons.people_outline,
                color: AppTheme.primary,
                onTap: () => widget.onNavigateTab(2),
              ),
              _buildActionChip(
                label: 'বিভাগ / স্পেশালটি সমূহ',
                icon: Icons.view_list_rounded,
                color: const Color(0xFF7C3AED),
                onTap: () => widget.onNavigateTab(3),
              ),
              _buildActionChip(
                label: 'ডাক্তারদের সময়সূচী',
                icon: Icons.schedule_rounded,
                color: const Color(0xFF0D9488),
                onTap: () => widget.onNavigateTab(4),
              ),
              _buildActionChip(
                label: 'অ্যাপয়েন্টমেন্ট ট্র্যাকার',
                icon: Icons.event_available_rounded,
                color: const Color(0xFF16A34A),
                onTap: () => widget.onNavigateTab(5),
              ),
              _buildActionChip(
                label: 'অডিট লগ্স',
                icon: Icons.history_rounded,
                color: const Color(0xFF475569),
                onTap: () => widget.onNavigateTab(6),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Featured Top Doctors Snapshot
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'বর্তমান সেরা ডাক্তারবৃন্দ (Live Top Doctors)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => widget.onNavigateTab(1),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('সম্পূর্ণ ব্যবস্থাপনা'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_topDoctors.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'বর্তমানে কোনো সেরা ডাক্তার যুক্ত করা নেই। টপ ডাক্তার ট্যাবে গিয়ে যুক্ত করুন।',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _topDoctors.take(5).length,
                      separatorBuilder: (context, index) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final item = _topDoctors[index];
                        final doc = item.doctor;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.tertiaryFixed,
                            child: Text(
                              '#${item.displayOrder}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.tertiary),
                            ),
                          ),
                          title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${doc.specialty} • ${item.title ?? "সিনিয়র কনসালট্যান্ট"}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.isActive ? 'সক্রিয়' : 'নিষ্ক্রিয়',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: item.isActive ? const Color(0xFF15803D) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x060F172A),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      onPressed: onTap,
    );
  }
}
