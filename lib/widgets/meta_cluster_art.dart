import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MetaClusterArt extends StatelessWidget {
  final double width;
  final double height;

  const MetaClusterArt({
    super.key,
    this.width = double.infinity,
    this.height = 230,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: SizedBox(
          width: 330,
          height: 220,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 1. Purple radial dots (top left)
              Positioned(
                left: 90,
                top: 10,
                child: CustomPaint(
                  size: const Size(42, 42),
                  painter: _PurpleStarburstPainter(),
                ),
              ),

              // 2. Silver crescent ring (bottom left)
              Positioned(
                left: 36,
                bottom: 24,
                child: CustomPaint(
                  size: const Size(48, 48),
                  painter: _SilverCrescentPainter(),
                ),
              ),

              // 3. Threads badge (top right)
              Positioned(
                right: 28,
                top: 14,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2733),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: _ThreadsLogoPainter(),
                    ),
                  ),
                ),
              ),

              // 4. Central 3D Meta Logo Ribbon
              Positioned(
                top: 40,
                child: CustomPaint(
                  size: const Size(130, 78),
                  painter: _Meta3DRibbonPainter(),
                ),
              ),

              // 5. Facebook blue sphere (left)
              Positioned(
                left: 4,
                top: 28,
                child: Transform.rotate(
                  angle: -0.15,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0866FF).withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'images/facebook_logo.svg',
                      width: 76,
                      height: 76,
                    ),
                  ),
                ),
              ),

              // 6. Instagram badge (bottom right)
              Positioned(
                right: 18,
                bottom: 12,
                child: Transform.rotate(
                  angle: 0.12,
                  child: Container(
                    width: 66,
                    height: 66,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const RadialGradient(
                        center: Alignment(-0.8, 1.2),
                        radius: 1.5,
                        colors: [
                          Color(0xFFFFD521),
                          Color(0xFFF50000),
                          Color(0xFFB900B4),
                          Color(0xFF5A00CB),
                        ],
                        stops: [0.0, 0.35, 0.65, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB900B4).withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: _InstagramGlyphPainter(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Painters for Cluster Art ──────────────────────────────────────────────

class _PurpleStarburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()
      ..color = const Color(0xFFC346DB)
      ..style = PaintingStyle.fill;

    const count = 8;
    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * math.pi) / count;
      final x = cx + math.cos(angle) * (size.width * 0.38);
      final y = cy + math.sin(angle) * (size.height * 0.38);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 8, height: 4),
        const Radius.circular(2),
      );
      canvas.drawRRect(rrect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SilverCrescentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.22;
    final paint = Paint()
      ..color = const Color(0xFFD3D8DF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: Offset(size.width * 0.5, size.height * 0.5),
      radius: (size.width - strokeWidth) * 0.5,
    );

    canvas.drawArc(rect, math.pi * 0.4, math.pi * 1.3, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ThreadsLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.34;

    final path = Path();
    // Inner '@' spiral
    path.arcTo(
      Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.55),
      -math.pi * 0.5,
      math.pi * 1.8,
      false,
    );
    // Outer wrap
    path.arcTo(
      Rect.fromCircle(center: Offset(cx, cy + 1), radius: r),
      math.pi * 0.7,
      math.pi * 1.6,
      false,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InstagramGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.28),
    );
    canvas.drawRRect(bodyRect, strokePaint);

    // Lens
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.24, strokePaint);

    // Flash
    canvas.drawCircle(Offset(w * 0.75, h * 0.25), w * 0.06, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Meta3DRibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final ribbonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.26
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 3D blue gradient shader
    ribbonPaint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF5AB2FF),
        Color(0xFF007DFE),
        Color(0xFF0058C9),
        Color(0xFF007DFE),
      ],
      stops: [0.0, 0.45, 0.8, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final path = Path();
    // Smooth 3D infinity ribbon loop
    path.moveTo(w * 0.5, h * 0.5);
    // Right loop
    path.cubicTo(
      w * 0.68, h * 0.05,
      w * 0.95, h * 0.05,
      w * 0.95, h * 0.5,
    );
    path.cubicTo(
      w * 0.95, h * 0.95,
      w * 0.68, h * 0.95,
      w * 0.5, h * 0.5,
    );
    // Left loop
    path.cubicTo(
      w * 0.32, h * 0.05,
      w * 0.05, h * 0.05,
      w * 0.05, h * 0.5,
    );
    path.cubicTo(
      w * 0.05, h * 0.95,
      w * 0.32, h * 0.95,
      w * 0.5, h * 0.5,
    );

    // Subtle 3D drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFF004CB3).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.26
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, ribbonPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
