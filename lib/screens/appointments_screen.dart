import 'package:flutter/material.dart';
import '../models/hospital_models.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'auth_screens.dart';
import 'booking_confirmation_screen.dart';
import 'doctor_list_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<AppointmentBooking> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);
    try {
      final list = await SupabaseService.getMyAppointments();
      if (mounted) {
        setState(() {
          _appointments = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('আমার অ্যাপয়েন্টমেন্টসমূহ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointments,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : _appointments.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _appointments.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final booking = _appointments[index];
                    return _buildAppointmentCard(context, booking);
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isLoggedIn = SupabaseService.isAuthenticated;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLoggedIn ? Icons.event_busy_rounded : Icons.lock_clock_rounded,
                size: 40,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isLoggedIn ? 'কোনো বুকিং পাওয়া যায়নি' : 'লগইন প্রয়োজন',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              isLoggedIn
                  ? 'আপনার কোনো পূর্ববর্তী বা বর্তমান ডাক্তারের অ্যাপয়েন্টমেন্ট তালিকাভুক্ত নেই।'
                  : 'আপনার বুকিং ও অ্যাপয়েন্টমেন্ট হিস্ট্রি দেখতে অনুগ্রহ করে অ্যাকাউন্টে লগইন করুন।',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            if (!isLoggedIn)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ).then((_) => _loadAppointments());
                },
                icon: const Icon(Icons.login_rounded),
                label: const Text('লগইন / সাইন আপ করুন'),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DoctorListScreen()),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('ডাক্তার খুঁজুন ও সিরিয়াল দিন'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, AppointmentBooking booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryFixedDim),
        boxShadow: const [
          BoxShadow(color: Color(0x0A006096), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.tertiaryContainer.withAlpha(40),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: AppTheme.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      booking.status,
                      style: const TextStyle(
                        color: AppTheme.tertiary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'সিরিয়াল: ${booking.serialNo}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            booking.doctorName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            booking.doctorSpecialty,
            style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(booking.appointmentDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const Spacer(),
              const Icon(Icons.access_time, size: 14, color: AppTheme.primary),
              const SizedBox(width: 4),
              Text(booking.appointmentTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(booking: booking),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('রসিদ দেখুন'),
            ),
          ),
        ],
      ),
    );
  }
}
