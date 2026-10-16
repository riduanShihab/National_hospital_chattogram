import 'package:flutter/material.dart';
import '../../core/constants/assets.dart';
import '../../core/routes/app_routes.dart';
import '../../services/admin_service.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAdminLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final identifier = _emailController.text.trim();
      final password = _passwordController.text;

      // 1. Authenticate with Supabase
      await SupabaseService.signIn(
        phoneOrEmail: identifier,
        password: password,
      );

      // 2. Verify admin role
      final isAdmin = await AdminService.isCurrentUserAdmin();
      if (!isAdmin) {
        await SupabaseService.signOut();
        if (mounted) {
          setState(() {
            _errorMessage = 'অ্যাক্সেস অনুমোদিত নয়। কেবল অনুমোদিত অ্যাডমিনরা প্রবেশ করতে পারবেন।';
            _isLoading = false;
          });
        }
        return;
      }

      // 3. Navigate to Admin Shell / Dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      }
    } catch (e) {
      if (mounted) {
        final errorText = e.toString();
        setState(() {
          if (errorText.contains('Invalid login credentials') || errorText.contains('invalid_grant')) {
            _errorMessage = 'ভুল মোবাইল/ইমেইল অথবা পাসওয়ার্ড। অনুগ্রহ করে আবার চেষ্টা করুন।';
          } else {
            _errorMessage = 'লগইন ব্যর্থ হয়েছে: $e';
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: isDesktop ? 460 : double.infinity,
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x140F172A),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & Brand Header
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryFixed.withAlpha(80),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.hospitalLogo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.admin_panel_settings_rounded,
                            color: AppTheme.primary,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      'National Hospital',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'হসপিটাল ওয়েব অ্যাডমিন প্যানেল',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFB91C1C),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Email or Phone field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'অ্যাডমিন ইমেইল বা মোবাইল নম্বর',
                      hintText: 'admin@nationalhospital.com বা 01712345678',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'অ্যাডমিন ইমেইল বা মোবাইল নম্বর দিন'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'পাসওয়ার্ড',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'কমপক্ষে ৬ অক্ষরের পাসওয়ার্ড দিন'
                        : null,
                    onFieldSubmitted: (_) => _handleAdminLogin(),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _handleAdminLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'অ্যাডমিন লগইন',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
