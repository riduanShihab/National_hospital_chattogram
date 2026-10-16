import 'package:flutter/material.dart';
import '../../core/constants/assets.dart';
import '../../core/routes/app_routes.dart';
import '../../services/admin_service.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import 'admin_appointments_screen.dart';
import 'admin_audit_logs_screen.dart';
import 'admin_dashboard_screen.dart';
import 'admin_doctors_screen.dart';
import 'admin_schedules_screen.dart';
import 'admin_specialties_screen.dart';
import 'admin_top_doctors_screen.dart';

class AdminShellScreen extends StatefulWidget {
  final int initialTab;

  const AdminShellScreen({super.key, this.initialTab = 0});

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  late int _selectedTab;
  bool _isCheckingRole = true;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _verifyAccess();
  }

  Future<void> _verifyAccess() async {
    setState(() => _isCheckingRole = true);
    final isAuthed = SupabaseService.isAuthenticated;
    if (!isAuthed) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminLogin);
      }
      return;
    }

    final isAdmin = await AdminService.isCurrentUserAdmin();
    if (mounted) {
      if (!isAdmin) {
        await SupabaseService.signOut();
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.adminLogin);
        }
        return;
      }
      setState(() {
        _isAuthorized = true;
        _isCheckingRole = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    await SupabaseService.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.adminLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingRole) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'অ্যাডমিন পারমিশন যাচাই করা হচ্ছে...',
                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isAuthorized) {
      return const Scaffold(
        body: Center(child: Text('অ্যাক্সেস অনুমোদিত নয়')),
      );
    }

    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final user = SupabaseService.currentUser;
    final userEmail = user?.email ?? user?.userMetadata?['phone'] ?? 'Admin';

    final navItems = [
      _NavItem(title: 'ড্যাশবোর্ড', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard),
      _NavItem(title: 'টপ / সেরা ডাক্তার', icon: Icons.stars_outlined, activeIcon: Icons.stars_rounded, badge: 'Hero'),
      _NavItem(title: 'ডাক্তার ডিরেক্টরি', icon: Icons.medical_services_outlined, activeIcon: Icons.medical_services),
      _NavItem(title: 'বিভাগসমূহ', icon: Icons.category_outlined, activeIcon: Icons.category),
      _NavItem(title: 'চেম্বার শিডিউল', icon: Icons.schedule_outlined, activeIcon: Icons.schedule),
      _NavItem(title: 'অ্যাপয়েন্টমেন্ট', icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today),
      _NavItem(title: 'অডিট লগ্স', icon: Icons.history_outlined, activeIcon: Icons.history),
    ];

    Widget currentScreen;
    switch (_selectedTab) {
      case 0:
        currentScreen = AdminDashboardScreen(onNavigateTab: (tab) => setState(() => _selectedTab = tab));
        break;
      case 1:
        currentScreen = const AdminTopDoctorsScreen();
        break;
      case 2:
        currentScreen = const AdminDoctorsScreen();
        break;
      case 3:
        currentScreen = const AdminSpecialtiesScreen();
        break;
      case 4:
        currentScreen = const AdminSchedulesScreen();
        break;
      case 5:
        currentScreen = const AdminAppointmentsScreen();
        break;
      case 6:
        currentScreen = const AdminAuditLogsScreen();
        break;
      default:
        currentScreen = AdminDashboardScreen(onNavigateTab: (tab) => setState(() => _selectedTab = tab));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: isDesktop ? 24 : 12,
        leading: isDesktop
            ? null
            : Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryFixed, width: 1.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  AppAssets.hospitalLogo,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_hospital, color: AppTheme.primary, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'National Hospital Chattogram',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Web Administration Portal',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary.withAlpha(220),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings, size: 16, color: AppTheme.primary),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    userEmail,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'লগআউট',
            icon: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 20),
            onPressed: _handleLogout,
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: _buildSidebarContent(navItems),
            ),
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 260,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: _buildSidebarContent(navItems),
            ),
          Expanded(child: currentScreen),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(List<_NavItem> navItems) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: navItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final item = navItems[index];
              final isSelected = _selectedTab == index;

              return InkWell(
                onTap: () {
                  setState(() => _selectedTab = index);
                  if (Navigator.canPop(context) && MediaQuery.of(context).size.width < 900) {
                    Navigator.pop(context); // Close mobile drawer
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryFixed.withAlpha(120) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: 20,
                        color: isSelected ? AppTheme.primary : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppTheme.primary : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      if (item.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.badge!,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Postgres RLS Protected',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                'v1.0.0',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String? badge;

  _NavItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    this.badge,
  });
}
