import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberBookingsScreen extends StatefulWidget {
  const BarberBookingsScreen({super.key});

  @override
  State<BarberBookingsScreen> createState() => _BarberBookingsScreenState();
}

class _BarberBookingsScreenState extends State<BarberBookingsScreen> {
  String _selectedTab = 'اليوم';

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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "حجوزاتي",
                    style: GoogleFonts.zain(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "6 حجز • الاثنين 30 يونيو",
                    style: GoogleFonts.zain(
                      fontSize: 13,
                      color: const Color(0xFF7A7A7A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "200 ج.م",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  Text(
                    "مكتسب اليوم",
                    style: GoogleFonts.zain(
                      fontSize: 11,
                      color: const Color(0xFF7A7A7A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildTabItem("اليوم"),
                    _buildTabItem("القادمة"),
                    _buildTabItem("المكتملة"),
                    _buildTabItem("الملغاة"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildBookingCard(
                    name: "خالد م.",
                    service: "قص شعر",
                    time: "09:00",
                    price: "80 ج.م",
                    status: "مكتمل",
                    statusColor: const Color(0xFF2E7D32),
                    statusBg: const Color(0xFFE8F5E9),
                  ),

                  _buildBookingCard(
                    name: "محمد ع.",
                    service: "قص + لحية",
                    time: "10:30",
                    price: "120 ج.م",
                    status: "مكتمل",
                    statusColor: const Color(0xFF2E7D32),
                    statusBg: const Color(0xFFE8F5E9),
                  ),

                  _buildBookingCard(
                    name: "أحمد ر.",
                    service: "كولونيال كامل",
                    time: "12:00",
                    price: "200 ج.م",
                    status: "جاري",
                    statusColor: Colors.black,
                    statusBg: const Color(0xFFEAEAEA),
                    isCurrent: true,
                    distance: "1.2 كم",
                  ),

                  _buildBookingCard(
                    name: "يوسف ح.",
                    service: "قص + تسريح",
                    time: "14:00",
                    status: "قادم",
                    statusColor: const Color(0xFF616161),
                    statusBg: const Color(0xFFF5F5F5),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title) {
    final isSelected = _selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.zain(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                color: isSelected ? Colors.black : const Color(0xFF7A7A7A),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required String name,
    required String service,
    required String time,
    String? price,
    required String status,
    required Color statusColor,
    required Color statusBg,
    bool isCurrent = false,
    String? distance,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? Colors.black : const Color(0xFFEFEFEF),
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي: الصورة، الاسم، الوقت، والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFF5F5F5),
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                      if (isCurrent)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
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
                      Text(
                        service,
                        style: GoogleFonts.zain(
                          fontSize: 13,
                          color: const Color(0xFF7A7A7A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.zain(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // إذا كان الحجز يحتوي على سعر أو تفاصيل إضافية بالأسفل
          if (price != null || isCurrent) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFF5F5F5), height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (price != null)
                  Text(
                    price,
                    style: GoogleFonts.zain(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),

                if (isCurrent && distance != null) ...[
                  Text(
                    " $distance",
                    style: GoogleFonts.zain(
                      fontSize: 13,
                      color: const Color(0xFF7A7A7A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFFF5F5F5),
                        child: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.black,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black,
                        child: const Icon(
                          Icons.phone_enabled_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
