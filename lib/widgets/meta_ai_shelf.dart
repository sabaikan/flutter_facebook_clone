import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_network_image.dart';

class MetaAiPromptCard {
  final String title;
  final String imageUrl;

  const MetaAiPromptCard({
    required this.title,
    required this.imageUrl,
  });
}

class MetaAiShelf extends StatelessWidget {
  final List<MetaAiPromptCard> prompts;
  final VoidCallback? onTryTap;
  final VoidCallback? onCloseTap;

  const MetaAiShelf({
    super.key,
    required this.prompts,
    this.onTryTap,
    this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Meta AI Logo & controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                CustomPaint(
                  size: const Size(20, 20),
                  painter: _MetaAiIconPainter(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Meta AI app',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Color(0xFF65676B), size: 20),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 14),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF65676B), size: 20),
                  onPressed: onCloseTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'Ok, coba alat AI gratis',
              style: TextStyle(
                color: Color(0xFF050505),
                fontSize: 19.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Cards Carousel
          SizedBox(
            height: 295,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: prompts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final prompt = prompts[index];
                return Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCED0D4), width: 0.8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      SizedBox(
                        height: 155,
                        width: double.infinity,
                        child: AppNetworkImage(
                          imageUrl: prompt.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Title & Coba Button
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 52,
                              child: Text(
                                prompt.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF050505),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 38,
                              child: ElevatedButton(
                                onPressed: onTryTap,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE7F3FF),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Coba',
                                  style: TextStyle(
                                    color: Color(0xFF1877F2),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Footer note
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xFFE4E6EB),
                    child: const Icon(Icons.person, color: Color(0xFF65676B), size: 14),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Bayu ada di aplikasi Meta AI.',
                    style: TextStyle(
                      color: Color(0xFF65676B),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(Icons.lock, color: Color(0xFF8A8D91), size: 12),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Hanya Anda yang dapat melihat ini, kecuali Anda membagikannya',
                    style: TextStyle(
                      color: Color(0xFF8A8D91),
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaAiIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()
      ..color = const Color(0xFF9E54E5)
      ..style = PaintingStyle.fill;

    const count = 8;
    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * math.pi) / count;
      final x = cx + math.cos(angle) * (size.width * 0.35);
      final y = cy + math.sin(angle) * (size.height * 0.35);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 4.5, height: 2.5),
        const Radius.circular(1.5),
      );
      canvas.drawRRect(rrect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
