import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../widgets/feed_post_card.dart';
import '../widgets/friend_requests_shelf.dart';
import '../widgets/meta_ai_shelf.dart';
import '../widgets/reels_shelf.dart';
import '../widgets/status_composer.dart';
import '../widgets/story_tray.dart';
import 'reel_player_page.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final List<StoryItem> _stories = const [
    StoryItem(
      id: 'story_1',
      authorName: 'Farhan Pratama',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
      storyImageUrl:
          'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=600&auto=format&fit=crop&q=80',
    ),
    StoryItem(
      id: 'story_2',
      authorName: 'Abigail Gabriela',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      storyImageUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600&auto=format&fit=crop&q=80',
    ),
    StoryItem(
      id: 'story_3',
      authorName: 'Shafa Amanda',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80',
      storyImageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600&auto=format&fit=crop&q=80',
    ),
  ];

  // Reels with real streaming video URLs
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
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      videoThumbnailUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80',
      viewCount: '620 rb tayangan',
      authorName: 'Daily Hacks ID',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
    ),
    ReelItem(
      id: 'reel_nature',
      title: 'Pesona sunrise syahdu di perbukitan yang bikin hati tenang 🍃🌄',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      videoThumbnailUrl:
          'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=600&auto=format&fit=crop&q=80',
      viewCount: '310 rb tayangan',
      authorName: 'Jelajah Alam ID',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
    ),
  ];

  final List<FriendRequestItem> _friendRequests = const [
    FriendRequestItem(
      id: 'req_1',
      name: 'Dimas Pratama',
      profileImageUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&auto=format&fit=crop&q=80',
      mutualGroup: 'Juga di Komunitas Pengembang ID...',
      mutualFriendsCount: 3,
      mutualAvatarUrls: [
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=100&auto=format&fit=crop&q=80',
      ],
    ),
    FriendRequestItem(
      id: 'req_2',
      name: 'Nadia Safitri',
      profileImageUrl:
          'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=400&auto=format&fit=crop&q=80',
      mutualGroup: 'Juga di Desain Grafis Kreatif...',
      mutualFriendsCount: 7,
      mutualAvatarUrls: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
      ],
    ),
  ];

  final List<MetaAiPromptCard> _metaAiPrompts = const [
    MetaAiPromptCard(
      title: 'Rekomendasi destinasi wisata alam tersembunyi di Indonesia',
      imageUrl:
          'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?w=600&auto=format&fit=crop&q=80',
    ),
    MetaAiPromptCard(
      title: 'Tulis ide caption kreatif dan menginspirasi untuk postingan medsos',
      imageUrl:
          'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=600&auto=format&fit=crop&q=80',
    ),
  ];

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Buat Postingan',
                        style: TextStyle(
                          color: Color(0xFF050505),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Postingan berhasil dibagikan!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F2),
                        ),
                        child: const Text('Kirim', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    autofocus: true,
                    maxLines: 4,
                    style: TextStyle(color: Color(0xFF050505), fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Apa yang Anda pikirkan?',
                      hintStyle: TextStyle(color: Color(0xFF65676B)),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openReelPlayer(ReelItem reel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReelPlayerPage(
          initialReel: reel,
          playlist: _reels,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context, listen: true);
    final userAvatar = auth.currentUser.avatarUrl;

    const feedBgColor = Color(0xFFF0F2F5);
    const separatorDivider = Divider(
      color: Color(0xFFCED0D4),
      thickness: 6,
      height: 6,
    );

    return Container(
      color: feedBgColor,
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
        },
        color: const Color(0xFF1877F2),
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 1. Status Composer Row
            StatusComposer(
              userAvatarUrl: userAvatar,
              onTap: _showCreatePostDialog,
              onPhotoTap: _showCreatePostDialog,
            ),

            const Divider(color: Color(0xFFCED0D4), height: 1),

            // 2. Stories Tray
            StoryTray(
              userAvatarUrl: userAvatar,
              stories: _stories,
              onCreateStoryTap: _showCreatePostDialog,
            ),

            separatorDivider,

            // 3. Post 1: Rian Hidayat (Status update & photo share)
            const FeedPostCard(
              id: 'post_1',
              authorName: 'Rian Hidayat',
              authorAvatarUrl:
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
              timeAgo: '1 hr',
              actionLinkText: 'Tambah jadi teman',
              caption:
                  'Alhamdulillah setelah proses riset dan kerja keras berbulan-bulan, project aplikasi terbaru kami resmi rilis hari ini! Terima kasih banyak atas doa dan dukungan kalian semua 🙏🔥',
              sharedPost: SharedPostData(
                authorName: 'Rian Hidayat',
                authorAvatarUrl:
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
                actionLinkText: 'Tambah jadi teman',
                subtitle: '1 hr · memperbarui foto sampulnya.',
                caption: 'Langkah awal untuk memulai petualangan baru.',
                imageUrl:
                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=80',
              ),
              initialLikes: 342,
              commentCount: 48,
              responderNote: 'Andi Pratama dan lainnya menanggapi',
              responderAvatarUrls: [
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
              ],
            ),

            separatorDivider,

            // 4. Reels Shelf with Real Playable Video Trigger
            ReelsShelf(
              reels: _reels,
              onReelTap: _openReelPlayer,
            ),

            separatorDivider,

            // 5. Friend Requests Shelf
            FriendRequestsShelf(
              requests: _friendRequests,
              onViewAllTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka semua permintaan pertemanan...')),
                );
              },
            ),

            separatorDivider,

            // 6. Post 2: Community photo album
            const FeedPostCard(
              id: 'post_2',
              groupName: 'Komunitas Fotografi & Traveling Indonesia',
              authorName: 'Bagas Wicaksono',
              authorAvatarUrl:
                  'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=150&auto=format&fit=crop&q=80',
              timeAgo: '1 j',
              caption:
                  'Momen golden hour sore tadi di bukit Paralayang. Kadang kita cuma butuh berhenti sejenak untuk mengagumi keindahan alam ciptaan-Nya 🌅📸 Menurut teman-teman foto mana yang sudut pandangnya paling menarik?',
              translationLink: 'Lihat terjemahan',
              gridImageUrls: [
                'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=500&auto=format&fit=crop&q=80',
                'https://images.unsplash.com/photo-1563089145-599997674d42?w=500&auto=format&fit=crop&q=80',
                'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500&auto=format&fit=crop&q=80',
                'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500&auto=format&fit=crop&q=80',
              ],
              initialLikes: 254,
              commentCount: 36,
              shareCount: 18,
            ),

            separatorDivider,

            // 7. Meta AI app Shelf
            MetaAiShelf(
              prompts: _metaAiPrompts,
              onTryTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka Meta AI generator...')),
                );
              },
            ),

            separatorDivider,

            // 8. Post 3: Coffee brew video
            const FeedPostCard(
              id: 'post_3',
              authorName: 'Fajar Ramadhan',
              authorAvatarUrl:
                  'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150&auto=format&fit=crop&q=80',
              timeAgo: '57 mnt',
              caption:
                  'Ritual pagi hari: seduh biji kopi arabika single origin secara manual. Aromanya langsung bikin mata melek dan semangat berkarya! Siapa di sini yang tim wajib ngopi pagi? ☕✨ (Tonton video lengkapnya)',
              videoUrl:
                  'https://media.w3.org/2010/05/sintel/trailer.mp4',
              singleImageUrl:
                  'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=800&auto=format&fit=crop&q=80',
              initialLikes: 185,
              commentCount: 42,
            ),

            separatorDivider,

            // 9. Post 4: Tech / Programmer community tips
            const FeedPostCard(
              id: 'post_4',
              groupName: 'Diskusi Web & Mobile Developer Indonesia',
              authorName: 'Ahmad Zulkarnain',
              authorAvatarUrl:
                  'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=150&auto=format&fit=crop&q=80',
              timeAgo: '1 hr',
              caption:
                  'Catatan buat programmer pemula: fokus bangun logika pemrograman dan pemahaman struktur data yang kuat. Sintaksis framework bisa dipelajari sambil jalan, tapi fondasi logika adalah kunci utama! Tetap konsisten ngoding ya teman-teman 💻🚀',
              singleImageUrl:
                  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&auto=format&fit=crop&q=80',
              hasAudioBadge: false,
              initialLikes: 1890,
              commentCount: 142,
              shareCount: 310,
              responderNote: 'Fauzan dan lainnya menanggapi',
              responderAvatarUrls: [
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop&q=80',
              ],
            ),

            separatorDivider,

            // 10. Post 5: Health & Lifestyle community
            const FeedPostCard(
              id: 'post_5',
              groupName: 'Tips & Pola Hidup Sehat Nusantara',
              authorName: 'Dr. Hendra Gunawan',
              authorAvatarUrl:
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80',
              timeAgo: '2 j',
              caption:
                  'Jangan remehkan pentingnya tidur 7-8 jam dan minum air putih teratur. Kesehatan adalah investasi jangka panjang paling berharga yang sering kita lupakan saat sibuk bekerja. Jaga kesehatan kalian ya! 🍎💧',
              initialLikes: 412,
              commentCount: 53,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
