import 'package:flutter/material.dart';

class CustomProgressBar extends StatefulWidget {
  final double width;
  final double height;

  const CustomProgressBar({super.key, this.width = 200, this.height = 24});

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _PremiumProgressPainter(
            progress: _controller.value,
            borderRadius: widget.height / 2,
          ),
        );
      },
    );
  }
}

class _PremiumProgressPainter extends CustomPainter {
  final double progress;
  final double borderRadius;

  _PremiumProgressPainter({required this.progress, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final basePaint = Paint()..color = const Color(0xFFF3F1ED);
    canvas.drawRRect(rrect, basePaint);

    canvas.save();
    canvas.clipRRect(rrect);

    final shadowPaint1 = Paint()
      ..color = const Color(0x1F000000)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(rrect.shift(const Offset(0, 3)), shadowPaint1);

    final shadowPaint2 = Paint()
      ..color = const Color(0x14000000)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    canvas.drawRRect(rrect.shift(const Offset(0, 1)), shadowPaint2);

    final progressWidth = size.width * progress;
    if (progressWidth > 0) {
      final progressRect = Rect.fromLTWH(0, 0, progressWidth, size.height);
      final progressRRect = RRect.fromRectAndRadius(
        progressRect,
        Radius.circular(borderRadius),
      );

      final progressPaint = Paint()..color = const Color(0xFF000000);
      canvas.drawRRect(progressRRect, progressPaint);

      final progressShadow = Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(progressWidth - 4, 0, 8, size.height),
          Radius.circular(borderRadius),
        ),
        progressShadow,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PremiumProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
