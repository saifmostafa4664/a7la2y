// ignore: unnecessary_import
import 'dart:ui';

import 'package:a7la2y/screens/auth/login/login_screen.dart';
import 'package:a7la2y/screens/accses_location/widget/minimal_map_background.dart';
import 'package:a7la2y/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isLoading = false;

  Future<void> _handleAllowLocation() async {
    setState(() => _isLoading = true);
    final granted = await LocationService.requestLocationPermission();
    if (!mounted) return;

    if (granted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لم يتم منح الإذن. يمكنك السماح لاحقًا من الإعدادات.'),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Gap(40),
            const MinimalMapBackground(size: 250),
            const Gap(40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(children: [
                 
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    "هل نستخدم موقعك؟",
                    style: GoogleFonts.zain(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(12),
                  Text(
                    "نحتاج لموقعك لعرض الحلاقين والمحلات والقريبة منك",
                    style: GoogleFonts.zain(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A7A7A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAllowLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "السماح بالوصول",
                              style: GoogleFonts.zain(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const Gap(12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "ليس الآن",
                      style: GoogleFonts.zain(
                        fontSize: 16,
                        color: const Color(0xFF7A7A7A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
