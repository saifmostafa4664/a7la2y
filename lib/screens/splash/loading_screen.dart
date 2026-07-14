import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A simple loading screen used as a placeholder while
/// checking auth state. Does NOT auto-navigate anywhere.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A7LA2Y",
              style: GoogleFonts.inter(
                fontSize: 46,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your favorite app for everything!",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A7A7A),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
