import 'dart:convert';

import 'package:e7gzly/core/api_constants.dart';
import 'package:e7gzly/core/custom_loading.dart';
import 'package:e7gzly/features/home/data/clinic_model.dart';
import 'package:e7gzly/features/home/presentation/center_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NearbyCentersScreen extends StatefulWidget {
  const NearbyCentersScreen({super.key});

  @override
  State<NearbyCentersScreen> createState() => _NearbyCentersScreenState();
}

class _NearbyCentersScreenState extends State<NearbyCentersScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Hospitals',
    'Clinics',
    'Pharmacies',
    'Labs',
  ];

  List<ClinicModel> clinicsList = [];

  bool isLoading = true;

  Future<void> fetchClinics() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/clinics'),
      );

      debugPrint('Clinics API: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        setState(() {
          clinicsList = jsonResponse
              .map((json) => ClinicModel.fromJson(json as Map<String, dynamic>))
              .toList();

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load clinics: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching clinics: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  List<ClinicModel> get filteredClinics {
    if (_selectedCategory == 'All') {
      return clinicsList;
    }

    return clinicsList.where((clinic) {
      final type = clinic.type?.toLowerCase() ?? '';

      switch (_selectedCategory) {
        case 'Hospitals':
          return type.contains('hospital');

        case 'Clinics':
          return type.contains('clinic');

        case 'Pharmacies':
          return type.contains('pharmacy');

        case 'Labs':
          return type.contains('lab');

        default:
          return true;
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nearby Centers',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search medical centers...',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFCBD5E1),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1E293B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${clinicsList.length} found',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.swap_vert, size: 16, color: Color(0xFF64748B)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Centers List
          Expanded(
            child: isLoading
                ? const Center(child: CustomLoadingIndicator())
                : filteredClinics.isEmpty
                ? const Center(
                    child: Text(
                      'No medical centers found',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: filteredClinics.length,
                    itemBuilder: (context, index) {
                      final clinic = filteredClinics[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CenterDetailsScreen(clinic: clinic),
                            ),
                          );
                        },
                        child: MedicalCenterCard(
                          name: clinic.name,
                          type: clinic.type ?? 'Medical Center',
                          location: clinic.address,
                          imageUrl: clinic.imageUrl,
                          rating: clinic.rating?.toString() ?? '—',
                          reviews: clinic.reviewsCount?.toString() ?? '—',
                          distance: '—',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MedicalCenterCard extends StatefulWidget {
  final String name;
  final String type;
  final String location;
  final String? imageUrl;
  final String rating;
  final String reviews;
  final String distance;

  const MedicalCenterCard({
    super.key,
    required this.name,
    required this.type,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.distance,
  });

  @override
  State<MedicalCenterCard> createState() => _MedicalCenterCardState();
}

class _MedicalCenterCardState extends State<MedicalCenterCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clinic Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 90,
              height: 100,
              child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                  ? Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(
                            Icons.local_hospital_rounded,
                            size: 40,
                            color: Color(0xFF94A3B8),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        size: 40,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFavorite
                            ? Colors.red
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  widget.type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 4),

                    Text(
                      widget.rating,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '|',
                        style: TextStyle(color: Color(0xFFCBD5E1)),
                      ),
                    ),

                    Text(
                      widget.distance == '—'
                          ? 'Distance unavailable'
                          : '${widget.distance} away',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
