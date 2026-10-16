import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:national_hospital_chattogram/core/constants/strings_bn.dart';
import 'package:national_hospital_chattogram/core/routes/app_routes.dart';
import 'package:national_hospital_chattogram/models/hospital_models.dart';
import 'package:national_hospital_chattogram/screens/auth_screens.dart';
import 'package:national_hospital_chattogram/screens/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('SplashScreen displays National Hospital and logo', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    await tester.pump();
    expect(find.text('National Hospital'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('LoginScreen and RegisterScreen load and render properly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump();
    expect(find.text(StringsBn.loginButton), findsWidgets);
    expect(find.text('মোবাইল নম্বর অথবা ইমেইল'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.pump();
    expect(find.text(StringsBn.registerTitle), findsWidgets);
    expect(find.text('ইমেইল ঠিকানা (ঐচ্ছিক)'), findsOneWidget);
  });

  test('AppRoutes generates patient routes without errors', () {
    final routes = [
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.mainNav,
      AppRoutes.home,
      AppRoutes.doctorList,
      AppRoutes.doctorProfile,
      AppRoutes.booking,
      AppRoutes.bookingConfirmation,
      AppRoutes.appointments,
      AppRoutes.profile,
    ];

    for (final routeName in routes) {
      final route = AppRoutes.onGenerateRoute(RouteSettings(name: routeName));
      expect(route, isNotNull);
    }
  });

  test('FeaturedDoctor model computes visibility and ordering correctly', () {
    final doc = Doctor.sampleDoctors.first;
    final featured = FeaturedDoctor(
      id: 'feat_1',
      doctorId: doc.id,
      title: 'সিনিয়র কনসালট্যান্ট',
      displayOrder: 1,
      isActive: true,
      doctor: doc,
    );

    expect(featured.displayOrder, 1);
    expect(featured.isCurrentlyVisible, isTrue);

    // Test expired top doctor
    final expiredFeatured = FeaturedDoctor(
      id: 'feat_2',
      doctorId: doc.id,
      displayOrder: 2,
      isActive: true,
      endsAt: DateTime.now().subtract(const Duration(days: 1)),
      doctor: doc,
    );
    expect(expiredFeatured.isCurrentlyVisible, isFalse);

    // Test inactive top doctor
    final inactiveFeatured = FeaturedDoctor(
      id: 'feat_3',
      doctorId: doc.id,
      displayOrder: 3,
      isActive: false,
      doctor: doc,
    );
    expect(inactiveFeatured.isCurrentlyVisible, isFalse);
  });
}
