import 'package:a7la2y/screens/client/barber%20serves/widget/review_card.dart';
import 'package:a7la2y/screens/client/barber%20serves/widget/service_card.dart';
import 'package:a7la2y/screens/client/calendar/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberProfileScreen extends StatefulWidget {
  const BarberProfileScreen({super.key});

  @override
  State<BarberProfileScreen> createState() => _BarberProfileScreenState();
}

class _BarberProfileScreenState extends State<BarberProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 240,
                    pinned: true,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.4),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.4),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: const Color.fromARGB(255, 2, 2, 1)),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFD700),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "4.9 (213 تقييم)",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "محمد إبراهيم",
                                style: GoogleFonts.zain(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00FF66),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "متاح الآن",
                                      style: GoogleFonts.zain(
                                        fontSize: 10,
                                        color: const Color(0xFF00CC52),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "حلاق منزلي • المعادي، القاهرة",
                            style: GoogleFonts.zain(
                              fontSize: 14,
                              color: const Color(0xFF7A7A7A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                Icons.star_outline_rounded,
                                "213",
                                "حجز مكتمل",
                              ),
                              _buildStatItem(
                                Icons.access_time_rounded,
                                "30-75",
                                "دقيقة",
                              ),
                              _buildStatItem(
                                Icons.verified_outlined,
                                "موثّق",
                                "من المنصة",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicatorColor: const Color.fromARGB(255, 6, 6, 6),
                        indicatorWeight: 3,
                        labelColor: const Color.fromARGB(255, 3, 3, 3),
                        unselectedLabelColor: const Color(0xFF9E9E9E),
                        labelStyle: GoogleFonts.zain(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                        unselectedLabelStyle: GoogleFonts.zain(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        tabs: const [
                          Tab(text: "التقييمات"),
                          Tab(text: "أعمالي"),
                          Tab(text: "الخدمات"),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    children: const [
                      ReviewCard(
                        userName: "عبدالله م.",
                        userInitial: "ع",
                        date: "منذ يومين",
                        rating: 5,
                        comment: "حلاق محترف جداً، نظيف ومنظم، شغل فوق العادة.",
                      ),
                      ReviewCard(
                        userName: "أحمد س.",
                        userInitial: "أ",
                        date: "منذ أسبوع",
                        rating: 5,
                        comment:
                            "التزام تام بالمواعيد وقصّة ممتازة جداً، هتعامل معاه دايماً.",
                      ),
                    ],
                  ),
                  GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 188, 188, 188),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    children: [
                      ServiceCard(
                        title: "قص الشعر",
                        duration: "30",
                        price: "80",
                        onBookPressed: () {},
                      ),
                      ServiceCard(
                        title: "قص + تهذيب اللحية",
                        duration: "45",
                        price: "120",
                        onBookPressed: () {},
                      ),
                      ServiceCard(
                        title: "قص + غسيل + تصفيف",
                        duration: "50",
                        price: "150",
                        onBookPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "احجز الآن",
                          style: GoogleFonts.zain(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 0, 0, 0), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.zain(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.1,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.zain(
            fontSize: 10,
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
