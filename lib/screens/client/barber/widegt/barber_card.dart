import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberCard extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String price;
  final String distance;
  final String rating;
  final String reviewsCount;
  final bool isTopRated;
  final bool isOnline;
  final VoidCallback ontap;

  const BarberCard({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.price,
    required this.distance,
    required this.rating,
    required this.reviewsCount,
    this.isTopRated = false,
    this.isOnline = true,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.zain(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      if (isTopRated) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "الأعلى تقييماً",
                            style: GoogleFonts.zain(
                              fontSize: 10,
                              color: const Color(0xFFFF9800),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    jobTitle,
                    style: GoogleFonts.zain(
                      fontSize: 16,
                      color: const Color(0xFF7A7A7A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Text(
                        "$price ج.م",
                        style: GoogleFonts.zain(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF9E9E9E),
                            size: 12,
                          ),
                          const Gap(2),
                          Text(
                            "$distance كم",
                            style: GoogleFonts.zain(
                              fontSize: 14,
                              color: const Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(12),
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD700),
                            size: 14,
                          ),
                          const Gap(2),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Gap(2),
                          Text(
                            "($reviewsCount)",
                            style: GoogleFonts.zain(
                              fontSize: 11,
                              color: const Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(16),
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFFB5B5B5),
                    size: 48,
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF66),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
