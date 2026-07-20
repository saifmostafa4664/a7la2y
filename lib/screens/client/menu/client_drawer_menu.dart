import 'package:a7la2y/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientDrawerMenu extends StatelessWidget {
  const ClientDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFF5F5F5),
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "يوسف محمد",
                          style: GoogleFonts.zain(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: Color(0xFFF5F5F5), height: 1),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDrawerItem(
                    Icons.person_outline_rounded,
                    "تعديل الحساب الشخصي",
                    () {},
                  ),
                  _buildDrawerItem(
                    Icons.account_balance_wallet_outlined,
                    "المحفظة والأرباح",
                    () {},
                  ),
                  _buildDrawerItem(
                    Icons.history_rounded,
                    "سجل العمليات المكتملة",
                    () {},
                  ),
                  _buildDrawerItem(
                    Icons.star_border_rounded,
                    "تقييمات العملاء",
                    () {},
                  ),
                  _buildDrawerItem(
                    Icons.notifications_none_rounded,
                    "إعدادات التنبيهات",
                    () {},
                  ),
                  _buildDrawerItem(
                    Icons.g_translate_rounded,
                    "اللغة (العربية)",
                    () {},
                  ),
                  _buildDrawerItem(
                    Icons.info_outline_rounded,
                    "الدعم الفني والمساعدة",
                    () {},
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: Color(0xFFF5F5F5), height: 1),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildDrawerItem(Icons.logout_rounded, "تسجيل الخروج", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }, isLogout: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : Colors.black,
        size: 20,
      ),
      title: Text(
        title,
        style: GoogleFonts.zain(
          fontSize: 15,
          fontWeight: isLogout ? FontWeight.w900 : FontWeight.bold,
          color: isLogout ? Colors.redAccent : Colors.black,
        ),
      ),
      trailing: isLogout
          ? null
          : const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFCCCCCC),
              size: 12,
            ),
    );
  }
}
