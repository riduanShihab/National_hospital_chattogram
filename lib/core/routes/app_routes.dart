import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';
import '../../screens/appointments_screen.dart';
import '../../screens/auth_screens.dart';
import '../../screens/booking_confirmation_screen.dart';
import '../../screens/doctor_list_screen.dart';
import '../../screens/doctor_profile_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/main_navigation_shell.dart';
import '../../screens/patient_profile_screen.dart';
import '../../screens/splash_screen.dart';

typedef BookingScreen = DoctorProfileScreen;

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainNav = '/main-nav';
  static const String home = '/home';
  static const String doctorList = '/doctors';
  static const String doctorProfile = '/doctor-profile';
  static const String booking = '/booking';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String appointments = '/appointments';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case mainNav:
        final index = settings.arguments as int? ?? 0;
        return MaterialPageRoute(builder: (_) => MainNavigationShell(initialIndex: index));
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen(onNavigateTab: (_) {}));
      case doctorList:
        final specialty = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => DoctorListScreen(selectedDepartment: specialty));
      case doctorProfile:
        final doctor = settings.arguments is Doctor
            ? settings.arguments as Doctor
            : Doctor.sampleDoctors.first;
        return MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doctor));
      case booking:
        final doctor = settings.arguments is Doctor
            ? settings.arguments as Doctor
            : Doctor.sampleDoctors.first;
        return MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doctor));
      case bookingConfirmation:
        final appointment = settings.arguments is AppointmentBooking
            ? settings.arguments as AppointmentBooking
            : const AppointmentBooking(
                serialNo: '১২',
                doctorName: 'ডা. তাসবীরুল হাসান জিহান',
                doctorSpecialty: 'গ্যাস্ট্রোলিভার ও মেডিসিন বিশেষজ্ঞ',
                appointmentDate: 'শনিবার, ০৪ অক্টোবর ২০২৬',
                appointmentTime: 'বিকাল ৫:৪০ টা',
                roomNo: '৪০২ নং রুম (৪র্থ তলা)',
                patientName: 'আব্দুল করিম',
                patientPhone: '০১৭১২-৩৪৫৬৭৮',
                fee: 1000,
              );
        return MaterialPageRoute(builder: (_) => BookingConfirmationScreen(booking: appointment));
      case appointments:
        return MaterialPageRoute(builder: (_) => const AppointmentsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const PatientProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const MainNavigationShell());
    }
  }
}
