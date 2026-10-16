import 'package:flutter/material.dart';
import '../models/hospital_models.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'auth_screens.dart';
import 'booking_confirmation_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _selectedDateIndex = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isForSelf = true;

  final List<Map<String, String>> _dates = [
    {'dayName': 'শনি', 'dayNum': '১০', 'month': 'অক্টোবর', 'status': 'উপলব্ধ'},
    {'dayName': 'রবি', 'dayNum': '১১', 'month': 'অক্টোবর', 'status': 'উপলব্ধ'},
    {'dayName': 'সোম', 'dayNum': '১২', 'month': 'অক্টোবর', 'status': 'উপলব্ধ'},
    {'dayName': 'মঙ্গল', 'dayNum': '১৩', 'month': 'অক্টোবর', 'status': 'উপলব্ধ'},
    {'dayName': 'বুধ', 'dayNum': '১৪', 'month': 'অক্টোবর', 'status': 'উপলব্ধ'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (SupabaseService.isAuthenticated) {
      final profile = await SupabaseService.getMyProfile();
      if (profile != null && mounted) {
        setState(() {
          if (profile['full_name'] != null && (profile['full_name'] as String).isNotEmpty) {
            _nameController.text = profile['full_name'];
          }
          if (profile['phone'] != null && (profile['phone'] as String).isNotEmpty) {
            _phoneController.text = profile['phone'];
          }
        });
      }
    }
  }

  void _showLoginRequiredForBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline_rounded, color: AppTheme.error, size: 24),
            ),
            const SizedBox(width: 10),
            const Text(
              'লগইন আবশ্যক',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'ডাক্তারের অ্যাপয়েন্টমেন্ট ও সিরিয়াল বুকিং নিশ্চিত করতে অনুগ্রহ করে প্রথমে আপনার অ্যাকাউন্টে লগইন করুন।',
          style: TextStyle(fontSize: 14, height: 1.4),
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
                if (mounted) _loadUserInfo();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('লগইন / সাইন আপ করুন'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('ডাক্তারের প্রোফাইল'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ডাক্তারের তথ্য শেয়ার লিংক কপি করা হয়েছে')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Doctor Profile Main Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F131B2E),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar with Verified badge
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.surfaceContainerHighest,
                          border: Border.all(color: AppTheme.primaryFixed, width: 3),
                        ),
                        child: ClipOval(
                          child: (doc.displayAvatarUrl.isNotEmpty && doc.displayAvatarUrl.startsWith('http'))
                              ? Image.network(
                                  doc.displayAvatarUrl,
                                  fit: BoxFit.cover,
                                  width: 96,
                                  height: 96,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.person,
                                    size: 54,
                                    color: AppTheme.primary,
                                  ),
                                )
                              : const Icon(Icons.person, size: 54, color: AppTheme.primary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified, size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Doctor Name
                  Text(
                    doc.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Degrees
                  Text(
                    doc.degrees,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Specialty Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryFixed.withAlpha(120),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      doc.specialty,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hospital
                  Text(
                    doc.hospital,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outline,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chamber Schedule Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.calendar_month, color: AppTheme.primary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('রোগী দেখার দিনসমূহ:', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                                  Text(
                                    doc.availableDays.join(', '),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.schedule, color: AppTheme.primary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('চেম্বারের সময়সূচী:', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                                  Text(
                                    doc.chamberTime,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.meeting_room_outlined, color: AppTheme.primary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                doc.roomNo,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              'পরামর্শ ফি: ৳${doc.fee}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date Selection Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'অ্যাপয়েন্টমেন্টের তারিখ নির্বাচন করুন',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Horizontal Date Carousel
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = _dates[index];
                  final isSelected = _selectedDateIndex == index;
                  final isClosed = item['status'] == 'বন্ধ';

                  return GestureDetector(
                    onTap: isClosed
                        ? null
                        : () {
                            setState(() {
                              _selectedDateIndex = index;
                            });
                          },
                    child: Opacity(
                      opacity: isClosed ? 0.45 : 1.0,
                      child: Container(
                        width: 72,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : AppTheme.outlineVariant.withAlpha(80),
                          ),
                          boxShadow: isSelected
                              ? [
                                  const BoxShadow(
                                    color: Color(0x33006096),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['dayName']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white70 : AppTheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['dayNum']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppTheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['month']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Colors.white70 : AppTheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Patient Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'রোগীর তথ্য',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isForSelf = true),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: _isForSelf ? AppTheme.primaryFixed.withAlpha(100) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _isForSelf ? AppTheme.primary : AppTheme.outlineVariant,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isForSelf ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: _isForSelf ? AppTheme.primary : AppTheme.outline,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text('নিজের জন্য', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isForSelf = false),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: !_isForSelf ? AppTheme.primaryFixed.withAlpha(100) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: !_isForSelf ? AppTheme.primary : AppTheme.outlineVariant,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  !_isForSelf ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: !_isForSelf ? AppTheme.primary : AppTheme.outline,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text('অন্যের জন্য', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'রোগীর পূর্ণ নাম',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'মোবাইল নম্বর',
                      prefixIcon: Icon(Icons.phone_android, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Book Button CTA
            ElevatedButton(
              onPressed: () async {
                if (!SupabaseService.isAuthenticated) {
                  _showLoginRequiredForBooking(context);
                  return;
                }

                final navigator = Navigator.of(context);
                final patientName = _nameController.text.trim().isEmpty ? 'আব্দুল করিম' : _nameController.text.trim();
                final patientPhone = _phoneController.text.trim().isEmpty ? '০১৭১২-৩৪৫৬৭৮' : _phoneController.text.trim();
                final selectedDateStr =
                    '${_dates[_selectedDateIndex]['dayName']}, ${_dates[_selectedDateIndex]['dayNum']} ${_dates[_selectedDateIndex]['month']}';

                final booking = await SupabaseService.bookAppointment(
                  doctorId: doc.id,
                  doctorName: doc.name,
                  doctorSpecialty: doc.specialty,
                  roomNo: doc.roomNo,
                  fee: doc.fee,
                  appointmentDate: DateTime.now().add(Duration(days: _selectedDateIndex)),
                  slotTime: '17:40:00',
                  patientName: patientName,
                  patientPhone: patientPhone,
                );

                if (!mounted) return;

                navigator.push(
                  MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                      booking: booking ??
                          AppointmentBooking(
                            serialNo: 'নং ১৫',
                            doctorName: doc.name,
                            doctorSpecialty: doc.specialty,
                            appointmentDate: selectedDateStr,
                            appointmentTime: 'বিকাল ৫:৪০ টা',
                            roomNo: doc.roomNo,
                            patientName: patientName,
                            patientPhone: patientPhone,
                            fee: doc.fee,
                          ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 20),
                  SizedBox(width: 8),
                  Text('সিরিয়াল ও অ্যাপয়েন্টমেন্ট নিশ্চিত করুন', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
