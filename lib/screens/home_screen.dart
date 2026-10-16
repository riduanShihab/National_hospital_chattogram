import 'package:flutter/material.dart';
import '../core/constants/assets.dart';
import '../models/hospital_models.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'doctor_list_screen.dart';
import 'doctor_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Doctor> _doctors = [];
  List<FeaturedDoctor> _featuredDoctors = [];
  List<Map<String, dynamic>> _departments = [];
  bool _isLoadingDoctors = true;
  bool _showAllDepartments = false;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      final results = await Future.wait([
        SupabaseService.getDoctors(),
        SupabaseService.getSpecialties(),
        SupabaseService.getFeaturedDoctors(),
      ]);
      final docs = results[0] as List<Doctor>;
      final specs = results[1] as List<Map<String, dynamic>>;
      final featured = results[2] as List<FeaturedDoctor>;
      if (mounted) {
        setState(() {
          _doctors = docs;
          _departments = specs;
          _featuredDoctors = featured;
          _isLoadingDoctors = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _doctors = Doctor.sampleDoctors;
          _featuredDoctors = [];
          _isLoadingDoctors = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryFixed, width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Color(0x10006096), blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  AppAssets.hospitalLogo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_hospital_rounded, color: AppTheme.primary, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ন্যাশনাল হাসপাতাল চট্টগ্রাম',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'এন্ড সিগমা ল্যাব লিঃ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.phone_in_talk_rounded, color: AppTheme.error, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.errorContainer,
              ),
              onPressed: () {
                _showHotlineDialog(context);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => widget.onNavigateTab(3),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.surfaceContainerHighest,
                child: Icon(Icons.person, color: AppTheme.primary),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorListScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.outlineVariant.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppTheme.primary, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ডাক্তার, বিভাগ বা সেবা খুঁজুন...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    const Icon(Icons.tune, color: AppTheme.outline, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hospital Banner & Hotline Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33006096),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Color(0x20000000), blurRadius: 6, offset: Offset(0, 2)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            AppAssets.hospitalLogo,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.local_hospital_rounded, color: AppTheme.primary, size: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ন্যাশনাল হাসপাতাল চট্টগ্রাম',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'বিশ্বস্ত স্বাস্থ্যসেবা ও আধুনিক ডায়াগনস্টিক',
                              style: TextStyle(
                                color: Colors.white.withAlpha(220),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _showHotlineDialog(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_in_talk_rounded, color: AppTheme.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'হটলাইন: ০৯৬৪৮-২৫০২৫০',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Top / Hero Doctors Section
            _buildTopDoctorsSection(context),

            // Specialty Departments Grid Header
            Builder(
              builder: (context) {
                final List<String> deptNames = _departments.isNotEmpty
                    ? _departments.map((d) => d['name_bn']?.toString() ?? '').where((s) => s.isNotEmpty).toList()
                    : Department.list.map((d) => d.name).toList();

                final int displayCount = _showAllDepartments ? deptNames.length : (deptNames.length > 8 ? 8 : deptNames.length);
                final List<String> itemsToShow = deptNames.take(displayCount).toList();

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'বিশেষজ্ঞ বিভাগসমূহ (${deptNames.length}টি)',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showAllDepartments = !_showAllDepartments;
                            });
                          },
                          child: Text(
                            _showAllDepartments ? 'কম দেখুন' : 'সবগুলো দেখুন',
                            style: const TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemsToShow.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.76,
                      ),
                      itemBuilder: (context, index) {
                        final deptName = itemsToShow[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorListScreen(selectedDepartment: deptName),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.outlineVariant.withAlpha(50)),
                              boxShadow: const [
                                BoxShadow(color: Color(0x08131B2E), blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryFixed.withAlpha(120),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getSpecialtyIcon(deptName),
                                    color: AppTheme.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  deptName,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 22),

            // Featured Doctors Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'উপলব্ধ ডাক্তারবৃন্দ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                TextButton(
                  onPressed: () => widget.onNavigateTab(1),
                  child: const Text('সব ডাক্তার', style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Featured Doctors List
            _isLoadingDoctors
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _doctors.take(8).length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doc = _doctors[index];
                      return _buildDoctorCard(context, doc);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  static String _toBanglaNumber(int n) {
    const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return n.toString().split('').map((char) {
      final digit = int.tryParse(char);
      return digit != null ? bnDigits[digit] : char;
    }).join('');
  }

  Widget _buildTopDoctorsSection(BuildContext context) {
    if (_featuredDoctors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppTheme.tertiaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: AppTheme.tertiary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'সেরা ডাক্তার',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const Text(
                      'শীর্ষ বিশেষজ্ঞ ও কনসালট্যান্ট',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () => widget.onNavigateTab(1),
              child: const Text(
                'সব ডাক্তার',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _featuredDoctors.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final featured = _featuredDoctors[index];
              final doc = featured.doctor;
              final rankStr = _toBanglaNumber(featured.displayOrder);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorProfileScreen(doctor: doc),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppTheme.tertiary.withAlpha(50),
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C131B2E),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B5000), Color(0xFFFFB77C)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '#$rankStr সেরা',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryFixed.withAlpha(80),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '৳${doc.fee}',
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.primaryFixedDim, width: 2),
                            ),
                            child: ClipOval(
                              child: (doc.displayAvatarUrl.isNotEmpty && doc.displayAvatarUrl.startsWith('http'))
                                  ? Image.network(
                                      doc.displayAvatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: AppTheme.primary,
                                      ),
                                    )
                                  : const Icon(Icons.person, size: 32, color: AppTheme.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppTheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doc.specialty,
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        doc.degrees,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppTheme.outline, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doc.roomNo,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.outline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: FilledButton.tonal(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorProfileScreen(doctor: doc),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'সিরিয়াল বুক করুন',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surfaceContainerHigh,
                    border: Border.all(color: AppTheme.primaryFixedDim, width: 1.5),
                  ),
                  child: ClipOval(
                    child: (doctor.displayAvatarUrl.isNotEmpty && doctor.displayAvatarUrl.startsWith('http'))
                        ? Image.network(
                            doctor.displayAvatarUrl,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.person,
                              size: 36,
                              color: AppTheme.primary,
                            ),
                          )
                        : const Icon(Icons.person, size: 36, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.onSurface,
                              ),
                            ),
                          ),
                          const Icon(Icons.verified, color: AppTheme.tertiary, size: 18),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.specialty,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.degrees,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      doctor.chamberTime,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    'ফি: ৳${doctor.fee}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorProfileScreen(doctor: doctor),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('প্রোফাইল'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorProfileScreen(doctor: doctor),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('সিরিয়াল নিন'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSpecialtyIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('কার্ডি') || lower.contains('হৃদরোগ')) return Icons.favorite_rounded;
    if (lower.contains('গ্যাস্ট্রো') || lower.contains('লিভার')) return Icons.monitor_heart_rounded;
    if (lower.contains('শিশু')) return Icons.child_care_rounded;
    if (lower.contains('গাইনী') || lower.contains('প্রসূতি')) return Icons.pregnant_woman_rounded;
    if (lower.contains('নিউরো')) return Icons.psychology_rounded;
    if (lower.contains('অর্থো') || lower.contains('হাড়')) return Icons.accessibility_new_rounded;
    if (lower.contains('নাক') || lower.contains('কান') || lower.contains('ইএনটি')) return Icons.hearing_rounded;
    if (lower.contains('চক্ষু') || lower.contains('চোখ')) return Icons.visibility_rounded;
    if (lower.contains('চর্ম') || lower.contains('যৌন') || lower.contains('স্কিন')) return Icons.healing_rounded;
    if (lower.contains('দাঁত') || lower.contains('ডেন্টাল')) return Icons.clean_hands_rounded;
    if (lower.contains('ইউরো') || lower.contains('কিডনি')) return Icons.water_drop_rounded;
    if (lower.contains('সার্জারি')) return Icons.medical_services_rounded;
    if (lower.contains('অনকোলজি') || lower.contains('ক্যান্সার')) return Icons.biotech_rounded;
    if (lower.contains('ডায়াবেটিস') || lower.contains('এন্ডোক্রাইন')) return Icons.bloodtype_rounded;
    if (lower.contains('বক্ষব্যাধি') || lower.contains('ফুসফুস')) return Icons.air_rounded;
    if (lower.contains('জনস্বাস্থ্য') || lower.contains('মেডিসিন')) return Icons.medication_rounded;
    return Icons.local_hospital_rounded;
  }

  void _showHotlineDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.emergency_rounded, color: AppTheme.error, size: 48),
              const SizedBox(height: 12),
              const Text(
                'ন্যাশনাল হাসপাতাল জরুরি সেবা',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                '২৪ ঘণ্টা অ্যাম্বুলেন্স ও ইমার্জেন্সি সাপোর্ট',
                style: TextStyle(color: AppTheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.primaryFixed,
                      child: Icon(Icons.phone, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('হটলাইন সার্ভিস', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('০৯৬৪৮-২৫০২৫০', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('কল করুন'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.errorContainer,
                      child: Icon(Icons.emergency, color: AppTheme.error),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('জরুরি অ্যাম্বুলেন্স', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('০১৮১৯-XXXXXX', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                      child: const Text('কল করুন'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
