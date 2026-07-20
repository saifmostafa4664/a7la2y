import 'package:a7la2y/screens/client/barber/barber_list_screen.dart';
import 'package:a7la2y/screens/client/barber_shop_details/barber_shop_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberShopsScreen extends StatefulWidget {
  const BarberShopsScreen({super.key});

  @override
  State<BarberShopsScreen> createState() => _BarberShopsScreenState();
}

class _BarberShopsScreenState extends State<BarberShopsScreen> {
  String _selectedFilter = 'الأقرب إليك';

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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "المحلات",
            style: GoogleFonts.zain(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  "01",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF7A7A7A),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "ابحث عن محل حلاقة",
                                hintStyle: GoogleFonts.zain(
                                  fontSize: 14,
                                  color: const Color(0xFF9E9E9E),
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildFilterChip("الأقرب إليك"),
                  _buildFilterChip("الأعلى تقييماً"),
                  _buildFilterChip("الأكثر حجزاً"),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildShopCard(
                    name: "The Classic Hub",
                    rating: "4.8",
                    reviews: "320",
                    distance: "1.5 كم",
                    status: "متاح الآن",
                    price: "40 - 120 ج.م",
                    to: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarberShopDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildShopCard(
                    name: "Gentlemen's House",
                    rating: "4.7",
                    reviews: "280",
                    distance: "2.3 كم",
                    status: "متاح الآن",
                    price: "60 - 250 ج.م",
                    to: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarberListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildShopCard(
                    name: "Elite Barbers",
                    rating: "4.9",
                    reviews: "410",
                    distance: "3.1 كم",
                    status: "متاح الآن",
                    price: "70 - 300 ج.م",
                  ),
                  _buildShopCard(
                    name: "Royal Cuts",
                    rating: "4.6",
                    reviews: "190",
                    distance: "4.0 كم",
                    status: "متاح الآن",
                    price: "50 - 200 ج.م",
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String title) {
    final isSelected = _selectedFilter == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = title),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFEFEFEF),
            width: 1.5,
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.zain(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF7A7A7A),
          ),
        ),
      ),
    );
  }

  Widget _buildShopCard({
    required String name,
    required String rating,
    required String reviews,
    required String distance,
    required String status,
    required String price,
    VoidCallback? to,
  }) {
    return GestureDetector(
      onTap: to,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: to,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.storefront_rounded,
                    color: Color(0xFFCCCCCC),
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.zain(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "($reviews)",
                        style: GoogleFonts.zain(
                          fontSize: 12,
                          color: const Color(0xFF7A7A7A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status,
                    style: GoogleFonts.zain(
                      fontSize: 12,
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  distance,
                  style: GoogleFonts.zain(
                    fontSize: 12,
                    color: const Color(0xFF7A7A7A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  price,
                  style: GoogleFonts.zain(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
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
