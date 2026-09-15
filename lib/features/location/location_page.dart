import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:e7gzly/core/custom_loading.dart';
import 'package:e7gzly/features/home/data/clinic_model.dart';
import 'package:e7gzly/features/home/presentation/center_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' hide Path;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with TickerProviderStateMixin {
  // ─── Map ────────────────────────────────────────────────────────────────────
  final MapController _mapController = MapController();

  // Default center — Alexandria (shown until GPS resolves)
  LatLng _mapCenter = const LatLng(31.2001, 29.9187);
  LatLng? _userLocation;

  // ─── Data ───────────────────────────────────────────────────────────────────
  List<ClinicModel> _clinics = [];

  // ─── UI State ───────────────────────────────────────────────────────────────
  bool _locationLoading = true;
  bool _clinicsLoading = true;
  String? _locationError;

  // Selected clinic index (for highlighting the bottom card)
  int _selectedIndex = 0;

  // Pulse animation for the user-location dot
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // ─── Search ─────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<ClinicModel> get _filteredClinics => _clinics.where((c) {
        if (_searchQuery.isEmpty) return true;
        final q = _searchQuery.toLowerCase();
        return c.name.toLowerCase().contains(q) ||
            (c.address.toLowerCase().contains(q)) ||
            (c.type?.toLowerCase().contains(q) ?? false);
      }).toList();

  // ─── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });

    _initLocation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ─── GPS ────────────────────────────────────────────────────────────────────
  Future<void> _initLocation() async {
    if (!mounted) return;
    setState(() {
      _locationLoading = true;
      _locationError = null;
    });

    try {
      // 1. Check / request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (!mounted) return;

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permission permanently denied.\n'
              'Please enable it in App Settings.';
          _locationLoading = false;
        });
        _fetchNearbyClinics(_mapCenter.latitude, _mapCenter.longitude);
        return;
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permission denied.';
          _locationLoading = false;
        });
        _fetchNearbyClinics(_mapCenter.latitude, _mapCenter.longitude);
        return;
      }

      // 2. Try last-known position first — instant, never blocks
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (!mounted) return;

      if (lastKnown != null) {
        final lastLatLng = LatLng(lastKnown.latitude, lastKnown.longitude);
        setState(() {
          _userLocation = lastLatLng;
          _mapCenter = lastLatLng;
          _locationLoading = false;
        });
        _animatedMapMove(lastLatLng, 14.5);
        // Start clinics fetch in parallel — don't await here
        _fetchNearbyClinics(lastKnown.latitude, lastKnown.longitude);
      }

      // 3. Get accurate position with a hard 10s timeout
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('GPS timed out'),
      );

      if (!mounted) return;

      final userLatLng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _userLocation = userLatLng;
        _mapCenter = userLatLng;
        _locationLoading = false;
      });
      _animatedMapMove(userLatLng, 14.5);

      // Refresh clinics with accurate position (only if moved significantly)
      if (lastKnown == null ||
          (pos.latitude - lastKnown.latitude).abs() > 0.001 ||
          (pos.longitude - lastKnown.longitude).abs() > 0.001) {
        _fetchNearbyClinics(pos.latitude, pos.longitude);
      }
    } on TimeoutException {
      debugPrint('Location timed out — using fallback');
      if (!mounted) return;
      // Only show error if we never got a position at all
      if (_userLocation == null) {
        setState(() {
          _locationError = 'Location timed out. Showing default area.';
          _locationLoading = false;
        });
        _fetchNearbyClinics(_mapCenter.latitude, _mapCenter.longitude);
      }
    } catch (e) {
      debugPrint('Location error: $e');
      if (!mounted) return;
      if (_userLocation == null) {
        setState(() {
          _locationError = 'Could not get location.';
          _locationLoading = false;
        });
        _fetchNearbyClinics(_mapCenter.latitude, _mapCenter.longitude);
      }
    }
  }

  // ─── API ────────────────────────────────────────────────────────────────────
  Future<void> _fetchNearbyClinics(double lat, double lng,
      {double radius = 5}) async {
    if (!mounted) return;
    setState(() => _clinicsLoading = true);

    try {
      final uri = Uri.parse(
        'http://10.0.2.2:8080/api/clinics/nearby?lat=$lat&lng=$lng&radius=$radius',
      );
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          _clinics = jsonList
              .map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
              .toList();
          _clinicsLoading = false;
        });
      } else {
        throw Exception('API error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Clinics fetch error: $e');
      if (!mounted) return;
      setState(() => _clinicsLoading = false);
    }
  }

  // ─── Smooth map animation ───────────────────────────────────────────────────
  void _animatedMapMove(LatLng dest, double zoom) {
    final latTween = Tween<double>(
        begin: _mapController.camera.center.latitude, end: dest.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.camera.center.longitude, end: dest.longitude);
    final zoomTween =
        Tween<double>(begin: _mapController.camera.zoom, end: zoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    final anim = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(anim), lngTween.evaluate(anim)),
        zoomTween.evaluate(anim),
      );
    });
    controller.addStatusListener((s) {
      if (s == AnimationStatus.completed ||
          s == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  // ─── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final clinics = _filteredClinics;

    return Scaffold(
      body: Stack(
        children: [
          // ── 1. Map ──────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _mapCenter,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.e7gzly',
                tileBuilder: (context, tileWidget, _) => ColorFiltered(
                  colorFilter: const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0,      0,      0,      1, 0,
                  ]),
                  child: tileWidget,
                ),
              ),

              // Clinic markers
              MarkerLayer(
                markers: [
                  // User location marker
                  if (_userLocation != null) _buildUserMarker(_userLocation!),

                  // Clinic markers
                  ...List.generate(clinics.length, (i) {
                    final c = clinics[i];
                    if (c.latitude == null || c.longitude == null) {
                      return null;
                    }
                    return _buildClinicMarker(
                      LatLng(c.latitude!, c.longitude!),
                      i,
                      i == _selectedIndex,
                      () {
                        setState(() => _selectedIndex = i);
                        _animatedMapMove(
                            LatLng(c.latitude!, c.longitude!), 15.5);
                      },
                    );
                  }).whereType<Marker>(),
                ],
              ),
            ],
          ),

          // ── 2. Search bar ───────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search nearby clinics…',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 15,
                    ),
                    prefixIcon:
                        Icon(Icons.search, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // ── 3. Location error banner ────────────────────────────────────────
          if (_locationError != null)
            Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFD97706), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _locationError!,
                          style: const TextStyle(
                              color: Color(0xFF92400E), fontSize: 13),
                        ),
                      ),
                      GestureDetector(
                        onTap: _initLocation,
                        child: const Icon(Icons.refresh,
                            color: Color(0xFFD97706), size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── 4. Bottom clinic cards ──────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            height: 250,
            child: _clinicsLoading
                ? const Center(child: CustomLoadingIndicator())
                : clinics.isEmpty
                    ? _buildEmptyCard()
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: clinics.length,
                        itemBuilder: (context, i) {
                          final clinic = clinics[i];
                          return Padding(
                            padding: EdgeInsets.only(
                                right: i < clinics.length - 1 ? 16 : 0),
                            child: _ClinicMapCard(
                              clinic: clinic,
                              isSelected: i == _selectedIndex,
                              userLatLng: _userLocation,
                              onTap: () {
                                setState(() => _selectedIndex = i);
                                if (clinic.latitude != null &&
                                    clinic.longitude != null) {
                                  _animatedMapMove(
                                    LatLng(clinic.latitude!,
                                        clinic.longitude!),
                                    15.5,
                                  );
                                }
                              },
                              onDetails: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CenterDetailsScreen(clinic: clinic),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),

          // ── 5. Re-center FAB ────────────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: 290,
            child: _buildFab(
              icon: _locationLoading
                  ? Icons.sync
                  : Icons.my_location_rounded,
              onTap: _locationLoading
                  ? null
                  : () {
                      if (_userLocation != null) {
                        _animatedMapMove(_userLocation!, 14.5);
                      } else {
                        _initLocation();
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Widgets ────────────────────────────────────────────────────────────────

  Widget _buildFab({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF1E293B), size: 24),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 40, color: Color(0xFF94A3B8)),
            SizedBox(height: 8),
            Text(
              'No clinics found nearby',
              style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              'Try expanding the search radius',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── Map Markers ─────────────────────────────────────────────────────────────

  /// Pulsing blue dot for the user's real GPS position
  Marker _buildUserMarker(LatLng point) {
    return Marker(
      point: point,
      width: 60,
      height: 60,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (ctx, anim) {
          final scale = _pulseAnim.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring
              Transform.scale(
                scale: scale,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Color(0xFF3B82F6).withValues(alpha: 0.25 * scale),
                  ),
                ),
              ),
              // Inner solid dot
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x443B82F6),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Medical-cross pin for clinic markers
  Marker _buildClinicMarker(
    LatLng point,
    int index,
    bool isSelected,
    VoidCallback onTap,
  ) {
    // Cycle through accent colours for variety
    const colours = [
      Color(0xFFF43F5E),
      Color(0xFF0D9488),
      Color(0xFF8B5CF6),
      Color(0xFF0284C7),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
    ];
    final color = colours[index % colours.length];

    return Marker(
      point: point,
      width: isSelected ? 60 : 50,
      height: isSelected ? 68 : 58,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 50 : 42,
              height: isSelected ? 50 : 42,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isSelected ? 0.5 : 0.25),
                    blurRadius: isSelected ? 10 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(Icons.local_hospital_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
            ClipPath(
              clipper: _TriangleClipper(),
              child: Container(
                width: 10,
                height: 6,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Triangle clipper (map-pin pointer) ────────────────────────────────────────
class _TriangleClipper extends CustomClipper<Path> {
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

// ─── Clinic map card ────────────────────────────────────────────────────────────
class _ClinicMapCard extends StatelessWidget {
  final ClinicModel clinic;
  final bool isSelected;
  final LatLng? userLatLng;
  final VoidCallback onTap;
  final VoidCallback onDetails;

  const _ClinicMapCard({
    required this.clinic,
    required this.isSelected,
    required this.userLatLng,
    required this.onTap,
    required this.onDetails,
  });

  /// Compute approximate km distance between user and clinic
  String _distanceLabel() {
    if (userLatLng == null ||
        clinic.latitude == null ||
        clinic.longitude == null) {
      return '—';
    }
    const R = 6371.0;
    final dLat =
        _rad(clinic.latitude! - userLatLng!.latitude);
    final dLng =
        _rad(clinic.longitude! - userLatLng!.longitude);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(userLatLng!.latitude)) *
            math.cos(_rad(clinic.latitude!)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final km = R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return km < 1
        ? '${(km * 1000).round()} m'
        : '${km.toStringAsFixed(1)} km';
  }

  static double _rad(double deg) => deg * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    final headerColors = const [
      Color(0xFFBAE6FD),
      Color(0xFFFED7AA),
      Color(0xFFDDD6FE),
      Color(0xFF99F6E4),
      Color(0xFFFDE68A),
    ];
    final headerColor =
        headerColors[clinic.id % headerColors.length];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFF3B82F6), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.10 : 0.06),
              blurRadius: isSelected ? 16 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header image area
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
                  // Clinic image or fallback icon
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: SizedBox.expand(
                      child: clinic.imageUrl != null &&
                              clinic.imageUrl!.isNotEmpty
                          ? Image.network(
                              clinic.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stackTrace) => _fallbackIcon(),
                            )
                          : _fallbackIcon(),
                    ),
                  ),
                  // Details button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onDetails,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Distance badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF1E293B).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.near_me_outlined,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            _distanceLabel(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info area
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic.name,
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
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          clinic.address,
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
                      // Rating
                      Text(
                        clinic.rating?.toStringAsFixed(1) ?? '—',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: i <
                                  (clinic.rating ?? 0).round()
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${clinic.reviewsCount ?? 0} reviews)',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const Spacer(),
                      // Type badge
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            clinic.type ?? 'Medical',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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

  Widget _fallbackIcon() => Container(
        color: const Color(0xFFF1F5F9),
        child: const Center(
          child: Icon(
            Icons.local_hospital_rounded,
            size: 48,
            color: Color(0xFF94A3B8),
          ),
        ),
      );
}
