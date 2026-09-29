import 'package:flutter/material.dart';

class InstagramIcon extends StatelessWidget {
  final double size;
  final Color color;

  const InstagramIcon({
    super.key,
    this.size = 20,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _InstagramIconPainter(color: color),
    );
  }
}

class _InstagramIconPainter extends CustomPainter {
  final Color color;

  _InstagramIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.10;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final padding = strokeWidth * 0.6;

    // Outer rounded rectangle
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(padding, padding, w - padding, h - padding),
      Radius.circular(w * 0.3),
    );
    canvas.drawRRect(outerRect, strokePaint);

    // Inner circle (lens)
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.5),
      w * 0.22,
      strokePaint,
    );

    // Top-right flash dot
    canvas.drawCircle(
      Offset(w * 0.74, h * 0.26),
      w * 0.05,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _InstagramIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
