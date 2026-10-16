import 'package:flutter/material.dart';
import '../core/constants/assets.dart';
import '../core/constants/strings_bn.dart';
import '../core/utils/validators.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'main_navigation_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: '01712345678');
  final _passwordController = TextEditingController(text: '123456');
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await SupabaseService.signIn(
        phoneOrEmail: _identifierController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('সফলভাবে লগইন হয়েছে!'),
            backgroundColor: AppTheme.tertiary,
          ),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationShell()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString().replaceAll('AuthException: ', '');
        if (errorMsg.contains('Invalid login credentials') || errorMsg.contains('invalid_credentials')) {
          errorMsg = 'মোবাইল নম্বর/ইমেইল অথবা পাসওয়ার্ড সঠিক নয়';
        } else if (errorMsg.contains('Email not confirmed')) {
          errorMsg = 'অ্যাকাউন্ট ভেরিফিকেশন বাকি রয়েছে অথবা পাসওয়ার্ড সঠিক নয়';
        } else if (errorMsg.contains('rate limit')) {
          errorMsg = 'অতিরিক্ত চেষ্টার কারণে সাময়িক স্থগিত। কিছুক্ষণ পর চেষ্টা করুন।';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('লগইন ব্যর্থ হয়েছে: $errorMsg'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text(StringsBn.loginTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryFixed, width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Color(0x10006096), blurRadius: 8, offset: Offset(0, 3)),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        AppAssets.hospitalLogo,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.local_hospital_rounded, size: 36, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                StringsBn.loginTitle,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              const SizedBox(height: 6),
              const Text(
                'মোবাইল নম্বর অথবা ইমেইল এবং পাসওয়ার্ড দিয়ে প্রবেশ করুন',
                style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _identifierController,
                keyboardType: TextInputType.text,
                validator: Validators.validatePhoneOrEmail,
                decoration: const InputDecoration(
                  labelText: 'মোবাইল নম্বর অথবা ইমেইল',
                  hintText: 'যেমন: 01712345678',
                  prefixIcon: Icon(Icons.account_circle_outlined, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড',
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppTheme.outline,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(StringsBn.loginButton),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('${StringsBn.doNotHaveAccount}${StringsBn.registerTitle}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await SupabaseService.signUp(
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('অ্যাকাউন্ট সফলভাবে তৈরি হয়েছে!'),
            backgroundColor: AppTheme.tertiary,
          ),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationShell()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString().replaceAll('AuthException: ', '').replaceAll('PostgrestException: ', '');
        if (errorMsg.contains('ইতিমধ্যে একটি অ্যাকাউন্ট রয়েছে')) {
          errorMsg = 'এই মোবাইল নম্বরটি দিয়ে ইতিমধ্যে একটি অ্যাকাউন্ট রয়েছে। লগইন করুন।';
        } else if (errorMsg.contains('over_email_send_rate_limit') || errorMsg.contains('rate limit')) {
          errorMsg = 'সিস্টেম রেট লিমিট অতিক্রম হয়েছে। দয়া করে ডাটাবেজ আপডেট স্ক্রিপ্টটি চালান অথবা কিছুক্ষণ পর চেষ্টা করুন।';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('নিবন্ধন ব্যর্থ হয়েছে: $errorMsg'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text(StringsBn.registerTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryFixed, width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Color(0x10006096), blurRadius: 8, offset: Offset(0, 3)),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        AppAssets.hospitalLogo,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.local_hospital_rounded, size: 36, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                StringsBn.registerTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              const SizedBox(height: 6),
              const Text(
                'শুধুমাত্র মোবাইল নম্বর দিয়ে অ্যাকাউন্ট তৈরি করুন (ইমেইল ঐচ্ছিক)',
                style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _nameController,
                validator: (v) => Validators.validateRequired(v, StringsBn.patientName),
                decoration: const InputDecoration(
                  labelText: StringsBn.patientName,
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                decoration: const InputDecoration(
                  labelText: StringsBn.patientPhone,
                  hintText: 'যেমন: 01712345678',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateOptionalEmail,
                decoration: const InputDecoration(
                  labelText: 'ইমেইল ঠিকানা (ঐচ্ছিক)',
                  hintText: 'ইমেইল বাধ্যতামূলক নয়',
                  prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড (কমপক্ষে ৬ অক্ষর)',
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppTheme.outline,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(StringsBn.registerButton),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('${StringsBn.alreadyHaveAccount}${StringsBn.loginButton}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
