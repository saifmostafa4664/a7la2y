import 'dart:async';
import 'package:a7la2y/screens/client/barber/barber_list_screen.dart';
import 'package:a7la2y/screens/client/barber_shops/barber_shops_screen.dart';
import 'package:a7la2y/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();

  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);
  LatLng _currentPosition = _defaultCenter;
  bool _isLoadingLocation = true;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      if (position != null) {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _currentAddress =
            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      }
      _isLoadingLocation = false;
    });
    try {
      _mapController.move(_currentPosition, 15.0);
    } catch (_) {}
  }

  void _centerOnMe() {
    try {
      _mapController.move(_currentPosition, 15.0);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _defaultCenter,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.saifmo.a7la2y',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition,
                        width: 44,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildFloatingCircleButton(
                        icon: Icons.menu_rounded,
                        onTap: () {},
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "موقعك الحالي",
                                      style: GoogleFonts.zain(
                                        fontSize: 10,
                                        color: const Color(0xFF9E9E9E),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _isLoadingLocation
                                          ? "جاري تحديد الموقع..."
                                          : _currentAddress ??
                                                "المعادي، القاهرة",
                                      style: GoogleFonts.zain(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_left_rounded,
                                color: Color(0xFFBBBBBB),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        children: [
                          _buildFloatingCircleButton(
                            icon: Icons.notifications_none_rounded,
                            onTap: () {},
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 16,
              bottom: 370,
              child: _buildFloatingCircleButton(
                icon: Icons.my_location_rounded,
                onTap: _centerOnMe,
              ),
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.42,
              minChildSize: 0.12,
              maxChildSize: 0.75,
              snap: true,
              snapSizes: const [0.12, 0.42, 0.75],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 6),
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDDDDD),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "صباح الخير",
                                  style: GoogleFonts.zain(
                                    fontSize: 14,
                                    color: const Color(0xFF9E9E9E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "👋",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                              "ماذا تريد اليوم؟",
                              style: GoogleFonts.zain(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 4),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildServiceCategoryBig(
                                title: "حلاق في المنزل",
                                subtitle: "نوصلك لحد البيت",
                                icon: Icons.home_rounded,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BarberListScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildServiceCategorySmall(
                                    title: "صالون حلاقة",
                                    icon: Icons.store_rounded,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BarberShopsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  _buildServiceCategorySmall(
                                    title: "عناية وتجميل",
                                    icon: Icons.spa_rounded,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF9E9E9E),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "ابحث عن حلاق أو خدمة...",
                                  style: GoogleFonts.zain(
                                    fontSize: 14,
                                    color: const Color(0xFF9E9E9E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _buildRecentAddress(
                        title: "شارع صلاح الدين",
                        subtitle: "العمرانية، الجيزة",
                      ),
                      _buildRecentAddress(
                        title: "طريق القاهرة - السويس",
                        subtitle: "البساتين، القاهرة",
                      ),
                      _buildRecentAddress(
                        title: "المعادي، القاهرة",
                        subtitle: "شارع 9 — بجوار مسجد المعادي",
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.content_cut_rounded,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "خدمات سريعة",
                                  style: GoogleFonts.zain(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "عرض الكل",
                              style: GoogleFonts.zain(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            _buildServiceChip(
                              "قص شعر",
                              Icons.content_cut_rounded,
                              "25 ج.م",
                            ),
                            _buildServiceChip(
                              "حلاقة",
                              Icons.brush_rounded,
                              "15 ج.م",
                            ),
                            _buildServiceChip(
                              "تشكيل لحية",
                              Icons.face_retouching_natural_rounded,
                              "20 ج.م",
                            ),
                            _buildServiceChip(
                              "غسيل شعر",
                              Icons.shower_rounded,
                              "10 ج.م",
                            ),
                            _buildServiceChip(
                              "صبغة شعر",
                              Icons.color_lens_outlined,
                              "50 ج.م",
                            ),
                            _buildServiceChip(
                              "عناية بالبشرة",
                              Icons.spa_rounded,
                              "40 ج.م",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "زرتهم مؤخراً",
                              style: GoogleFonts.zain(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "عرض الكل",
                              style: GoogleFonts.zain(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 110,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            _buildBarberItem(name: "أحمد خالد", rating: "4.7"),
                            _buildBarberItem(name: "عبدالرحمن", rating: "4.8"),
                            _buildBarberItem(
                              name: "محمد إبراهيم",
                              rating: "4.9",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }

  Widget _buildServiceCategoryBig({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.zain(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.zain(
                    fontSize: 11,
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategorySmall({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.zain(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFFCCCCCC),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAddress({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.access_time_rounded,
                color: Color(0xFF9E9E9E),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.zain(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.zain(
                      fontSize: 12,
                      color: const Color(0xFF9E9E9E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceChip(String name, IconData icon, String price) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black, size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: GoogleFonts.zain(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            price,
            style: GoogleFonts.zain(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarberItem({required String name, required String rating}) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFFB5B5B5),
                  size: 32,
                ),
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFD700),
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.zain(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
