// ignore_for_file: file_names

import 'package:a7la2y/screens/accses_location/LocationPermissionScreen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingItem {
  final String image;
  final String title1;
  final String title2;
  final String subtitle;

  OnboardingItem({
    required this.image,
    required this.title1,
    required this.title2,
    required this.subtitle,
  });
}

class OneScreen extends StatefulWidget {
  const OneScreen({super.key});

  @override
  State<OneScreen> createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      image: 'assets/images/10378.jpg',
      title1: 'حلاقك',
      title2: 'في كل مكان',
      subtitle: 'احجز موعدك مع اقرب حلاق لك في ثواني',
    ),
    OnboardingItem(
      image: 'assets/images/98490.jpg',
      title1: 'اختر ستايلك',
      title2: 'المناسب ليك',
      subtitle: 'تصفح أحدث القصات والصيحات العالمية بسهولة',
    ),
    OnboardingItem(
      image: 'assets/images/155079.jpg',
      title1: 'وفر وقتك',
      title2: 'واضمن مكانك',
      subtitle: 'لا مزيد من الانتظار، حلاقك في انتظارك دائماً',
    ),
  ];

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LocationPermissionScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  _pages[index].image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentIndex == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.black
                              : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const Gap(30),
                  Text(
                    _pages[_currentIndex].title1,
                    style: GoogleFonts.zain(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    _pages[_currentIndex].title2,
                    style: GoogleFonts.zain(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    _pages[_currentIndex].subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.zain(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _navigateToLogin();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentIndex == _pages.length - 1
                            ? "ابدأ الآن"
                            : "التالي",
                        style: GoogleFonts.zain(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  AnimatedOpacity(
                    opacity: _currentIndex == _pages.length - 1 ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      onPressed: _currentIndex == _pages.length - 1
                          ? null
                          : _navigateToLogin,
                      child: Text(
                        "تخطي",
                        style: GoogleFonts.zain(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
