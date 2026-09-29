import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utils/video_playback_manager.dart';

class ReelItem {
  final String id;
  final String title;
  final String videoUrl;
  final String videoThumbnailUrl;
  final String viewCount;
  final String authorName;
  final String authorAvatarUrl;
  final String? subtitle;
  final String likesCount;
  final String commentsCount;
  final String sharesCount;
  final String savesCount;
  final bool isVerified;

  const ReelItem({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.videoThumbnailUrl,
    required this.viewCount,
    this.authorName = 'Creator Video',
    this.authorAvatarUrl = '',
    this.subtitle,
    this.likesCount = '4.383',
    this.commentsCount = '40',
    this.sharesCount = '257',
    this.savesCount = '3.345',
    this.isVerified = false,
  });
}

class ReelsShelf extends StatefulWidget {
  final List<ReelItem> reels;
  final ValueChanged<ReelItem>? onReelTap;

  const ReelsShelf({
    super.key,
    required this.reels,
    this.onReelTap,
  });

  @override
  State<ReelsShelf> createState() => _ReelsShelfState();
}

class _ReelsShelfState extends State<ReelsShelf> {
  late PageController _pageController;
  int _activeReelIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reels.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Reels Title & Emblem ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.movie_creation_rounded,
                  color: Color(0xFFE41E3F),
                  size: 26,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Reels',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Video Pendek',
                    style: TextStyle(
                      color: Color(0xFFE41E3F),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Color(0xFF65676B), size: 24),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Direct Full Vertical Video Format (NO story-like boxes!) ────
          // Plays long video format directly like IG Reels / YT Shorts embedded in feed
          SizedBox(
            height: 490,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.reels.length,
              onPageChanged: (index) {
                setState(() {
                  _activeReelIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final reel = widget.reels[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _FeedVerticalReelCard(
                    reel: reel,
                    isActive: _activeReelIndex == index,
                    onOpenFullscreen: () => widget.onReelTap?.call(reel),
                  ),
                );
              },
            ),
          ),

          // Indicator dots if multiple reels
          if (widget.reels.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.reels.length, (index) {
                  final isSelected = _activeReelIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isSelected ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1877F2) : const Color(0xFFCED0D4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Feed Vertical Reel Card (Embeds actual video player directly) ─────────────

class _FeedVerticalReelCard extends StatefulWidget {
  final ReelItem reel;
  final bool isActive;
  final VoidCallback onOpenFullscreen;

  const _FeedVerticalReelCard({
    required this.reel,
    required this.isActive,
    required this.onOpenFullscreen,
  });

  @override
  State<_FeedVerticalReelCard> createState() => _FeedVerticalReelCardState();
}

class _FeedVerticalReelCardState extends State<_FeedVerticalReelCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  bool _isLiked = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    try {
      final url = widget.reel.videoUrl;
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

      _controller?.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
        });
        _controller?.setLooping(false);
        _controller?.setVolume(_isMuted ? 0.0 : 1.0);
        if (widget.isActive) {
          VideoPlaybackManager.play(_controller);
          setState(() {
            _isPlaying = true;
          });
        }
      }).catchError((_) {
        // Handled silently
      });

      _controller?.addListener(_videoListener);
    } catch (_) {}
  }

  void _videoListener() {
    if (!mounted || _controller == null) return;
    final isPlaying = _controller!.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }
  }

  @override
  void didUpdateWidget(covariant _FeedVerticalReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive && _isInitialized && _controller != null) {
      if (widget.isActive) {
        VideoPlaybackManager.play(_controller);
        setState(() {
          _isPlaying = true;
        });
      } else {
        VideoPlaybackManager.pause(_controller);
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      VideoPlaybackManager.pause(_controller);
      _controller?.removeListener(_videoListener);
      _controller?.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isInitialized || _controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        VideoPlaybackManager.pause(_controller);
        _isPlaying = false;
      } else {
        if (_controller!.value.position >= _controller!.value.duration) {
          _controller!.seekTo(Duration.zero);
        }
        VideoPlaybackManager.play(_controller);
        _isPlaying = true;
      }
    });
  }

  void _toggleMute() {
    if (!_isInitialized || _controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Direct Vertical Video Player or Thumbnail Poster
            if (_isInitialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio > 0
                      ? _controller!.value.aspectRatio
                      : (9 / 16),
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              Center(
                child: Image.asset(
                  widget.reel.videoThumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              ),

            // 2. Dark Vignette Overlays
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black38,
                    Colors.transparent,
                    Colors.black87,
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),

            // 3. Center Play Icon ONLY when paused (Never blocks video while playing)
            if (!_isPlaying)
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),

            // 4. Top Badges & Fullscreen Expand button
            Positioned(
              top: 10,
              left: 12,
              right: 10,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_on, color: Color(0xFFF7B125), size: 14),
                        const SizedBox(width: 3),
                        Text(
                          widget.reel.viewCount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Fullscreen button
                  InkWell(
                    onTap: widget.onOpenFullscreen,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fullscreen_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 5. Right Action Sidebar (Likes, Comments, Shares, Saves, Sound)
            Positioned(
              right: 10,
              bottom: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Like
                  InkWell(
                    onTap: () => setState(() => _isLiked = !_isLiked),
                    child: Column(
                      children: [
                        Icon(
                          _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: _isLiked ? const Color(0xFF1877F2) : Colors.white,
                          size: 26,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.reel.likesCount,
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Comment
                  Column(
                    children: [
                      const Icon(Icons.mode_comment_outlined, color: Colors.white, size: 25),
                      const SizedBox(height: 2),
                      Text(
                        widget.reel.commentsCount,
                        style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Share
                  Column(
                    children: [
                      const Icon(Icons.share, color: Colors.white, size: 25),
                      const SizedBox(height: 2),
                      Text(
                        widget.reel.sharesCount,
                        style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Bookmark
                  InkWell(
                    onTap: () => setState(() => _isSaved = !_isSaved),
                    child: Column(
                      children: [
                        Icon(
                          _isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: _isSaved ? const Color(0xFFF7B125) : Colors.white,
                          size: 26,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.reel.savesCount,
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mute / Unmute
                  InkWell(
                    onTap: _toggleMute,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 6. Bottom Creator info & Caption
            Positioned(
              left: 14,
              right: 64,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Author Row
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          widget.reel.authorAvatarUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 32,
                            height: 32,
                            color: Colors.grey,
                            child: const Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.reel.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                        ),
                      ),
                      if (widget.reel.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: Color(0xFF1877F2), size: 14),
                      ],
                      const SizedBox(width: 8),
                      // "Ikuti" Follow Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Ikuti',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Caption
                  Text(
                    widget.reel.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Timeline progress bar
                  if (_isInitialized && _controller != null)
                    ValueListenableBuilder(
                      valueListenable: _controller!,
                      builder: (context, VideoPlayerValue value, child) {
                        final duration = value.duration.inMilliseconds;
                        final position = value.position.inMilliseconds;
                        final progress = duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 2.5,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
