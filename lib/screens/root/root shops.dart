import 'package:a7la2y/screens/client/client_tracking/client_bookings_screen.dart';
import 'package:a7la2y/screens/client/home/home.dart';
import 'package:a7la2y/screens/client/menu/client_drawer_menu.dart';
import 'package:a7la2y/screens/client/wallet/barber_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainNavigationWrapper_shops extends StatefulWidget {
  const MainNavigationWrapper_shops({super.key});

  @override
  State<MainNavigationWrapper_shops> createState() =>
      _MainNavigationWrapper_shopsState();
}

class _MainNavigationWrapper_shopsState
    extends State<MainNavigationWrapper_shops> {
  int _selectedIndex = 3;

  final List<Widget> _screens = [
    const ClientDrawerMenu(),
    const clientWalletScreen(),
    const clientBookingsScreen(),

    const HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.more_horiz_rounded, 'المزيد'),
                  _buildNavItem(
                    1,
                    Icons.account_balance_wallet_outlined,
                    'المحفظة',
                  ),
                  _buildNavItem(2, Icons.calendar_today_outlined, 'حجوزاتي'),
                  _buildNavItem(3, Icons.home_filled, 'الرئيسية'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : const Color(0xFF9E9E9E),
              size: 18,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.zain(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? Colors.black : const Color(0xFF9E9E9E),
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
