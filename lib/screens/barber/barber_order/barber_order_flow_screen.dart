import 'dart:async';
import 'package:a7la2y/screens/barber/barber_tracking/barber_tracking_screen.dart';
import 'package:a7la2y/services/location_service.dart';
import 'package:a7la2y/services/routing_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class BarberOrderFlowScreen extends StatefulWidget {
  const BarberOrderFlowScreen({super.key});

  @override
  State<BarberOrderFlowScreen> createState() => _BarberOrderFlowScreenState();
}

class _BarberOrderFlowScreenState extends State<BarberOrderFlowScreen> {
  String _currentStatus = 'offline';
  final MapController _mapController = MapController();

  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);

  LatLng _currentPosition = _defaultCenter;
  final LatLng _destinationPosition = const LatLng(30.0390, 31.2450);

  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;
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

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    setState(() => _isLoadingRoute = true);
    final points = await RoutingService.fetchRoute(start, end);
    if (!mounted) return;
    setState(() {
      _routePoints = points;
      _isLoadingRoute = false;
    });
    _fitBounds();
  }

  void _fitBounds() {
    try {
      final bounds = LatLngBounds.fromPoints([
        _currentPosition,
        _destinationPosition,
      ]);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)),
      );
    } catch (_) {}
  }

  void updateCurrentPosition(LatLng newPosition) {
    setState(() {
      _currentPosition = newPosition;
    });
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
            // 1 — Full-screen Map
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
                    userAgentPackageName: 'com.saif.a7la2y',
                  ),
                  if (_routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: const Color(0xFF1A1A1A),
                          strokeWidth: 4.0,
                          borderColor: Colors.black.withValues(alpha: 0.2),
                          borderStrokeWidth: 1.5,
                        ),
                      ],
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
                            Icons.content_cut_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      if (_currentStatus == 'new_request')
                        Marker(
                          point: _destinationPosition,
                          width: 44,
                          height: 44,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.14),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // 2 — Top floating bar (safe area)
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
                      // Menu / Settings button
                      _buildFloatingCircleButton(
                        icon: Icons.menu_rounded,
                        onTap: () {},
                      ),
                      const SizedBox(width: 10),
                      // Pickup point label
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
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
                                  color:
                                      Colors.black.withValues(alpha: 0.08),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "نقطة الانطلاق",
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
                                                "موقعك الحالي",
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
                      ),
                      const SizedBox(width: 10),
                      // Status pill
                      GestureDetector(
                        onTap: () {
                          if (_currentStatus == 'offline') {
                            setState(() => _currentStatus = 'online');
                            _fetchRoute(
                                _currentPosition, _destinationPosition);
                          } else if (_currentStatus == 'online') {
                            setState(() => _currentStatus = 'offline');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _currentStatus == 'offline'
                                ? Colors.white
                                : Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: _currentStatus == 'offline'
                                      ? Colors.grey
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _currentStatus == 'offline'
                                    ? "غير متاح"
                                    : "متاح",
                                style: GoogleFonts.zain(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _currentStatus == 'offline'
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3 — GPS center button (floating bottom-right above sheet)
            Positioned(
              left: 16,
              bottom: _currentStatus == 'new_request' ? 320 : 360,
              child: _buildFloatingCircleButton(
                icon: Icons.my_location_rounded,
                onTap: _centerOnMe,
              ),
            ),

            // 4 — Bottom Sheet content
            if (_currentStatus == 'new_request')
              _buildNewRequestSheet()
            else
              _buildMainSheet(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Main bottom sheet (offline / online states)
  // ─────────────────────────────────────────────
  Widget _buildMainSheet() {
    return DraggableScrollableSheet(
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
              // Handle
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

              // Earnings badge
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "480 ج.م اليوم",
                            style: GoogleFonts.zain(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "★ 4.9",
                      style: GoogleFonts.zain(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "  (213 طلب)",
                      style: GoogleFonts.zain(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Service categories grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Big card — حلاقة منزلية
                    Expanded(
                      child: _buildServiceCategoryBig(
                        title: "حلاقة منزلية",
                        subtitle: "نوصلك لحد البيت",
                        icon: Icons.home_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Two small cards stacked
                    Expanded(
                      child: Column(
                        children: [
                          _buildServiceCategorySmall(
                            title: "في المحل",
                            icon: Icons.store_rounded,
                          ),
                          const SizedBox(height: 10),
                          _buildServiceCategorySmall(
                            title: "عناية وتجميل",
                            icon: Icons.spa_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Search / destination bar
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
                          "أين يريد العميل الخدمة؟",
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

              // Recent addresses
              _buildRecentAddress(
                title: "شارع صلاح الدين",
                subtitle: "العمرانية، الجيزة",
                icon: Icons.access_time_rounded,
              ),
              _buildRecentAddress(
                title: "طريق القاهرة - السويس",
                subtitle: "البساتين، القاهرة",
                icon: Icons.access_time_rounded,
              ),
              _buildRecentAddress(
                title: "المعادي، القاهرة",
                subtitle: "شارع 9 — بجوار مسجد المعادي",
                icon: Icons.access_time_rounded,
              ),

              const SizedBox(height: 16),

              // Quick services row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.content_cut_rounded,
                      color: Colors.black,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "اختر خدمة سريعة",
                      style: GoogleFonts.zain(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_left_rounded,
                      color: Color(0xFF9E9E9E),
                      size: 18,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Horizontal scrollable service chips
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildServiceChip("قص شعر", Icons.content_cut_rounded, "25 ج.م"),
                    _buildServiceChip("حلاقة", Icons.brush_rounded, "15 ج.م"),
                    _buildServiceChip("تشكيل لحية", Icons.face_retouching_natural_rounded, "20 ج.م"),
                    _buildServiceChip("غسيل شعر", Icons.shower_rounded, "10 ج.م"),
                    _buildServiceChip("صبغة شعر", Icons.color_lens_outlined, "50 ج.م"),
                    _buildServiceChip("عناية بالبشرة", Icons.spa_rounded, "40 ج.م"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Online stats (only when online)
              if (_currentStatus == 'online') ...[
                const Divider(
                  color: Color(0xFFF5F5F5),
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("12 كم", "مسافة"),
                          Container(
                            width: 1,
                            height: 30,
                            color: const Color(0xFFEFEFEF),
                          ),
                          _buildStatItem("4", "حجوزات"),
                          Container(
                            width: 1,
                            height: 30,
                            color: const Color(0xFFEFEFEF),
                          ),
                          _buildStatItem("480 ج.م", "أرباح"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "في انتظار الطلبات...",
                            style: GoogleFonts.zain(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => setState(
                                () => _currentStatus = 'new_request'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "محاكاة طلب",
                                style: GoogleFonts.zain(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  New request bottom sheet (sliding up panel)
  // ─────────────────────────────────────────────
  Widget _buildNewRequestSheet() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF444444),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Color(0xFF222222),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 3,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF222222),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "أحمد سامي",
                            style: GoogleFonts.zain(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "قص + تهذيب اللحية",
                            style: GoogleFonts.zain(
                              fontSize: 13,
                              color: const Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "120",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        "ج.م",
                        style: GoogleFonts.zain(
                          fontSize: 12,
                          color: const Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "📍 المعادي، القاهرة • 1.4 كم",
                      style: GoogleFonts.zain(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "⏱️ 35 دقيقة",
                      style: GoogleFonts.zain(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          setState(() => _currentStatus = 'online'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF333333)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "رفض",
                        style: GoogleFonts.zain(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BarberTrackingScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "قبول الطلب ✓",
                        style: GoogleFonts.zain(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
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
    );
  }

  // ─────────────────────────────────────────────
  //  Reusable widgets
  // ─────────────────────────────────────────────

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
  }) {
    return Container(
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
    );
  }

  Widget _buildServiceCategorySmall({
    required String title,
    required IconData icon,
  }) {
    return Container(
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
    );
  }

  Widget _buildRecentAddress({
    required String title,
    required String subtitle,
    required IconData icon,
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
              child: Icon(icon, color: const Color(0xFF9E9E9E), size: 16),
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.zain(
            fontSize: 12,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
