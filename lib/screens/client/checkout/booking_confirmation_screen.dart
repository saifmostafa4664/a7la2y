import 'package:a7la2y/screens/client/checkout/booking_success_screen.dart';
import 'package:a7la2y/screens/client/checkout/widget/confirmation_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  String _selectedPayment = "cash";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                  size: 14,
                ),
                onPressed: () {},
              ),
            ),
          ),
          title: Text(
            "تأكيد الحجز",
            style: GoogleFonts.zain(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // كارت ملخص الطلب
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEFEFEF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ملخص الطلب",
                          style: GoogleFonts.zain(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF7A7A7A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAEAEA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Color(0xFFB5B5B5),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "محمد إبراهيم",
                                    style: GoogleFonts.zain(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    "حلاق منزلي • 4.9 ★",
                                    style: GoogleFonts.zain(
                                      fontSize: 12,
                                      color: const Color(0xFF9E9E9E),
                                      fontWeight: FontWeight.w600,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Color(0xFFEFEFEF), height: 1),
                        ),
                        const SummaryRow(
                          label: "قص + تهذيب اللحية",
                          value: "120 ج.م",
                        ),
                        const SummaryRow(
                          label: "رسوم الزيارة",
                          value: "مجانية",
                        ),
                        const SummaryRow(
                          label: "ضريبة القيمة المضافة",
                          value: "14 ج.م",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Color(0xFFEFEFEF), height: 1),
                        ),
                        const SummaryRow(
                          label: "الإجمالي",
                          value: "134 ج.م",
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  EditableInfoTile(
                    icon: Icons.calendar_today_outlined,
                    title: "الاثنين 30 يونيو 2026",
                    subtitle: "11:00 صباحاً",
                    onChange: () {},
                  ),
                  EditableInfoTile(
                    icon: Icons.location_on_outlined,
                    title: "12 شارع النيل، المعادي",
                    subtitle: "القاهرة، مصر",
                    onChange: () {},
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEFEFEF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "طريقة الدفع",
                          style: GoogleFonts.zain(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF7A7A7A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        PaymentMethodTile(
                          title: "كاش عند الوصول",
                          iconText: Icons.money_rounded,
                          isSelected: _selectedPayment == "cash",
                          onTap: () =>
                              setState(() => _selectedPayment = "cash"),
                        ),
                        PaymentMethodTile(
                          title: "بطاقة بنكية",
                          iconText: Icons.credit_card_rounded,
                          isSelected: _selectedPayment == "card",
                          onTap: () =>
                              setState(() => _selectedPayment = "card"),
                        ),
                        PaymentMethodTile(
                          title: "المحفظة الإلكترونية",
                          iconText: Icons.phone_android,
                          isSelected: _selectedPayment == "wallet",
                          onTap: () =>
                              setState(() => _selectedPayment = "wallet"),
                        ),
                      ],
                    ),
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
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingSuccessScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تأكيد الحجز • 134 ج.م",
                          style: GoogleFonts.zain(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.check, size: 14),
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
}
