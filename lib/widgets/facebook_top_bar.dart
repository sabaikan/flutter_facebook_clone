import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

class FacebookTopBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onMenuTap;
  final VoidCallback? onCreateTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMessengerTap;

  const FacebookTopBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.onMenuTap,
    this.onCreateTap,
    this.onSearchTap,
    this.onMessengerTap,
  });

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context, listen: true);
    final avatarUrl = auth.currentUser.avatarUrl;

    const barColor = Colors.white;
    const activeColor = Color(0xFF1877F2);
    const inactiveColor = Color(0xFF65676B);
    const iconColor = Color(0xFF050505);

    return Container(
      color: barColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Logo & Action Icons (Exact Facebook mobile light layout)
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8, top: 4, bottom: 2),
            child: Row(
              children: [
                // Hamburger Menu icon
                IconButton(
                  icon: const Icon(Icons.menu, color: iconColor, size: 28),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  onPressed: onMenuTap,
                ),
                const SizedBox(width: 12),

                // Facebook Logo Wordmark in Classic Facebook Blue
                const Text(
                  'facebook',
                  style: TextStyle(
                    color: Color(0xFF1877F2),
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.3,
                  ),
                ),

                const Spacer(),

                // 1. Create [+] icon
                IconButton(
                  icon: const CustomPaint(
                    size: Size(26, 26),
                    painter: _CreateBoxIconPainter(color: iconColor),
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: onCreateTap,
                ),
                const SizedBox(width: 6),

                // 2. Search icon
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: iconColor,
                    size: 28,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: onSearchTap,
                ),
                const SizedBox(width: 6),

                // 3. Messenger icon
                IconButton(
                  icon: const CustomPaint(
                    size: Size(26, 26),
                    painter: _MessengerIconPainter(color: iconColor),
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: onMessengerTap,
                ),
              ],
            ),
          ),

          // Row 2: 6 Top Tabs (Enlarged icons + Blue underline indicator matching light mode)
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFCED0D4),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              children: [
                // Tab 0: Home (Solid blue house when active + Blue underline indicator)
                _buildTabItem(
                  index: 0,
                  icon: Icons.home,
                  activeIcon: Icons.home,
                  isSelected: selectedIndex == 0,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                // Tab 1: Video / Watch (Screen with play button + 9+ badge)
                _buildTabItem(
                  index: 1,
                  icon: Icons.smart_display_outlined,
                  activeIcon: Icons.smart_display,
                  isSelected: selectedIndex == 1,
                  badge: '9+',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                // Tab 2: Friends
                _buildTabItem(
                  index: 2,
                  icon: Icons.people_alt_outlined,
                  activeIcon: Icons.people_alt,
                  isSelected: selectedIndex == 2,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                // Tab 3: Groups / Profile circle
                _buildTabItem(
                  index: 3,
                  icon: Icons.account_circle_outlined,
                  activeIcon: Icons.account_circle,
                  isSelected: selectedIndex == 3,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                // Tab 4: Notifications (Bell + 9 badge)
                _buildTabItem(
                  index: 4,
                  icon: Icons.notifications_none_rounded,
                  activeIcon: Icons.notifications_rounded,
                  isSelected: selectedIndex == 4,
                  badge: '9',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                // Tab 5: Menu / Profile Avatar with small circle outline matching screenshot
                _buildTabItem(
                  index: 5,
                  icon: Icons.account_circle_outlined,
                  customWidget: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedIndex == 5 ? activeColor : const Color(0xFFCED0D4),
                        width: 1.8,
                      ),
                    ),
                    child: ClipOval(
                      child: avatarUrl.isNotEmpty
                          ? Image.asset(
                              avatarUrl,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 24,
                                height: 24,
                                color: const Color(0xFFE4E6EB),
                                child: const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Color(0xFF8A8D91),
                                ),
                              ),
                            )
                          : Container(
                              width: 24,
                              height: 24,
                              color: const Color(0xFFE4E6EB),
                              child: const Icon(
                                Icons.person,
                                size: 16,
                                color: Color(0xFF8A8D91),
                              ),
                            ),
                    ),
                  ),
                  isSelected: selectedIndex == 5,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    IconData? activeIcon,
    Widget? customWidget,
    required bool isSelected,
    String? badge,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? activeColor : Colors.transparent,
                width: 3.2,
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (customWidget != null)
                customWidget
              else
                Icon(
                  isSelected ? (activeIcon ?? icon) : icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 29,
                ),
              if (badge != null)
                Positioned(
                  top: 3,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE41E3F),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Center(
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
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

// ── Custom Create [+] Icon Painter ──────────────────────────────────────────

class _CreateBoxIconPainter extends CustomPainter {
  final Color color;
  const _CreateBoxIconPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Rounded rectangle box
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, w - 4, h - 4),
      const Radius.circular(7),
    );
    canvas.drawRRect(rrect, strokePaint);

    // Plus sign in center
    canvas.drawLine(
      Offset(w * 0.28, h * 0.5),
      Offset(w * 0.72, h * 0.5),
      strokePaint,
    );
    canvas.drawLine(
      Offset(w * 0.5, h * 0.28),
      Offset(w * 0.5, h * 0.72),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Custom Messenger Icon Painter ──────────────────────────────────────────

class _MessengerIconPainter extends CustomPainter {
  final Color color;
  const _MessengerIconPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw speech bubble
    final bubble = Path();
    bubble.addOval(Rect.fromLTWH(0, 0, w, h * 0.88));
    // Tail on bottom left
    bubble.moveTo(w * 0.16, h * 0.70);
    bubble.lineTo(w * 0.04, h * 0.96);
    bubble.lineTo(w * 0.36, h * 0.84);
    bubble.close();

    // Lightning bolt in center
    final bolt = Path();
    bolt.moveTo(w * 0.63, h * 0.22);
    bolt.lineTo(w * 0.35, h * 0.50);
    bolt.lineTo(w * 0.48, h * 0.50);
    bolt.lineTo(w * 0.37, h * 0.70);
    bolt.lineTo(w * 0.65, h * 0.42);
    bolt.lineTo(w * 0.52, h * 0.42);
    bolt.close();

    // Cut lightning bolt out of the filled speech bubble
    final finalPath = Path.combine(PathOperation.difference, bubble, bolt);
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
