import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'auth_screens.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _isLoggedIn = false;
  String _name = 'অতিথি ব্যবহারকারী';
  String _phone = 'লগইন করা নেই';
  final String _bloodGroup = 'B+ (পজিটিভ)';
  String _age = '-- বছর';
  String _address = 'চট্টগ্রাম';
  String _patientId = 'NH-গেস্ট';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final loggedIn = SupabaseService.isAuthenticated;
    if (!loggedIn) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _name = 'অতিথি ব্যবহারকারী';
          _phone = 'লগইন করা নেই';
          _patientId = 'অতিথি';
        });
      }
      return;
    }

    final profile = await SupabaseService.getMyProfile();
    if (mounted) {
      setState(() {
        _isLoggedIn = true;
        if (profile != null) {
          if (profile['full_name'] != null && (profile['full_name'] as String).isNotEmpty) {
            _name = profile['full_name'];
          }
          if (profile['phone'] != null && (profile['phone'] as String).isNotEmpty) {
            _phone = profile['phone'];
          }
          if (profile['age'] != null) {
            _age = '${profile['age']} বছর';
          }
        } else {
          final user = SupabaseService.currentUser;
          _name = user?.userMetadata?['full_name'] ?? 'নিবন্ধিত রোগী';
          _phone = user?.userMetadata?['phone'] ?? user?.email ?? '---';
        }
        _patientId = 'NH-${(SupabaseService.currentUser?.id.substring(0, 5) ?? "89752").toUpperCase()}';
      });
    }
  }

  void _showLoginRequiredPopup(BuildContext context, {String? customMessage}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryFixed.withAlpha(120),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_person_rounded, color: AppTheme.primary, size: 24),
            ),
            const SizedBox(width: 10),
            const Text(
              'লগইন প্রয়োজন',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          customMessage ??
              'অনুগ্রহ করে লগইন করুন। এই প্রোফাইল অপশন বা তথ্য অ্যাক্সেস করতে আপনার অ্যাকাউন্টে লগইন থাকা প্রয়োজন।',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('বাতিল', style: TextStyle(color: AppTheme.outline)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ).then((_) {
                if (mounted) _loadProfile();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('লগইন করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('আমার প্রোফাইল'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfileDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              if (!_isLoggedIn) {
                _showLoginRequiredPopup(
                  context,
                  customMessage: 'অ্যাকাউন্ট সেটিংস দেখতে অনুগ্রহ করে লগইন করুন।',
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('অ্যাকাউন্ট সেটিংস সুরক্ষিত ও সক্রিয় আছে')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Guest Login Alert Banner
            if (!_isLoggedIn)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.secondary.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppTheme.secondary, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'আপনি লগইন করেননি',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppTheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'প্রেসক্রিপশন ও রিপোর্ট দেখতে অনুগ্রহ করে লগইন করুন।',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.onSecondaryContainer.withAlpha(200),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        ).then((_) => _loadProfile());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: const Text('লগইন'),
                    ),
                  ],
                ),
              ),

            // Patient ID Card Widget
            InkWell(
              onTap: () {
                if (!_isLoggedIn) {
                  _showLoginRequiredPopup(context);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x28006096),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            _isLoggedIn ? Icons.person : Icons.person_outline,
                            size: 40,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'রোগী আইডি: $_patientId',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCardStat('রক্তের গ্রুপ', _bloodGroup),
                        _buildCardStat('বয়স', _age),
                        _buildCardStat('স্ট্যাটাস', _isLoggedIn ? 'সক্রিয়' : 'অতিথি'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Personal Information Section
            InkWell(
              onTap: () {
                if (!_isLoggedIn) {
                  _showLoginRequiredPopup(context);
                } else {
                  _showEditProfileDialog(context);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: _buildSectionCard(
                title: 'ব্যক্তিগত তথ্য',
                children: [
                  _buildInfoTile(Icons.phone_outlined, 'মোবাইল নম্বর', _phone),
                  const Divider(height: 1),
                  _buildInfoTile(Icons.bloodtype_outlined, 'রক্তের গ্রুপ', _bloodGroup),
                  const Divider(height: 1),
                  _buildInfoTile(Icons.calendar_today_outlined, 'বয়স', _age),
                  const Divider(height: 1),
                  _buildInfoTile(Icons.location_on_outlined, 'ঠিকানা', _address),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recent Prescriptions & Reports
            _buildSectionCard(
              title: 'সাম্প্রতিক সেবা ও হিস্ট্রি',
              children: [
                _buildActionTile(
                  icon: Icons.receipt_long,
                  iconBg: AppTheme.primaryFixed,
                  iconColor: AppTheme.primary,
                  title: 'ল্যাব টেস্ট রিপোর্ট - সিগমা ল্যাব',
                  subtitle: 'তারিখ: ২৮ সেপ্টেম্বর, ২০২৬',
                  onTap: () {
                    if (!_isLoggedIn) {
                      _showLoginRequiredPopup(
                        context,
                        customMessage: 'আপনার ল্যাব টেস্ট রিপোর্ট দেখতে অনুগ্রহ করে লগইন করুন।',
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('আপনার কোনো নতুন ল্যাব টেস্ট রিপোর্ট জমা নেই।')),
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                _buildActionTile(
                  icon: Icons.medical_services_outlined,
                  iconBg: AppTheme.tertiaryFixed,
                  iconColor: AppTheme.tertiary,
                  title: 'ডাক্তার কনসালটেশন রসিদ',
                  subtitle: 'ডা. তাসবীরুল হাসান জিহান',
                  onTap: () {
                    if (!_isLoggedIn) {
                      _showLoginRequiredPopup(
                        context,
                        customMessage: 'আপনার ডাক্তার কনসালটেশন রসিদ দেখতে অনুগ্রহ করে লগইন করুন।',
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('আপনার কোনো সক্রিয় কনসালটেশন রসিদ জমা নেই।')),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Emergency & Support
            _buildSectionCard(
              title: 'জরুরি সহায়তা ও হেল্পলাইন',
              children: [
                _buildActionTile(
                  icon: Icons.phone_in_talk,
                  iconBg: AppTheme.errorContainer,
                  iconColor: AppTheme.error,
                  title: 'হাসপাতাল ২৪/৭ হটলাইন',
                  subtitle: '০৯৬৪৮-২৫০২৫০',
                  trailing: const Icon(Icons.call, color: AppTheme.primary),
                  onTap: () {},
                ),
              ],
            ),


            if (_isLoggedIn) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
                  label: const Text(
                    'অ্যাকাউন্ট থেকে লগআউট করুন',
                    style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await SupabaseService.signOut();
                    if (mounted) {
                      _loadProfile();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('সফলভাবে লগআউট হয়েছে')),
                      );
                    }
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withAlpha(50)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconBg,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.outline),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    if (!_isLoggedIn) {
      _showLoginRequiredPopup(
        context,
        customMessage: 'প্রোফাইল তথ্য দেখতে বা পরিবর্তন করতে অনুগ্রহ করে প্রথমে লগইন করুন।',
      );
      return;
    }

    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    final addressCtrl = TextEditingController(text: _address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('প্রোফাইল সম্পাদনা করুন', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'রোগীর নাম'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'মোবাইল নম্বর'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: 'ঠিকানা'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = nameCtrl.text.trim();
                final newPhone = phoneCtrl.text.trim();
                setState(() {
                  _name = newName;
                  _phone = newPhone;
                  _address = addressCtrl.text.trim();
                });
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                await SupabaseService.updateProfile(
                  fullName: newName,
                  phone: newPhone,
                );
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('তথ্য সফলভাবে সংরক্ষিত হয়েছে!')),
                  );
                }
              },
              child: const Text('সংরক্ষণ করুন'),
            ),
          ],
        );
      },
    );
  }
}

typedef ProfileScreen = PatientProfileScreen;
