import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_config.dart';
import 'core/routes/app_routes.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const NationalHospitalApp());
}

class NationalHospitalApp extends StatelessWidget {
  const NationalHospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'National Hospital',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
