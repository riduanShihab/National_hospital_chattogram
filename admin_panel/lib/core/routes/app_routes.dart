import 'package:flutter/material.dart';
import '../../screens/admin_login_screen.dart';
import '../../screens/admin_shell_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String topDoctors = '/top-doctors';
  static const String doctors = '/doctors';
  static const String specialties = '/specialties';
  static const String schedules = '/schedules';
  static const String appointments = '/appointments';
  static const String auditLogs = '/audit-logs';

  // Backwards compatibility with unified route names
  static const String adminLogin = '/login';
  static const String adminDashboard = '/dashboard';
  static const String adminTopDoctors = '/top-doctors';
  static const String mainNav = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const AdminShellScreen(initialTab: 0));
      case topDoctors:
        return MaterialPageRoute(builder: (_) => const AdminShellScreen(initialTab: 1));
      case doctors:
        return MaterialPageRoute(builder: (_) => const AdminShellScreen(initialTab: 2));
      case specialties:
        return MaterialPageRoute(builder: (_) => const AdminShellScreen(initialTab: 3));
      case schedules:
        return MaterialPageRoute(builder: (_) => const AdminShellScreen(initialTab: 4));
      case appointments:
        return MaterialPageRoute(builder: (_) => const AdminShellScreen(initialTab: 5));
      case auditLogs:
        return MaterialPageRoute(builder: (_) => const AdminShellScreen(initialTab: 6));
      default:
        return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
    }
  }
}
