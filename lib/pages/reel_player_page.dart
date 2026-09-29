import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../widgets/reels_shelf.dart';
import '../utils/video_playback_manager.dart';

const List<ReelItem> defaultReelsList = [
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

class ReelPlayerPage extends StatefulWidget {
  final ReelItem? initialReel;
  final List<ReelItem> playlist;
  final bool isTab;
  final bool isTabActive;
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onBackToHome;

  const ReelPlayerPage({
    super.key,
    this.initialReel,
    this.playlist = const [],
    this.isTab = false,
    this.isTabActive = true,
    this.onOpenDrawer,
    this.onBackToHome,
  });

  @override
  State<ReelPlayerPage> createState() => _ReelPlayerPageState();
}

class _ReelPlayerPageState extends State<ReelPlayerPage> {
  late PageController _pageController;
  late List<ReelItem> _reels;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.playlist.isNotEmpty) {
      _reels = widget.playlist;
    } else if (widget.initialReel != null) {
      _reels = [
        widget.initialReel!,
        ...defaultReelsList.where((r) => r.id != widget.initialReel!.id),
      ];
    } else {
      _reels = defaultReelsList;
    }

    if (widget.initialReel != null) {
      _currentIndex = _reels.indexWhere((r) => r.id == widget.initialReel!.id);
      if (_currentIndex == -1) _currentIndex = 0;
    } else {
      _currentIndex = 0;
    }
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didUpdateWidget(covariant ReelPlayerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTabActive != widget.isTabActive) {
      if (!widget.isTabActive) {
        VideoPlaybackManager.stopAll();
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    VideoPlaybackManager.stopAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Vertical PageView of Reels
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _reels.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _SingleReelView(
                  key: ValueKey(_reels[index].id),
                  reel: _reels[index],
                  isCurrent: widget.isTabActive && _currentIndex == index,
                );
              },
            ),

            // Top Header: Pure Reels Top Bar (☰ Reels ... 📷 🔍 ⋯) matching screenshot
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (widget.isTab) {
                          if (widget.onOpenDrawer != null) {
                            widget.onOpenDrawer!();
                          } else {
                            Scaffold.maybeOf(context)?.openDrawer();
                          }
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else if (widget.onOpenDrawer != null) {
                          widget.onOpenDrawer!();
                        } else {
                          Scaffold.maybeOf(context)?.openDrawer();
                        }
                      },
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Reels',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 25),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white, size: 25),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.more_horiz, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single Reel View ────────────────────────────────────────────────────────

class _SingleReelView extends StatefulWidget {
  final ReelItem reel;
  final bool isCurrent;

  const _SingleReelView({
    super.key,
    required this.reel,
    required this.isCurrent,
  });

  @override
  State<_SingleReelView> createState() => _SingleReelViewState();
}

class _SingleReelViewState extends State<_SingleReelView> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  bool _showCenterControls = false; // Never block video while playing!
  bool _isLiked = false;
  bool _isSaved = false;
  late int _likes;
  late int _saves;

  bool _hasController = false;
  bool _usingFallbackAsset = false;

  @override
  void initState() {
    super.initState();
    _likes = int.tryParse(widget.reel.likesCount.replaceAll('.', '')) ?? 4383;
    _saves = int.tryParse(widget.reel.savesCount.replaceAll('.', '')) ?? 3345;
    _initVideo();
  }

  void _initVideo() {
    _startPlayer(widget.reel.videoUrl);
  }

  void _startPlayer(String url) {
    try {
      if (url.startsWith('assets/')) {
        _controller = VideoPlayerController.asset(
          url,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      } else {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }

      _hasController = true;
      _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(false); // DO NOT LOOP!
        _controller.setVolume(_isMuted ? 0.0 : 1.0);
        if (widget.isCurrent) {
          VideoPlaybackManager.play(_controller);
          setState(() {
            _isPlaying = true;
            _showCenterControls = false; // Ensure nothing blocks the screen
          });
        }
      }).catchError((_) {
        if (!mounted) return;
        if (!_usingFallbackAsset) {
          _usingFallbackAsset = true;
          _controller.dispose();
          _startPlayer('assets/videos/sample.mp4');
        }
      });

      _controller.addListener(_videoListener);
    } catch (_) {
      // In headless test environments where platform channel is not registered
    }
  }

  void _videoListener() {
    if (!mounted || !_hasController) return;
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
        if (_isPlaying) {
          _showCenterControls = false; // Hide controls immediately when playing!
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant _SingleReelView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCurrent != widget.isCurrent && _isInitialized && _hasController) {
      if (widget.isCurrent) {
        VideoPlaybackManager.play(_controller);
        setState(() {
          _isPlaying = true;
          _showCenterControls = false;
        });
      } else {
        VideoPlaybackManager.pause(_controller);
        setState(() {
          _isPlaying = false;
          _showCenterControls = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_hasController) {
      VideoPlaybackManager.pause(_controller);
      _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        VideoPlaybackManager.pause(_controller);
        _isPlaying = false;
        _showCenterControls = true; // Show [↺ 5] [▶] [↻ 5] only when paused!
      } else {
        if (_controller.value.position >= _controller.value.duration) {
          _controller.seekTo(Duration.zero);
        }
        VideoPlaybackManager.play(_controller);
        _isPlaying = true;
        _showCenterControls = false; // Hide immediately when playing!
      }
    });
  }

  void _seekRelative(int seconds) {
    if (!_isInitialized) return;
    final newPos = _controller.value.position + Duration(seconds: seconds);
    _controller.seekTo(newPos);
  }

  void _toggleMute() {
    if (!_isInitialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF242526),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            height: 380,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Komentar Reel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Color(0xFF3A3B3C)),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Tulis komentar pertama Anda!',
                      style: TextStyle(color: Color(0xFFB0B3B8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Clean solid black background (No extra manhwa background!)
          Container(color: Colors.black),

          // 2. Video Player
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio > 0
                    ? _controller.value.aspectRatio
                    : (9 / 16),
                child: VideoPlayer(_controller),
              ),
            )
          else
            Center(
              child: Image.asset(
                widget.reel.videoThumbnailUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),

          // 3. Dark Vignette Overlays
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black45,
                  Colors.transparent,
                  Colors.black87,
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // 4. Center Controls: [↺ 5]   [▶]   [↻ 5]
          // ONLY SHOWN WHEN PAUSED! When playing, it is completely hidden so NO pause icon blocks the video!
          if (!_isPlaying || _showCenterControls)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rewind 5 seconds
                  InkWell(
                    onTap: () => _seekRelative(-5),
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(28, 28),
                          painter: const _Seek5IconPainter(isForward: false),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Center Play Button
                  InkWell(
                    onTap: _togglePlayPause,
                    borderRadius: BorderRadius.circular(34),
                    child: Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Forward 5 seconds
                  InkWell(
                    onTap: () => _seekRelative(5),
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(28, 28),
                          painter: const _Seek5IconPainter(isForward: true),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 5. Right Action Sidebar (Like, Comment, Share, Bookmark, More, Volume)
          Positioned(
            right: 12,
            bottom: 48,
            child: Column(
              children: [
                // Like Button
                _buildSidebarAction(
                  icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  iconColor: _isLiked ? const Color(0xFF1877F2) : Colors.white,
                  size: 30,
                  label: _formatCount(_likes),
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _likes += _isLiked ? 1 : -1;
                    });
                  },
                ),
                const SizedBox(height: 18),

                // Comment Button
                _buildSidebarAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  size: 30,
                  label: widget.reel.commentsCount,
                  onTap: _showCommentSheet,
                ),
                const SizedBox(height: 18),

                // Share Button
                _buildSidebarAction(
                  icon: Icons.reply_rounded,
                  flipIcon: true,
                  size: 32,
                  label: widget.reel.sharesCount,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tautan Reel disalin')),
                    );
                  },
                ),
                const SizedBox(height: 18),

                // Bookmark / Save Button
                _buildSidebarAction(
                  icon: _isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                  iconColor: _isSaved ? const Color(0xFF1877F2) : Colors.white,
                  size: 30,
                  label: _formatCount(_saves),
                  onTap: () {
                    setState(() {
                      _isSaved = !_isSaved;
                      _saves += _isSaved ? 1 : -1;
                    });
                  },
                ),
                const SizedBox(height: 18),

                // Three Dots
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                ),
                const SizedBox(height: 18),

                // Sound Toggle
                InkWell(
                  onTap: _toggleMute,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Bottom Metadata & Creator Details (Matching Screenshot)
          Positioned(
            left: 14,
            right: 80,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: Creator Avatar, Name, Verified Badge, "Ikuti" Button
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF242526),
                      backgroundImage: widget.reel.authorAvatarUrl.startsWith('images/')
                          ? AssetImage(widget.reel.authorAvatarUrl) as ImageProvider
                          : (widget.reel.authorAvatarUrl.isNotEmpty
                              ? NetworkImage(widget.reel.authorAvatarUrl)
                              : null),
                      child: widget.reel.authorAvatarUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.white, size: 20)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.reel.authorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.reel.isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF1877F2),
                        size: 16,
                      ),
                    ],
                    const SizedBox(width: 12),
                    // "Ikuti" pill button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white38, width: 1.0),
                      ),
                      child: const Text(
                        'Ikuti',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Row 2: Subtitle with small bell "🔔 New for you · 6 dari 16"
                if (widget.reel.subtitle != null)
                  Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.white70, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        widget.reel.subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),

                // Row 3: Caption
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: widget.reel.title.replaceAll('... selengkapnya', ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.3,
                    ),
                    children: const [
                      TextSpan(
                        text: '... selengkapnya',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Row 4: Dynamic Time: "0:01 / 0:13"
                if (_hasController)
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _controller,
                    builder: (context, val, _) {
                      final pos = val.position;
                      final dur = val.duration.inMilliseconds > 0
                          ? val.duration
                          : const Duration(seconds: 13);
                      return Text(
                        '${_formatTime(pos)} / ${_formatTime(dur)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    },
                  )
                else
                  const Text(
                    '0:01 / 0:13',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          ),

          // 7. Bottom Scrub Bar with White Track & Circular Thumb
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: _hasController
                ? ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _controller,
                    builder: (context, val, _) {
                      final dur = val.duration.inMilliseconds > 0
                          ? val.duration
                          : const Duration(seconds: 13);
                      final pos = val.position;
                      final progress = dur.inMilliseconds > 0
                          ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                          : 0.0;
                      return GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          if (dur.inMilliseconds == 0) return;
                          final box = context.findRenderObject() as RenderBox?;
                          if (box == null) return;
                          final localX = details.localPosition.dx.clamp(0.0, box.size.width);
                          final ratio = localX / box.size.width;
                          final target = dur * ratio;
                          _controller.seekTo(target);
                        },
                        child: SizedBox(
                          height: 16,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // Background track
                              Container(
                                height: 2.5,
                                color: Colors.white24,
                              ),
                              // Played track
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  height: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                              // Drag thumb
                              Positioned(
                                left: (MediaQuery.of(context).size.width * progress - 5).clamp(
                                  0.0,
                                  MediaQuery.of(context).size.width - 10,
                                ),
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    double size = 30,
    bool flipIcon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (flipIcon)
              Transform.flip(
                flipX: true,
                child: Icon(icon, color: iconColor, size: size),
              )
            else
              Icon(icon, color: iconColor, size: size),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int number) {
    if (number >= 1000) {
      final s = (number / 1000).toStringAsFixed(3).replaceFirst('.', '.');
      return s;
    }
    return '$number';
  }
}

// ── Custom Seek 5s Painter ─────────────────────────────────────────────────

class _Seek5IconPainter extends CustomPainter {
  final bool isForward;

  const _Seek5IconPainter({this.isForward = false});

  @override
  void paint(Canvas canvas, Size size) {
    const color = Colors.white;
    final w = size.width;
    final h = size.height;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final center = Offset(w / 2, h / 2);
    final radius = w * 0.40;

    // Draw circular arc (~290 degrees)
    final rect = Rect.fromCircle(center: center, radius: radius);
    if (!isForward) {
      // Counter-clockwise
      canvas.drawArc(rect, -1.2, 5.0, false, strokePaint);
      final arrowPath = Path();
      arrowPath.moveTo(w * 0.38, h * 0.05);
      arrowPath.lineTo(w * 0.26, h * 0.18);
      arrowPath.lineTo(w * 0.42, h * 0.22);
      final arrowPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(arrowPath, arrowPaint);
    } else {
      // Clockwise
      canvas.drawArc(rect, -1.94, -5.0, false, strokePaint);
      final arrowPath = Path();
      arrowPath.moveTo(w * 0.62, h * 0.05);
      arrowPath.lineTo(w * 0.74, h * 0.18);
      arrowPath.lineTo(w * 0.58, h * 0.22);
      final arrowPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(arrowPath, arrowPaint);
    }

    // Number "5" centered
    final textPainter = TextPainter(
      text: TextSpan(
        text: '5',
        style: TextStyle(
          color: color,
          fontSize: w * 0.36,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        (w - textPainter.width) / 2,
        (h - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
