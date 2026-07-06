import 'package:a7la2y/screens/client/barber%20serves/barber_profile_screen.dart';
import 'package:a7la2y/screens/client/barber/widegt/barber_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberListScreen extends StatefulWidget {
  const BarberListScreen({super.key});

  @override
  State<BarberListScreen> createState() => _BarberListScreenState();
}

class _BarberListScreenState extends State<BarberListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    "الكل",
    "الأعلى تقييماً",
    "متاح الآن",
    "قريب منك",
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAF9F6),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: Text(
            "حلاق في المنزل",
            style: GoogleFonts.zain(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن حلاق...',
                    hintStyle: GoogleFonts.zain(
                      color: const Color(0xFF9E9E9E),
                      fontSize: 18,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF9E9E9E),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A1A1A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: isSelected
                            ? null
                            : Border.all(color: const Color(0xFFEFEFEF)),
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
                          style: GoogleFonts.zain(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  BarberCard(
                    name: "محمد إبراهيم",
                    jobTitle: "حلاق منزلي",
                    price: "150",
                    distance: "1.2",
                    rating: "4.9",
                    reviewsCount: "213",
                    isTopRated: true,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarberProfileScreen(),
                        ),
                      );
                    },
                  ),
                  BarberCard(
                    name: "عبدالرحمن سعيد",
                    jobTitle: "مصفف شعر",
                    price: "120",
                    distance: "2.1",
                    rating: "4.8",
                    reviewsCount: "178",
                    ontap: () {},
                  ),
                  BarberCard(
                    name: "أحمد خالد",
                    jobTitle: "حلاق وذقن",
                    price: "100",
                    distance: "3.4",
                    rating: "4.7",
                    reviewsCount: "142",
                    isOnline: false,
                    ontap: () {},
                  ),
                  BarberCard(
                    name: "خالد حسن",
                    jobTitle: "حلاق منزلي",
                    price: "130",
                    distance: "4.0",
                    rating: "4.6",
                    reviewsCount: "95",
                    ontap: () {},
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
