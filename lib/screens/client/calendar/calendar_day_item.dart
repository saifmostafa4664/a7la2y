import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarDayItem extends StatelessWidget {
  final String dayName;
  final String dayNumber;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const CalendarDayItem({
    super.key,
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 54,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Opacity(
          opacity: isDisabled ? 0.3 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dayName,
                style: GoogleFonts.zain(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF7A7A7A),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dayNumber,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: isSelected ? Colors.white : Colors.black,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
