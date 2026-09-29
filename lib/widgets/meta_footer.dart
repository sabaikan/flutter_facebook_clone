import 'package:flutter/material.dart';

class MetaFooter extends StatelessWidget {
  final Color color;
  final double fontSize;

  const MetaFooter({
    super.key,
    this.color = const Color(0xFF8E9BA8),
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(fontSize * 1.5, fontSize * 0.9),
          painter: _MetaInfinityPainter(color: color),
        ),
        const SizedBox(width: 5),
        Text(
          'Meta',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _MetaInfinityPainter extends CustomPainter {
  final Color color;

  _MetaInfinityPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.20
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();
    // Smooth infinity loop path
    path.moveTo(w * 0.5, h * 0.5);
    // Right loop
    path.cubicTo(
      w * 0.65, h * 0.15,
      w * 0.92, h * 0.15,
      w * 0.92, h * 0.5,
    );
    path.cubicTo(
      w * 0.92, h * 0.85,
      w * 0.65, h * 0.85,
      w * 0.5, h * 0.5,
    );
    // Left loop
    path.cubicTo(
      w * 0.35, h * 0.15,
      w * 0.08, h * 0.15,
      w * 0.08, h * 0.5,
    );
    path.cubicTo(
      w * 0.08, h * 0.85,
      w * 0.35, h * 0.85,
      w * 0.5, h * 0.5,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MetaInfinityPainter oldDelegate) =>
      oldDelegate.color != color;
}
