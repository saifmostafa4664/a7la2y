import 'package:flutter/material.dart';

class SimpleMapPreview extends StatelessWidget {
  final double? height;
  final double? width;
  final bool showRoute;
  final bool showMarkers;

  const SimpleMapPreview({
    super.key,
    this.height,
    this.width,
    this.showRoute = true,
    this.showMarkers = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            CustomPaint(painter: _MapPreviewPainter()),
            if (showRoute)
              Positioned(
                left: 28,
                top: 68,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            if (showMarkers) ...[
              Positioned(
                top: 32,
                right: 40,
                child: _buildMarker(
                  icon: Icons.home_rounded,
                  color: Colors.black,
                ),
              ),
              Positioned(
                bottom: 56,
                left: 36,
                child: _buildMarker(
                  icon: Icons.content_cut_rounded,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMarker({required IconData icon, required Color color}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _MapPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF7F7F7);
    final gradient = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFE0E6FE), const Color(0xFFB8C7FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Offset.zero & size, gradient);

    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.58,
        size.width * 0.72,
        size.height * 0.28,
      );

    canvas.drawPath(path, routePaint);

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.76),
      Offset(size.width * 0.88, size.height * 0.37),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.26),
      Offset(size.width * 0.72, size.height * 0.92),
      roadPaint,
    );

    final gridPaint = Paint()
      ..color = const Color(0xFFE6E6E6)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 38) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 38) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    final pinPaint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.28),
      10,
      pinPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.82),
      10,
      pinPaint,
    );

    final innerPinPaint = Paint()
      ..color = const Color(0xFFB8C7FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.28),
      4,
      innerPinPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.82),
      4,
      innerPinPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
