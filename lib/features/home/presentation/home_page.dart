import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e7gzly/core/api_constants.dart';
import 'package:e7gzly/features/home/data/clinic_model.dart';
import 'package:e7gzly/features/home/presentation/center_details_page.dart';
import 'package:e7gzly/features/home/presentation/near_by_clinics_page.dart';
import 'package:e7gzly/features/home/presentation/notification_page.dart';
import 'package:e7gzly/features/home/presentation/show_all_doctors_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Location & Notification Header
                    const LocationHeader(),
                    const SizedBox(height: 16),

                    // Search Bar
                    const SearchBarWidget(),
                    const SizedBox(height: 20),

                    // Doctor Promo Banner
                    DoctorPromoBanner(),
                    const SizedBox(height: 24),

                    // Categories Section
                    const SectionHeader(
                      title: 'Categories',
                      screen: AllDoctorsScreen(),
                    ),
                    const SizedBox(height: 16),
                    const CategoriesGrid(),
                    const SizedBox(height: 24),

                    // Nearby Medical Centers Section
                    const SectionHeader(
                      title: 'Nearby Medical Centers',
                      screen: NearbyCentersScreen(),
                    ),
                    const SizedBox(height: 16),
                    const MedicalCentersList(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(fontSize: 14, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/location_bold.png'),
                const SizedBox(width: 4),
                Text(
                  'Baltinme, EG',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF0F172A),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/icons/notification-bing_bold.png'),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search doctor...',
          hintStyle: GoogleFonts.inter(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class DoctorPromoBanner extends StatelessWidget {
  DoctorPromoBanner({super.key});
  // ! get it from api later
  final List<String> images = [
    "https://img.magnific.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg?semt=ais_hybrid&w=740&q=80",
    "https://thumbs.dreamstime.com/b/young-male-doctor-close-up-happy-looking-camera-56751540.jpg",
    "https://i.pinimg.com/736x/8e/3e/c9/8e3ec97f315b2b9951b8cae1337644e7.jpg",
    "https://i.pinimg.com/736x/20/a9/48/20a9489cc05ff30818ec5f5b26d38243.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Image.network(
            images[itemIndex],
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              color: const Color(0xFFE2E8F0),
              child: const Icon(Icons.image, color: Color(0xFF94A3B8)),
            ),
          ),
      options: CarouselOptions(
        height: 200,
        aspectRatio: 4.0,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget screen;

  const SectionHeader({super.key, required this.title, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Text(
            'See All',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Dentistry',
      'icon': Icons.clean_hands_outlined,
      'color': Color(0xFFF87171),
    },
    {
      'title': 'Cardiolo..',
      'icon': Icons.favorite_outline,
      'color': Color(0xFF86EFAC),
    },
    {'title': 'Pulmono..', 'icon': Icons.air, 'color': Color(0xFFFDBA74)},
    {
      'title': 'General',
      'icon': Icons.medical_services_outlined,
      'color': Color(0xFFC084FC),
    },
    {
      'title': 'Neurology',
      'icon': Icons.psychology_outlined,
      'color': Color(0xFF2DD4BF),
    },
    {
      'title': 'Gastroen..',
      'icon': Icons.health_and_safety_outlined,
      'color': Color(0xFF4338CA),
    },
    {
      'title': 'Laborato..',
      'icon': Icons.science_outlined,
      'color': Color(0xFFFCA5A5),
    },
    {
      'title': 'Vaccinat..',
      'icon': Icons.vaccines_outlined,
      'color': Color(0xFF38BDF8),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];
        return Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: (item['color'] as Color).withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item['title'] as String,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class MedicalCentersList extends StatefulWidget {
  const MedicalCentersList({super.key});

  @override
  State<MedicalCentersList> createState() => _MedicalCentersListState();
}

class _MedicalCentersListState extends State<MedicalCentersList> {
  List<ClinicModel> clinics = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  Future<void> fetchClinics() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/clinics'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        setState(() {
          clinics = jsonResponse
              .map((json) => ClinicModel.fromJson(json as Map<String, dynamic>))
              .toList();

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load clinics');
      }
    } catch (e) {
      debugPrint('Error fetching clinics: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (clinics.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No medical centers found',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: clinics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final clinic = clinics[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CenterDetailsScreen(clinic: clinic),
                ),
              );
            },
            child: MedicalCenterCard(
              title: clinic.name,
              imageUrl: clinic.imageUrl,
            ),
          );
        },
      ),
    );
  }
}

class MedicalCenterCard extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const MedicalCenterCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),

                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          width: double.infinity,
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(
                            Icons.local_hospital,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      )
                    : Container(
                        height: 120,
                        width: double.infinity,
                        color: const Color(0xFFE2E8F0),
                        child: const Icon(
                          Icons.local_hospital,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
