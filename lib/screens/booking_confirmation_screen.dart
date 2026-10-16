import 'package:flutter/material.dart';
import '../core/constants/assets.dart';
import '../models/hospital_models.dart';
import '../theme/app_theme.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final AppointmentBooking booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('বুকিং নিশ্চিতকরণ'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Success Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.tertiaryContainer.withAlpha(80)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A006A42),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.tertiaryContainer.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppTheme.tertiary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'অ্যাপয়েন্টমেন্ট সফলভাবে বুক হয়েছে!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'আপনার সিরিয়াল ও ভিজিট নিশ্চিত করা হয়েছে',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Digital Receipt Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12131B2E),
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Receipt Header
                  Container(
                    color: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  AppAssets.hospitalLogo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.local_hospital_rounded, color: AppTheme.primary, size: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'ন্যাশনাল হাসপাতাল চট্টগ্রাম',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'ডিজিটাল রসিদ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Serial & QR Box
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'আপনার সিরিয়াল নম্বর',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'নং ${booking.serialNo}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 14, color: AppTheme.tertiary),
                                      const SizedBox(width: 4),
                                      Text(
                                        'অনুমিত সময়: ${booking.appointmentTime}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.tertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // QR Code Placeholder representation
                              Container(
                                width: 72,
                                height: 72,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.outlineVariant.withAlpha(100)),
                                ),
                                child: const Icon(Icons.qr_code_2_rounded, size: 58, color: AppTheme.onSurface),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Detail Rows
                        _buildDetailRow('ডাক্তারের নাম:', booking.doctorName, isBold: true),
                        const Divider(height: 16),
                        _buildDetailRow('বিভাগ ও পদবী:', booking.doctorSpecialty),
                        const Divider(height: 16),
                        _buildDetailRow('তারিখ ও বার:', booking.appointmentDate),
                        const Divider(height: 16),
                        _buildDetailRow('চেম্বার রুম:', booking.roomNo),
                        const Divider(height: 16),
                        _buildDetailRow('রোগীর নাম:', booking.patientName),
                        const Divider(height: 16),
                        _buildDetailRow('মোবাইল নম্বর:', booking.patientPhone),
                        const Divider(height: 16),
                        _buildDetailRow(
                          'পরামর্শ ফি:',
                          '৳${booking.fee} (হাসপাতালে প্রদেয়)',
                          valueColor: AppTheme.tertiary,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Important Instructions Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryFixed.withAlpha(60),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryFixedDim),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'দয়া করে নির্ধারিত সময়ের অন্তত ১৫ মিনিট পূর্বে হাসপাতালের কাউন্টারে এই ডিজিটাল রসিদটি প্রদর্শন করুন।',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('রসিদটি গ্যালারিতে সেভ করা হয়েছে')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('ডাউনলোড'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home_rounded, size: 18),
                    label: const Text('হোমে ফিরুন'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? AppTheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
