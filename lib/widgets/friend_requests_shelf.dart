import 'package:flutter/material.dart';
import 'app_network_image.dart';

class FriendRequestItem {
  final String id;
  final String name;
  final String profileImageUrl;
  final String mutualGroup;
  final int mutualFriendsCount;
  final List<String> mutualAvatarUrls;

  const FriendRequestItem({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.mutualGroup,
    required this.mutualFriendsCount,
    this.mutualAvatarUrls = const [],
  });
}

class FriendRequestsShelf extends StatefulWidget {
  final List<FriendRequestItem> requests;
  final VoidCallback? onViewAllTap;

  const FriendRequestsShelf({
    super.key,
    required this.requests,
    this.onViewAllTap,
  });

  @override
  State<FriendRequestsShelf> createState() => _FriendRequestsShelfState();
}

class _FriendRequestsShelfState extends State<FriendRequestsShelf> {
  final Set<String> _confirmedIds = {};
  final Set<String> _deletedIds = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  color: Color(0xFF1877F2),
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Permintaan Pertemanan',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Color(0xFF65676B)),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Horizontal Cards Carousel
          SizedBox(
            height: 335,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: widget.requests.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final req = widget.requests[index];
                final isConfirmed = _confirmedIds.contains(req.id);
                final isDeleted = _deletedIds.contains(req.id);

                return Container(
                  width: 215,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCED0D4), width: 0.8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo
                      SizedBox(
                        height: 195,
                        width: double.infinity,
                        child: AppNetworkImage(
                          imageUrl: req.profileImageUrl,
                          fit: BoxFit.cover,
                          fallbackIcon: const Icon(Icons.person, color: Color(0xFF65676B), size: 50),
                        ),
                      ),

                      // Info & Action Buttons
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              req.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF050505),
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              req.mutualGroup,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF65676B),
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Mutual friends indicator
                            Row(
                              children: [
                                if (req.mutualAvatarUrls.isNotEmpty)
                                  SizedBox(
                                    width: 32,
                                    height: 18,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          child: ClipOval(
                                            child: AppNetworkImage(
                                              imageUrl: req.mutualAvatarUrls[0],
                                              width: 18,
                                              height: 18,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if (req.mutualAvatarUrls.length > 1)
                                          Positioned(
                                            left: 12,
                                            child: ClipOval(
                                              child: AppNetworkImage(
                                                imageUrl: req.mutualAvatarUrls[1],
                                                width: 18,
                                                height: 18,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(width: 4),
                                Text(
                                  '${req.mutualFriendsCount} teman bersama',
                                  style: const TextStyle(
                                    color: Color(0xFF65676B),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Buttons
                            if (isConfirmed)
                              Container(
                                width: double.infinity,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE4E6EB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Permintaan Diterima',
                                  style: TextStyle(
                                    color: Color(0xFF45BD62),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else if (isDeleted)
                              Container(
                                width: double.infinity,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE4E6EB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Permintaan Dihapus',
                                  style: TextStyle(
                                    color: Color(0xFF65676B),
                                    fontSize: 13.5,
                                  ),
                                ),
                              )
                            else
                              Row(
                                children: [
                                  // Konfirmasi
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _confirmedIds.add(req.id);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF1877F2),
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Konfirmasi',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Hapus
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _deletedIds.add(req.id);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFE4E6EB),
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Hapus',
                                          style: TextStyle(
                                            color: Color(0xFF050505),
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
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
              },
            ),
          ),

          const SizedBox(height: 10),

          // Lihat semua >
          InkWell(
            onTap: widget.onViewAllTap,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat semua',
                    style: TextStyle(
                      color: Color(0xFF65676B),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFF65676B),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
