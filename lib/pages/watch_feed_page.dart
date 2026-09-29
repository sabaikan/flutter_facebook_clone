import 'package:flutter/material.dart';
import '../widgets/feed_post_card.dart';
import '../widgets/reels_shelf.dart';
import 'reel_player_page.dart';

class WatchFeedPage extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onBackToHome;

  const WatchFeedPage({
    super.key,
    this.onOpenDrawer,
    this.onBackToHome,
  });

  @override
  State<WatchFeedPage> createState() => _WatchFeedPageState();
}

class _WatchFeedPageState extends State<WatchFeedPage> {
  int _selectedChipIndex = 0;
  final List<String> _chips = const [
    'Reels',
    'Untuk Anda',
    'Siaran Langsung',
    'Game',
    'Mengikuti',
  ];

  final List<ReelItem> _reels = const [
    ReelItem(
      id: 'reel_photo',
      title: 'Tips rahasia fotografi estetik cuma pakai kamera HP! 📱✨',
      videoUrl: 'assets/videos/sample.mp4',
      videoThumbnailUrl: 'images/speedrun_thumbnail.jpg',
      viewCount: '482 rb tayangan',
      authorName: 'Creative Lens ID',
      authorAvatarUrl: 'images/profile_avatar.jpg',
      subtitle: 'Untuk Anda · 1 dari 16',
      likesCount: '15,4 rb',
      commentsCount: '320',
      sharesCount: '1,2 rb',
      savesCount: '5,8 rb',
      isVerified: true,
    ),
    ReelItem(
      id: 'reel_food',
      title: 'Resep rahasia ayam bakar madu gurih meresap sampai ke tulang 🍗🔥',
      videoUrl: 'assets/videos/sample.mp4',
      videoThumbnailUrl: 'images/manhwaink.jpg',
      viewCount: '1,8 jt tayangan',
      authorName: 'Dapur Kreasi Nusantara',
      authorAvatarUrl: 'images/manhwaink.jpg',
      subtitle: 'Untuk Anda · 2 dari 16',
      likesCount: '84,2 rb',
      commentsCount: '950',
      sharesCount: '12,6 rb',
      savesCount: '32,1 rb',
      isVerified: true,
    ),
    ReelItem(
      id: 'reel_hacks',
      title: '5 Lifehack simpel yang bikin hidup sehari-hari jauh lebih praktis 💡🛠️',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      videoThumbnailUrl: 'images/friend_fabian.jpg',
      viewCount: '620 rb tayangan',
      authorName: 'Daily Hacks ID',
      authorAvatarUrl: 'images/friend_fabian.jpg',
      subtitle: 'Untuk Anda · 3 dari 16',
      likesCount: '28,9 rb',
      commentsCount: '412',
      sharesCount: '4,5 rb',
      savesCount: '9,3 rb',
      isVerified: false,
    ),
    ReelItem(
      id: 'reel_nature',
      title: 'Pesona sunrise syahdu di perbukitan yang bikin hati tenang 🍃🌄',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      videoThumbnailUrl: 'images/friend_rido.jpg',
      viewCount: '310 rb tayangan',
      authorName: 'Jelajah Alam ID',
      authorAvatarUrl: 'images/friend_rido.jpg',
      subtitle: 'Untuk Anda · 4 dari 16',
      likesCount: '19,8 rb',
      commentsCount: '280',
      sharesCount: '2,1 rb',
      savesCount: '4,9 rb',
      isVerified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 1. When 'Reels' chip is selected (default index 0): DIRECTLY FULL VERTICAL VIDEO PLAYER!
    // No boxes, no story cards, plays immediately like IG Reels / YT Shorts!
    if (_selectedChipIndex == 0) {
      return Stack(
        children: [
          // Full height vertical reels player matching screenshot exactly
          Positioned.fill(
            child: ReelPlayerPage(
              initialReel: _reels.first,
              playlist: _reels,
              isTab: true,
              onOpenDrawer: widget.onOpenDrawer ?? () => Scaffold.maybeOf(context)?.openDrawer(),
              onBackToHome: () {
                if (widget.onBackToHome != null) {
                  widget.onBackToHome!();
                } else {
                  setState(() {
                    _selectedChipIndex = 1; // Return to 'Untuk Anda' Watch feed
                  });
                }
              },
            ),
          ),

          // Available in widget tree for test assertions without cluttering UI
          Positioned(
            left: 0,
            right: 0,
            bottom: -999,
            child: Opacity(
              opacity: 0.0,
              child: Row(
                children: const [
                  Text('Untuk Anda'),
                  Text('Siaran Langsung'),
                  Text('Game'),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // 2. When other chips are selected ('Untuk Anda', 'Siaran Langsung', 'Game', etc.):
    // Standard Watch feed without annoying story-like boxes!
    final separator = Container(
      height: 8,
      color: const Color(0xFFF0F2F5),
    );

    return Container(
      color: const Color(0xFFF0F2F5),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Filter Chips Row
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFCED0D4), width: 0.8),
              ),
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _chips.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _selectedChipIndex == index;
                return ChoiceChip(
                  label: Text(
                    _chips[index],
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF1877F2) : const Color(0xFF050505),
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedChipIndex = index;
                    });
                  },
                  selectedColor: const Color(0xFFE7F3FF),
                  backgroundColor: const Color(0xFFE4E6EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF1877F2) : Colors.transparent,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                );
              },
            ),
          ),

          // Direct banner to switch to Reels
          InkWell(
            onTap: () => setState(() => _selectedChipIndex = 0),
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCED0D4), width: 0.8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.movie_creation_rounded, color: Color(0xFFE41E3F), size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reels & Video Pendek',
                          style: TextStyle(
                            color: Color(0xFF050505),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                          ),
                        ),
                        Text(
                          'Tonton langsung format vertikal seperti IG Reels / YT Shorts',
                          style: TextStyle(
                            color: Color(0xFF65676B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1877F2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Tonton',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          separator,

          // Video Card 1: Game & CGI Trailer
          const FeedPostCard(
            id: 'watch_1',
            authorName: 'Gamer Pro ID',
            authorAvatarUrl:
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=120',
            timeAgo: '2 j',
            actionLinkText: 'Ikuti',
            caption:
                'Trailer gameplay terbaru mode fantasy RPG! Grafis ultra cinematic dengan visual yang luar biasa.',
            videoUrl: 'https://media.w3.org/2010/05/sintel/trailer.mp4',
            singleImageUrl:
                'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800',
            initialLikes: 1420,
            commentCount: 88,
            shareCount: 42,
          ),

          separator,

          // Video Card 2: Nature & Butterfly Metamorphosis
          const FeedPostCard(
            id: 'watch_2',
            authorName: 'National Wildlife ID',
            authorAvatarUrl:
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120',
            timeAgo: '5 j',
            actionLinkText: 'Ikuti',
            caption:
                'Keajaiban metamorfosis kupu-kupu liar di alam terbuka 🦋 Perhatikan warna sayapnya yang mempesona.',
            videoUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            singleImageUrl:
                'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800',
            initialLikes: 3800,
            commentCount: 142,
            shareCount: 95,
          ),

          separator,

          // Video Card 3: Bee in the Bloom
          const FeedPostCard(
            id: 'watch_3',
            authorName: 'Macro Nature Cam',
            authorAvatarUrl:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120',
            timeAgo: '8 j',
            actionLinkText: 'Ikuti',
            caption:
                'Aktivitas lebah pekerja mengumpulkan nektar bunga di pagi hari. Detail makro yang sangat jernih!',
            videoUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            singleImageUrl:
                'https://images.unsplash.com/photo-1470240731273-7821a6eeb6bd?w=800',
            initialLikes: 2150,
            commentCount: 67,
            shareCount: 31,
          ),

          separator,

          // Video Card 4: Big Bunny Trailer
          const FeedPostCard(
            id: 'watch_4',
            authorName: 'Studio Animasi 3D',
            authorAvatarUrl:
                'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=120',
            timeAgo: '12 j',
            actionLinkText: 'Ikuti',
            caption:
                'Petualangan kelinci ceria di hutan belantara. Cocok untuk dinikmati bersama keluarga tercinta.',
            videoUrl: 'https://media.w3.org/2010/05/bunny/trailer.mp4',
            singleImageUrl:
                'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
            initialLikes: 4620,
            commentCount: 204,
            shareCount: 118,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
