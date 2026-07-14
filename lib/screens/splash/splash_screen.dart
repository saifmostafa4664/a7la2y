import 'package:a7la2y/screens/splash/widget/CustomProgressBar.dart';
import 'package:a7la2y/screens/start/OnboardingItem.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OneScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "A7LA2Y",
              style: GoogleFonts.inter(
                fontSize: 46,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
          const Gap(8),
          Text(
            "Your favorite app for everything!",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7A7A7A),
            ),
          ),
          const Gap(16),
          const CustomProgressBar(width: 100, height: 10),
        ],
      ),
    );
  }
}
