import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Center coordinates for the map (e.g., Alexandria)
  final LatLng _mapCenter = const LatLng(31.2001, 29.9187);
  final MapController _mapController = MapController();

  // Doctor/Hospital Marker Coordinates
  final List<LatLng> _markerLocations = const [
    LatLng(31.2050, 29.9240),
    LatLng(31.1980, 29.9120),
    LatLng(31.2090, 29.9100),
    LatLng(31.1940, 29.9280),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. OpenStreetMap Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _mapCenter, initialZoom: 14.0),
            children: [
              // OpenStreetMap Tile Provider (Free / No API Key Required)
              TileLayer(
                urlTemplate: 'https://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.e7gzly',
                tileBuilder: (context, tileWidget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      // Increases brightness and contrast slightly to get soft grey land & bright white roads
                      0.9, 0, 0, 0, 25,
                      0, 0.9, 0, 0, 25,
                      0, 0, 0.9, 0, 25,
                      0, 0, 0, 1, 0,
                    ]),
                    child: tileWidget,
                  );
                },
              ),

              // Marker Layer for Doctors & Hospitals
              MarkerLayer(
                markers: [
                  _buildMapMarker(
                    _markerLocations[0],
                    Icons.person_3_outlined,
                    const Color(0xFFF43F5E),
                  ),
                  _buildMapMarker(
                    _markerLocations[1],
                    Icons.person_4_outlined,
                    const Color(0xFF0D9488),
                  ),
                  _buildMapMarker(
                    _markerLocations[2],
                    Icons.person_2_outlined,
                    const Color(0xFF8B5CF6),
                  ),
                  _buildMapMarker(
                    _markerLocations[3],
                    Icons.person_outlined,
                    const Color(0xFF0284C7),
                  ),
                ],
              ),
            ],
          ),

          // 2. Search Bar Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Doctor, Hospital',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // 3. Bottom Card Carousel
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ClinicCard(
                  name: 'Sunrise Health Clinic',
                  address: '123 Oak Street, CA 98765',
                  rating: '5.0',
                  reviews: '58',
                  distance: '2.5 km/40min',
                  type: 'Hospital',
                  headerColor: const Color(0xFFBAE6FD),
                  onTap: () => _mapController.move(_markerLocations[0], 15.5),
                ),
                const SizedBox(width: 16),
                ClinicCard(
                  name: 'Golden Cardiology',
                  address: '555 Bridge Street',
                  rating: '4.9',
                  reviews: '108',
                  distance: '2.5 km/40min',
                  type: 'Clinic',
                  headerColor: const Color(0xFFFED7AA),
                  onTap: () => _mapController.move(_markerLocations[1], 15.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildMapMarker(LatLng point, IconData icon, Color color) {
    return Marker(
      point: point,
      width: 50,
      height: 58,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: 10,
              height: 6,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ClinicCard extends StatelessWidget {
  final String name;
  final String address;
  final String rating;
  final String reviews;
  final String distance;
  final String type;
  final Color headerColor;
  final VoidCallback onTap;

  const ClinicCard({
    super.key,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.type,
    required this.headerColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.local_hospital_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviews Reviews)',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me_outlined,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.local_hospital_outlined,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
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
    );
  }
}
