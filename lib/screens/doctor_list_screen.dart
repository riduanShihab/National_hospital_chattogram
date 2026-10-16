import 'package:flutter/material.dart';
import '../models/hospital_models.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'doctor_profile_screen.dart';

class DoctorListScreen extends StatefulWidget {
  final String? selectedDepartment;
  final String? initialSearchQuery;

  const DoctorListScreen({
    super.key,
    this.selectedDepartment,
    this.initialSearchQuery,
  });

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late String _activeCategory;
  late TextEditingController _searchController;
  String _searchQuery = '';
  List<Doctor> _allDoctors = [];
  List<String> _categories = ['সকল ডাক্তার'];
  bool _isLoading = true;
  bool _filterAvailableTodayOnly = false;
  String _sortBy = 'default'; // 'default', 'fee_low', 'fee_high', 'name'

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.selectedDepartment ?? 'সকল ডাক্তার';
    _searchQuery = widget.initialSearchQuery ?? '';
    _searchController = TextEditingController(text: _searchQuery);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        SupabaseService.getDoctors(),
        SupabaseService.getSpecialties(),
      ]);
      final docs = results[0] as List<Doctor>;
      final specs = results[1] as List<Map<String, dynamic>>;

      if (mounted) {
        setState(() {
          _allDoctors = docs;
          final specNames = specs
              .map((s) => s['name_bn']?.toString())
              .whereType<String>()
              .toList();
          _categories = ['সকল ডাক্তার', ...specNames];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _allDoctors = Doctor.sampleDoctors;
          _isLoading = false;
        });
      }
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String tempCategory = _activeCategory;
        bool tempAvailableToday = _filterAvailableTodayOnly;
        String tempSort = _sortBy;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ফিল্টার ও সর্টিং',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setSheetState(() {
                            tempCategory = 'সকল ডাক্তার';
                            tempAvailableToday = false;
                            tempSort = 'default';
                          });
                        },
                        child: const Text('রিসেট', style: TextStyle(color: AppTheme.error)),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          'উপলব্ধতা ফিল্টার',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('আজকের চেম্বার উপলব্ধ ডাক্তার'),
                          subtitle: const Text('যে সকল ডাক্তার আজ রোগী দেখছেন'),
                          value: tempAvailableToday,
                          activeThumbColor: AppTheme.primary,
                          onChanged: (val) => setSheetState(() => tempAvailableToday = val),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'সাজানোর ক্রম (Sort By)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSortChip('ডিফল্ট', 'default', tempSort, (val) => setSheetState(() => tempSort = val)),
                            _buildSortChip('ফি: কম থেকে বেশি', 'fee_low', tempSort, (val) => setSheetState(() => tempSort = val)),
                            _buildSortChip('ফি: বেশি থেকে কম', 'fee_high', tempSort, (val) => setSheetState(() => tempSort = val)),
                            _buildSortChip('নাম অনুসারে (A-Z)', 'name', tempSort, (val) => setSheetState(() => tempSort = val)),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'সকল বিশেষজ্ঞ বিভাগ (${_categories.length - 1}টি বিভাগ)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((cat) {
                            final isSel = tempCategory == cat;
                            return ChoiceChip(
                              label: Text(
                                cat,
                                style: TextStyle(
                                  color: isSel ? Colors.white : AppTheme.onSurface,
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              selected: isSel,
                              selectedColor: AppTheme.primary,
                              onSelected: (selected) {
                                if (selected) {
                                  setSheetState(() => tempCategory = cat);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _activeCategory = tempCategory;
                          _filterAvailableTodayOnly = tempAvailableToday;
                          _sortBy = tempSort;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('ফিল্টার প্রয়োগ করুন', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortChip(String label, String value, String current, ValueChanged<String> onSelected) {
    final isSelected = current == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.onSurface,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: AppTheme.secondary,
      onSelected: (sel) {
        if (sel) onSelected(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = _allDoctors.where((doctor) {
      final q = _searchQuery.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          doctor.name.toLowerCase().contains(q) ||
          doctor.specialty.toLowerCase().contains(q) ||
          doctor.degrees.toLowerCase().contains(q) ||
          doctor.roomNo.toLowerCase().contains(q);

      final matchesCategory = _activeCategory == 'সকল ডাক্তার' ||
          doctor.specialty.trim().toLowerCase() == _activeCategory.trim().toLowerCase() ||
          doctor.specialty.trim().toLowerCase().contains(_activeCategory.trim().toLowerCase()) ||
          _activeCategory.trim().toLowerCase().contains(doctor.specialty.trim().toLowerCase());

      final matchesAvailability = !_filterAvailableTodayOnly || doctor.isAvailableToday;

      return matchesSearch && matchesCategory && matchesAvailability;
    }).toList();

    if (_sortBy == 'fee_low') {
      filteredDoctors.sort((a, b) => a.fee.compareTo(b.fee));
    } else if (_sortBy == 'fee_high') {
      filteredDoctors.sort((a, b) => b.fee.compareTo(a.fee));
    } else if (_sortBy == 'name') {
      filteredDoctors.sort((a, b) => a.name.compareTo(b.name));
    }

    final hasActiveFilters = _filterAvailableTodayOnly || _sortBy != 'default' || _activeCategory != 'সকল ডাক্তার';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('বিশেষজ্ঞ ডাক্তারবৃন্দ'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => _showFilterBottomSheet(context),
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'ডাক্তারের নাম বা রোগ খুঁজুন...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Categories Horizontal List
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _activeCategory;
                return ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceContainerLowest,
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : AppTheme.outlineVariant.withAlpha(80),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _activeCategory = cat;
                      });
                    }
                  },
                );
              },
            ),
          ),

          // Doctor Count & Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredDoctors.length} জন ডাক্তার উপলব্ধ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppTheme.secondary),
                    SizedBox(width: 2),
                    Text(
                      'চট্টগ্রাম শাখা',
                      style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Doctors List View
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        SizedBox(height: 12),
                        Text(
                          'ডাক্তারদের তথ্য লোড হচ্ছে...',
                          style: TextStyle(fontSize: 14, color: AppTheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : filteredDoctors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_search_rounded, size: 64, color: AppTheme.outlineVariant),
                            const SizedBox(height: 12),
                            const Text(
                              'কোনো ডাক্তার খুঁজে পাওয়া যায়নি',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredDoctors.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doc = filteredDoctors[index];
                      return _buildDoctorCard(context, doc);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorProfileScreen(doctor: doctor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
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
                                  width: 64,
                                  height: 64,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.person,
                                    size: 38,
                                    color: AppTheme.primary,
                                  ),
                                )
                              : const Icon(Icons.person, size: 38, color: AppTheme.primary),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppTheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.onSurface,
                          ),
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
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.hospital,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 16, color: AppTheme.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'দিন: ${doctor.availableDays.join(', ')}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, size: 16, color: AppTheme.primary),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorProfileScreen(doctor: doctor),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_today_rounded, size: 16),
                      label: const Text('সিরিয়াল বুক করুন'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
