import 'package:a7la2y/screens/client/barber/barber_list_screen.dart';
import 'package:a7la2y/screens/client/barber_shops/barber_shops_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0EDE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF1A1A1A),
                          size: 14,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        "المعادي، القاهرة",
                        style: GoogleFonts.zain(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const Gap(4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF1A1A1A),
                        size: 15,
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFEFEFEF)),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A1A1A),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "2",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(24),
              Row(
                children: [
                  Text(
                    "صباح الخير",
                    style: GoogleFonts.zain(
                      fontSize: 18,
                      color: const Color(0xFF7A7A7A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(6),
                  const Text("👋", style: TextStyle(fontSize: 18)),
                ],
              ),
              Text(
                "ماذا تريد اليوم؟",
                style: GoogleFonts.zain(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A1A),
                  height: 1.1,
                ),
              ),
              const Gap(20),
              _buildFeatureCard(
                title: "حلاق في المنزل",
                subtitle: "في راحة بيتك",
                badgeText: "متاح الآن",
                icon: Icons.home_rounded,
                isDark: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarberListScreen(),
                    ),
                  );
                },
              ),
              const Gap(16),
              _buildFeatureCard(
                title: "صالون حلاقة",
                subtitle: "احجز مقعدك",
                badgeText: "47 صالون قريب",
                icon: Icons.content_cut_rounded,
                isDark: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarberShopsScreen(),
                    ),
                  );
                },
              ),
              const Gap(28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "زرتهم مؤخراً",
                    style: GoogleFonts.zain(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "عرض الكل",
                      style: GoogleFonts.zain(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildBarberItem(name: "أحمد خالد", rating: "4.7"),
                    const Gap(20),
                    _buildBarberItem(name: "عبدالرحمن", rating: "4.8"),
                    const Gap(20),
                    _buildBarberItem(name: "محمد إبراهيم", rating: "4.9"),
                  ],
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required IconData icon,
    required bool isDark,
    required Null Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: isDark ? null : Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.12 : 0.03),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDark ? Colors.white : Colors.black,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.12) : Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDark) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00FF66),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(6),
                    ],
                    if (!isDark) ...[
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const Gap(4),
                    ],
                    Text(
                      badgeText,
                      style: GoogleFonts.zain(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 24,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: GoogleFonts.zain(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFFA3A3A3)
                          : const Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.zain(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                      height: 1.1,
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
}

Widget _buildBarberItem({required String name, required String rating}) {
  return Column(
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFFB5B5B5),
                size: 40,
              ),
            ),
          ),
          Positioned(
            bottom: -4,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFD700),
                      size: 12,
                    ),
                    const Gap(2),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
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
      const Gap(12),
      Text(
        name,
        style: GoogleFonts.zain(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1A1A1A),
        ),
      ),
    ],
  );
}
