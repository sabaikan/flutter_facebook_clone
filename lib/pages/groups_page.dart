import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const GroupsPage({super.key, this.onOpenDrawer});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = const [
    'Untuk Anda',
    'Grup Anda',
    'Aktivitas Anda',
    'Grup Lainnya',
  ];

  bool _isLiked = false;
  int _likeCount = 961;

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF0F2F5);
    const cardBgColor = Colors.white;
    const textGrey = Color(0xFF65676B);
    const linkBlue = Color(0xFF1877F2);

    return Container(
      color: bgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Top Header Row ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 10, top: 8, bottom: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Color(0xFF050505), size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (widget.onOpenDrawer != null) {
                      widget.onOpenDrawer!();
                    } else {
                      Scaffold.maybeOf(context)?.openDrawer();
                    }
                  },
                ),
                const SizedBox(width: 14),
                const Text(
                  'Grup',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                // Create [+] button
                IconButton(
                  icon: const Icon(Icons.add_box_rounded, color: Color(0xFF050505), size: 28),
                  onPressed: () {},
                ),
                // Search button
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF050505), size: 28),
                  onPressed: () {},
                ),
                // Profile circle with 9+ badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4E6EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.settings, color: Color(0xFF050505), size: 20),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE41E3F),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: const Center(
                          child: Text(
                            '9+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Filter Chips Row ─────────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedFilterIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE7F3FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF1877F2)
                                : const Color(0xFF050505),
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFCED0D4), thickness: 0.6),
          const SizedBox(height: 6),

          // ── Section 1: Grup Anda ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grup Anda',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: linkBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Group 1: Komunitas Developer & Programmer ID
          _buildGroupItem(
            name: 'Komunitas Developer & Programmer ID',
            iconColor: const Color(0xFF2563EB),
            isPinned: true,
          ),

          // Group 2: Info Kuliner & Tempat Nongkrong Hits
          _buildGroupItem(
            name: 'Info Kuliner & Tempat Nongkrong Hits',
            imagePath: 'images/group_japeli.jpg',
            isPinned: true,
          ),

          // Group 3: Pecinta Kucing & Hewan Lucu Indonesia
          _buildGroupItem(
            name: 'Pecinta Kucing & Hewan Lucu Indonesia',
            iconColor: const Color(0xFF10B981),
            isPinned: true,
          ),

          const SizedBox(height: 12),
          Container(height: 8, color: const Color(0xFFF0F2F5)),
          const SizedBox(height: 14),

          // ── Section 2: Direkomendasikan untuk Anda ────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'Direkomendasikan untuk Anda',
              style: TextStyle(
                color: Color(0xFF050505),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Post 1 Card: Info Kuliner Cafe Review
          Container(
            color: cardBgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      // Group avatar with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'images/group_japeli.jpg',
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 44,
                                height: 44,
                                color: const Color(0xFFE4E6EB),
                                child: const Icon(Icons.group, color: Color(0xFF65676B)),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: cardBgColor, width: 1.5),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'images/friend_hyam.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Color(0xFF65676B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // Group Title & Timestamp
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Info Kuliner & Tempat Nongkrong Hits',
                              style: TextStyle(
                                color: Color(0xFF050505),
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: const [
                                Text(
                                  'Anisa Rahmawati · 1 hr · ',
                                  style: TextStyle(color: textGrey, fontSize: 12.5),
                                ),
                                Icon(Icons.public, color: textGrey, size: 12),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // More & Close icons
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: textGrey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 14),
                      IconButton(
                        icon: const Icon(Icons.close, color: textGrey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Post Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    'Spill hidden gem ramen kuah toripaitan terkental dan terenak yang pernah saya coba di Jaksel! Kuahnya bener-bener gurih gurih medok, chashu-nya tebel lembut meleleh di mulut. Wajib dateng sebelum jam makan siang biar gak antre panjang! 🍜🤤✨',
                    style: TextStyle(
                      color: Color(0xFF050505),
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Video Container: Culinary Review
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'images/group_japeli.jpg',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 220,
                        color: Colors.black,
                        child: const Center(
                          child: Icon(Icons.restaurant, color: Colors.white54, size: 50),
                        ),
                      ),
                    ),
                    // Play icon in center
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                    // Sound button on bottom right
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                // Engagement summary row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      // Emoji reactions
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1877F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.thumb_up, color: Colors.white, size: 10),
                      ),
                      const SizedBox(width: 2),
                      const Text('😆', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Text(
                        '$_likeCount',
                        style: const TextStyle(color: textGrey, fontSize: 13),
                      ),
                      const Spacer(),
                      const Text('46 komentar · 40 kali dibagikan',
                          style: TextStyle(color: textGrey, fontSize: 13)),
                    ],
                  ),
                ),

                const Divider(color: Color(0xFFCED0D4), thickness: 0.6, height: 1),

                // Like, Comment, Share action bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked;
                              _likeCount += _isLiked ? 1 : -1;
                            });
                          },
                          icon: Icon(
                            _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                            color: _isLiked ? const Color(0xFF1877F2) : textGrey,
                            size: 18,
                          ),
                          label: Text(
                            'Suka',
                            style: TextStyle(
                              color: _isLiked ? const Color(0xFF1877F2) : textGrey,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.mode_comment_outlined, color: textGrey, size: 18),
                          label: const Text('Komentar', style: TextStyle(color: textGrey, fontSize: 13.5)),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, color: textGrey, size: 18),
                          label: const Text('Bagikan', style: TextStyle(color: textGrey, fontSize: 13.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Container(height: 8, color: const Color(0xFFF0F2F5)),
          const SizedBox(height: 14),

          // Post 2 Card: Komunitas Developer & Programmer ID
          Container(
            color: cardBgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 44,
                          height: 44,
                          color: const Color(0xFF2563EB),
                          child: const Center(
                            child: Icon(Icons.code, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Komunitas Developer & Programmer ID',
                              style: TextStyle(
                                color: Color(0xFF050505),
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: const [
                                Text(
                                  'Rizky Dana Saputra · 2 jam yang lalu · ',
                                  style: TextStyle(color: textGrey, fontSize: 12.5),
                                ),
                                Icon(Icons.public, color: textGrey, size: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: textGrey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 14),
                      IconButton(
                        icon: const Icon(Icons.close, color: textGrey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    'Tips produktivitas buat developer: selalu biasakan buat clean commit message dan automated unit test sebelum push ke branch main. Proyek jadi jauh lebih rapi dan minim bug saat deployment! Siapa yang tim TDD di sini? 🚀💻',
                    style: TextStyle(
                      color: Color(0xFF050505),
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Video/Image Container: Minecraft Speedrun gameplay
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'images/speedrun_thumbnail.jpg',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 220,
                        color: Colors.black,
                        child: const Center(
                          child: Icon(Icons.videogame_asset, color: Colors.white54, size: 50),
                        ),
                      ),
                    ),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ],
                ),

                // Engagement summary row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1877F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.thumb_up, color: Colors.white, size: 10),
                      ),
                      const SizedBox(width: 2),
                      const Text('🔥', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      const Text(
                        '542',
                        style: TextStyle(color: textGrey, fontSize: 13),
                      ),
                      const Spacer(),
                      const Text('89 komentar · 31 kali dibagikan',
                          style: TextStyle(color: textGrey, fontSize: 13)),
                    ],
                  ),
                ),

                const Divider(color: Color(0xFFCED0D4), thickness: 0.6, height: 1),

                // Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_alt_outlined, color: textGrey, size: 18),
                          label: const Text('Suka', style: TextStyle(color: textGrey, fontSize: 13.5)),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.mode_comment_outlined, color: textGrey, size: 18),
                          label: const Text('Komentar', style: TextStyle(color: textGrey, fontSize: 13.5)),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, color: textGrey, size: 18),
                          label: const Text('Bagikan', style: TextStyle(color: textGrey, fontSize: 13.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildGroupItem({
    required String name,
    String? imagePath,
    Color? iconColor,
    bool isPinned = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          // Group Avatar (rounded square)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imagePath != null
                ? Image.asset(
                    imagePath,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 48,
                      height: 48,
                      color: const Color(0xFFE4E6EB),
                      child: const Icon(Icons.group, color: Color(0xFF65676B)),
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: iconColor ?? const Color(0xFFE4E6EB),
                    child: Center(
                      child: Icon(Icons.groups, color: iconColor != null ? Colors.white : const Color(0xFF65676B), size: 28),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Name and Post count with blue dot
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Text(
                      '25+ postingan baru',
                      style: TextStyle(color: Color(0xFF65676B), fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1877F2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pin Icon on right
          if (isPinned)
            Transform.rotate(
              angle: 0.5,
              child: const Icon(
                Icons.push_pin_outlined,
                color: Color(0xFF65676B),
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}
