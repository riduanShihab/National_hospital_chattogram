import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/assets.dart';
import '../core/constants/strings_bn.dart';
import '../theme/app_theme.dart';
import 'main_navigation_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _animController.forward();

    // 4-second splash screen duration as requested
    _navigationTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationShell(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Subtle background decorative circles
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryFixed.withAlpha(40),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.tertiaryContainer.withAlpha(30),
              ),
            ),
          ),

          // Center Branding Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hospital App Icon Logo
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppTheme.primaryFixed.withAlpha(120), width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x18006096),
                            blurRadius: 24,
                            spreadRadius: 2,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          AppAssets.hospitalLogo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.local_hospital_rounded, size: 54, color: AppTheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Primary App Name: National Hospital
                    const Text(
                      'National Hospital',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Bengali Subtitle
                    Text(
                      StringsBn.hospitalSubTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Tagline
                    Text(
                      StringsBn.tagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant.withAlpha(180),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Elegant Loading Indicator
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.8,
                        color: AppTheme.primary,
                        backgroundColor: AppTheme.primaryFixed.withAlpha(80),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Footer
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const Center(
                child: Text(
                  'ন্যাশনাল হাসপাতাল চট্টগ্রাম • v1.0.0',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.2,
                    color: AppTheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
