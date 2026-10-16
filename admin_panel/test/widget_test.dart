import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_panel/core/routes/app_routes.dart';
import 'package:admin_panel/screens/admin_login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('AdminLoginScreen renders with hospital admin branding', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminLoginScreen()));
    await tester.pump();

    expect(find.text('National Hospital'), findsOneWidget);
    expect(find.text('হসপিটাল ওয়েব অ্যাডমিন প্যানেল'), findsOneWidget);
    expect(find.text('অ্যাডমিন লগইন'), findsOneWidget);
    expect(find.text('অ্যাডমিন ইমেইল বা মোবাইল নম্বর'), findsOneWidget);
    expect(find.text('পাসওয়ার্ড'), findsOneWidget);
  });

  test('admin_panel AppRoutes generates routes cleanly', () {
    final routes = [
      AppRoutes.login,
      AppRoutes.dashboard,
      AppRoutes.topDoctors,
      AppRoutes.doctors,
      AppRoutes.specialties,
      AppRoutes.schedules,
      AppRoutes.appointments,
      AppRoutes.auditLogs,
    ];

    for (final routeName in routes) {
      final route = AppRoutes.onGenerateRoute(RouteSettings(name: routeName));
      expect(route, isNotNull);
    }
  });
}
