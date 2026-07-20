import 'dart:async';
import 'package:a7la2y/services/routing_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class BarberTrackingScreen extends StatefulWidget {
  const BarberTrackingScreen({super.key});

  @override
  State<BarberTrackingScreen> createState() => _BarberTrackingScreenState();
}

class _BarberTrackingScreenState extends State<BarberTrackingScreen> {
  final MapController _mapController = MapController();

  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);

  LatLng _barberPosition = const LatLng(30.0500, 31.2300);
  final LatLng _clientPosition = const LatLng(30.0390, 31.2450);

  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _fetchRoute(_barberPosition, _clientPosition);
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

  void updateBarberPosition(LatLng newPosition) {
    setState(() {
      _barberPosition = newPosition;
    });
  }

  void _fitBounds() {
    try {
      final bounds = LatLngBounds.fromPoints([
        _barberPosition,
        _clientPosition,
      ]);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 16,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "تتبع العميل",
            style: GoogleFonts.zain(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الحلاق في الطريق إليك",
                          style: GoogleFonts.zain(
                            fontSize: 14,
                            color: const Color(0xFFD1D1D1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "وصول متوقع 10:12 ص • دقيقة واحدة",
                          style: GoogleFonts.zain(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "12",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _defaultCenter,
                            initialZoom: 14.0,
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
                            if (_routePoints.isNotEmpty)
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: _routePoints,
                                    color: const Color(0xFF1A1A1A),
                                    strokeWidth: 4.0,
                                    borderColor: Colors.black.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderStrokeWidth: 1.5,
                                  ),
                                ],
                              ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _clientPosition,
                                  width: 44,
                                  height: 44,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.14,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.home_rounded,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                Marker(
                                  point: _barberPosition,
                                  width: 44,
                                  height: 44,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.content_cut_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_isLoadingRoute)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFF5F5F5),
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "محمد إبراهيم",
                                style: GoogleFonts.zain(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "★ 4.9  •  1.8 كم",
                                style: GoogleFonts.zain(
                                  fontSize: 12,
                                  color: const Color(0xFF7A7A7A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFF5F5F5),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: const Icon(
                              Icons.phone_enabled_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStepIndicator(true, "1"),
                      Expanded(
                        child: Container(height: 2, color: Colors.black),
                      ),
                      _buildStepIndicator(true, "2"),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: const Color(0xFFEFEFEF),
                        ),
                      ),
                      _buildStepIndicator(false, "3"),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: const Color(0xFFEFEFEF),
                        ),
                      ),
                      _buildStepIndicator(false, "4"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFEFEFEF),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        "إلغاء الحجز",
                        style: GoogleFonts.zain(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildStepIndicator(bool isDone, String step) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: isDone ? Colors.black : const Color(0xFFF5F5F5),
      child: isDone
          ? const Icon(Icons.check, color: Colors.white, size: 10)
          : Text(
              step,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
    );
  }
}
