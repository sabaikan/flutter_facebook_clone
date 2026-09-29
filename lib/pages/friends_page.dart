import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const FriendsPage({super.key, this.onOpenDrawer});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final Set<String> _confirmedRequests = {};
  final Set<String> _removedRequests = {};
  bool _addedSuggestedFriend = false;

  void _confirm(String id) {
    setState(() {
      _confirmedRequests.add(id);
    });
  }

  void _remove(String id) {
    setState(() {
      _removedRequests.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Colors.white;
    const buttonGrey = Color(0xFFE4E6EB);
    const textGrey = Color(0xFF65676B);
    const linkBlue = Color(0xFF1877F2);

    return Container(
      color: bgColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        children: [
          // ── Top Header Row ───────────────────────────────────────────────
          Row(
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
                'Teman',
                style: TextStyle(
                  color: Color(0xFF050505),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF050505), size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Filter Chips Row: Saran, Teman Anda ───────────────────────────
          Row(
            children: [
              _buildFilterChip('Saran'),
              const SizedBox(width: 8),
              _buildFilterChip('Teman Anda'),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFCED0D4), thickness: 0.6),
          const SizedBox(height: 10),

          // ── Section 1: Permintaan pertemanan ─────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Permintaan pertemanan ',
                      style: TextStyle(
                        color: Color(0xFF050505),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '4',
                      style: TextStyle(
                        color: Color(0xFFFA3E3E),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    color: linkBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Request 1: Dimas Pratama
          if (!_removedRequests.contains('dimas'))
            _buildFriendRequestItem(
              id: 'dimas',
              name: 'Dimas Pratama',
              imagePath: 'images/friend_hyam.jpg',
              mutualCount: '3 teman bersama',
              extraInfo: 'Juga di Komunitas Pengembang ID...',
            ),

          // Request 2: Nadia Safitri
          if (!_removedRequests.contains('nadia'))
            _buildFriendRequestItem(
              id: 'nadia',
              name: 'Nadia Safitri',
              isSilhouette: true,
              extraInfo: 'Juga di Desain Grafis Kreatif ID...',
            ),

          // Request 3: Budi Santoso
          if (!_removedRequests.contains('budi'))
            _buildFriendRequestItem(
              id: 'budi',
              name: 'Budi Santoso',
              isSilhouette: true,
              extraInfo: 'Tinggal di Bandung · 12 postingan baru',
            ),

          // Request 4: Siti Rahmawati
          if (!_removedRequests.contains('siti'))
            _buildFriendRequestItem(
              id: 'siti',
              name: 'Siti Rahmawati',
              imagePath: 'images/friend_fabian.jpg',
              mutualCount: '5 teman bersama',
              extraInfo: 'Alumni Universitas Indonesia · 1 th',
            ),

          const SizedBox(height: 8),
          const Divider(color: Color(0xFFCED0D4), thickness: 0.6),
          const SizedBox(height: 14),

          // ── Section 2: Orang yang mungkin Anda kenal ─────────────────────
          const Text(
            'Orang yang mungkin Anda kenal',
            style: TextStyle(
              color: Color(0xFF050505),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          // Suggested Friend: Reza Aditya Pratama
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset(
                  'images/friend_rido.jpg',
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 76,
                    height: 76,
                    color: buttonGrey,
                    child: const Icon(Icons.person, color: Color(0xFF65676B), size: 45),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reza Aditya Pratama',
                      style: TextStyle(
                        color: Color(0xFF050505),
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '6 teman bersama',
                      style: TextStyle(color: textGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Juga di Komunitas Pecinta Fotografi Nusantara...',
                      style: TextStyle(color: textGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _addedSuggestedFriend
                              ? buttonGrey
                              : const Color(0xFF1877F2),
                          foregroundColor: _addedSuggestedFriend ? const Color(0xFF050505) : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _addedSuggestedFriend = !_addedSuggestedFriend;
                          });
                        },
                        child: Text(
                          _addedSuggestedFriend ? 'Permintaan Terkirim' : 'Tambah jadi teman',
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E6EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF050505),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFriendRequestItem({
    required String id,
    required String name,
    String? imagePath,
    bool isSilhouette = false,
    String? mutualCount,
    required String extraInfo,
  }) {
    final isConfirmed = _confirmedRequests.contains(id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE4E6EB),
            ),
            child: isSilhouette || imagePath == null
                ? const Icon(Icons.person, color: Color(0xFF65676B), size: 55)
                : ClipOval(
                    child: Image.asset(
                      imagePath,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.person,
                        color: Color(0xFF65676B),
                        size: 55,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 14),

          // Details & Buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (mutualCount != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    mutualCount,
                    style: const TextStyle(color: Color(0xFF65676B), fontSize: 13),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  extraInfo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF65676B), fontSize: 13),
                ),
                const SizedBox(height: 10),

                if (isConfirmed)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Permintaan diterima',
                      style: TextStyle(color: Color(0xFF65676B), fontSize: 14),
                    ),
                  )
                else
                  Row(
                    children: [
                      // Konfirmasi Button
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1877F2),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _confirm(id),
                            child: const Text(
                              'Konfirmasi',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Hapus Button
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE4E6EB),
                              foregroundColor: const Color(0xFF050505),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _remove(id),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
