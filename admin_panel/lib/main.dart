import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_config.dart';
import 'core/routes/app_routes.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_shell_screen.dart';
import 'services/admin_service.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const NationalHospitalAdminApp());
}

class NationalHospitalAdminApp extends StatelessWidget {
  const NationalHospitalAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'National Hospital — Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AdminAuthWrapper(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

class AdminAuthWrapper extends StatefulWidget {
  const AdminAuthWrapper({super.key});

  @override
  State<AdminAuthWrapper> createState() => _AdminAuthWrapperState();
}

class _AdminAuthWrapperState extends State<AdminAuthWrapper> {
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isAuthed = SupabaseService.isAuthenticated;
    if (!isAuthed) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isAdmin = false;
        });
      }
      return;
    }

    final isAdmin = await AdminService.isCurrentUserAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'অ্যাডমিন পোর্টাল লোড হচ্ছে...',
                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    if (_isAdmin) {
      return const AdminShellScreen();
    }

    return const AdminLoginScreen();
  }
}
