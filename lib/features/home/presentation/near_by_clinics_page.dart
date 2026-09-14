import 'package:flutter/material.dart';

class NearbyCentersScreen extends StatefulWidget {
  const NearbyCentersScreen({super.key});

  @override
  State<NearbyCentersScreen> createState() => _NearbyCentersScreenState();
}

class _NearbyCentersScreenState extends State<NearbyCentersScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Hospitals', 'Clinics', 'Pharmacies', 'Labs'];

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
                      color: isSelected ? const Color(0xFF1E293B) : Colors.white,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF1E293B),
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

          // Results count and Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '124 found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Row(
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: const [
                MedicalCenterCard(
                  name: 'Golden Cardiology Center',
                  type: 'Specialty Clinic',
                  location: 'Golden Gate, CA, USA',
                  rating: '4.9',
                  reviews: '1,204',
                  distance: '1.2 km',
                ),
                MedicalCenterCard(
                  name: 'City General Hospital',
                  type: 'Hospital',
                  location: 'Downtown Ave, Seattle, USA',
                  rating: '4.7',
                  reviews: '8,432',
                  distance: '2.5 km',
                ),
                MedicalCenterCard(
                  name: "Women's Health Clinic",
                  type: 'Clinic',
                  location: 'Pine Street, Seattle, USA',
                  rating: '4.8',
                  reviews: '943',
                  distance: '3.1 km',
                ),
                MedicalCenterCard(
                  name: 'Elite Ortho Clinic',
                  type: 'Specialty Clinic',
                  location: 'Maple Associates, NY, USA',
                  rating: '4.6',
                  reviews: '512',
                  distance: '4.8 km',
                ),
              ],
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
  final String rating;
  final String reviews;
  final String distance;

  const MedicalCenterCard({
    super.key,
    required this.name,
    required this.type,
    required this.location,
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
          // Image Placeholder (Hospital/Building Icon)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 90,
              height: 100,
              color: const Color(0xFFF1F5F9),
              child: const Icon(Icons.local_hospital_rounded, size: 40, color: Color(0xFF94A3B8)),
            ),
          ),
          const SizedBox(width: 14),
          
          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        color: isFavorite ? Colors.red : const Color(0xFF64748B),
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
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
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
                    const Icon(Icons.star, size: 16, color: Colors.orangeAccent),
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
                      child: Text('|', style: TextStyle(color: Color(0xFFCBD5E1))),
                    ),
                    Text(
                      '${widget.distance} away',
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