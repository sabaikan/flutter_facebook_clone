import 'dart:math' as math;
import 'package:flutter/material.dart';

class IntelectaAvatar extends StatelessWidget {
  final double size;

  const IntelectaAvatar({
    super.key,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(
          color: const Color(0xFF1E2630),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Upward light beam flare painter
            CustomPaint(
              size: Size(size, size),
              painter: _IntelectaLogoPainter(),
            ),

            // Text "INTELECTA" at bottom of the circle
            Positioned(
              bottom: size * 0.22,
              child: const Text(
                'INTELECTA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntelectaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.45; // Center of diamond symbol

    // 1. Upward glowing beam flare
    final beamPath = Path();
    final beamTopWidth = size.width * 0.26;
    final beamBottomWidth = size.width * 0.08;

    beamPath.moveTo(cx - beamTopWidth / 2, size.height * 0.10);
    beamPath.lineTo(cx + beamTopWidth / 2, size.height * 0.10);
    beamPath.lineTo(cx + beamBottomWidth / 2, cy - size.width * 0.10);
    beamPath.lineTo(cx - beamBottomWidth / 2, cy - size.width * 0.10);
    beamPath.close();

    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.06),
          Colors.white.withValues(alpha: 0.28),
          Colors.white.withValues(alpha: 0.65),
        ],
        stops: const [0.0, 0.35, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, size.height * 0.10, size.width, cy - size.height * 0.10));

    canvas.drawPath(beamPath, beamPaint);

    // 2. Soft horizontal glow near beam base
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy - 10), radius: size.width * 0.18));

    canvas.drawCircle(Offset(cx, cy - 10), size.width * 0.18, glowPaint);

    // 3. Diamonds (outer and inner concentric rotated squares)
    final diamondOuterSize = size.width * 0.20;
    final diamondInnerSize = size.width * 0.13;

    final outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeJoin = StrokeJoin.miter;

    final innerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.miter;

    // Draw outer diamond
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(math.pi / 4);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: diamondOuterSize,
        height: diamondOuterSize,
      ),
      outerPaint,
    );
    // Draw inner diamond
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: diamondInnerSize,
        height: diamondInnerSize,
      ),
      innerPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
