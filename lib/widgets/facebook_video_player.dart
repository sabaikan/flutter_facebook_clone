import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utils/video_playback_manager.dart';

class FacebookVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? posterImageUrl;
  final bool autoPlay;
  final bool loop;
  final bool showControls;
  final double? aspectRatio;
  final VoidCallback? onFullScreenTap;

  const FacebookVideoPlayer({
    super.key,
    required this.videoUrl,
    this.posterImageUrl,
    this.autoPlay = true,
    this.loop = false,
    this.showControls = true,
    this.aspectRatio,
    this.onFullScreenTap,
  });

  @override
  State<FacebookVideoPlayer> createState() => _FacebookVideoPlayerState();
}

class _FacebookVideoPlayerState extends State<FacebookVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showOverlay = false; // Hidden while playing to never block video
  bool _usingFallbackAsset = false;

  @override
  void initState() {
    super.initState();
    _startPlayer(widget.videoUrl);
  }

  void _startPlayer(String url) {
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

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
        _hasError = false;
      });
      _controller.setLooping(false); // DO NOT LOOP!
      if (widget.autoPlay) {
        _controller.setVolume(_isMuted ? 0.0 : 1.0);
        VideoPlaybackManager.play(_controller);
        setState(() {
          _isPlaying = true;
          _showOverlay = false; // Ensure center button is hidden while playing
        });
      }
    }).catchError((_) {
      if (!mounted) return;
      // Fallback to local asset if network URL fails
      if (!_usingFallbackAsset) {
        _usingFallbackAsset = true;
        _controller.dispose();
        _startPlayer('assets/videos/sample.mp4');
      } else {
        setState(() {
          _hasError = true;
        });
      }
    });

    _controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    if (!mounted) return;
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
        // When playing, never block the screen with an icon
        if (_isPlaying) {
          _showOverlay = false;
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant FacebookVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.removeListener(_controllerListener);
      _controller.dispose();
      _isInitialized = false;
      _hasError = false;
      _usingFallbackAsset = false;
      _startPlayer(widget.videoUrl);
    }
  }

  @override
  void dispose() {
    VideoPlaybackManager.pause(_controller);
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        VideoPlaybackManager.pause(_controller);
        _isPlaying = false;
        _showOverlay = true; // Show play icon only when paused
      } else {
        if (_controller.value.position >= _controller.value.duration) {
          _controller.seekTo(Duration.zero);
        }
        VideoPlaybackManager.play(_controller);
        _isPlaying = true;
        _showOverlay = false; // Hide immediately when playing
      }
    });
  }

  void _toggleMute() {
    if (!_isInitialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: const Color(0xFF18191A),
        height: 240,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFB0B3B8), size: 40),
              const SizedBox(height: 8),
              const Text(
                'Gagal memuat video',
                style: TextStyle(color: Color(0xFFB0B3B8), fontSize: 13.5),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _isInitialized = false;
                    _usingFallbackAsset = false;
                  });
                  _startPlayer(widget.videoUrl);
                },
                child: const Text('Coba lagi', style: TextStyle(color: Color(0xFF1877F2))),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: const Color(0xFF18191A),
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            if (widget.posterImageUrl != null)
              Image.network(
                widget.posterImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: const Color(0xFF242526)),
              ),
            Container(color: Colors.black45),
            const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white70,
                size: 48,
              ),
            ),
          ],
        ),
      );
    }

    final playerRatio = widget.aspectRatio ?? _controller.value.aspectRatio;

    return GestureDetector(
      onTap: _togglePlayPause,
      child: AspectRatio(
        aspectRatio: playerRatio > 0 ? playerRatio : (16 / 9),
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),

            // Center Play Icon - ONLY shown when PAUSED, NEVER blocks while playing
            if (!_isPlaying || _showOverlay)
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

            // Bottom Progress bar, Time, Mute & Fullscreen
            if (widget.showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Color(0xFF1877F2),
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.white12,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (context, VideoPlayerValue value, _) {
                              final position = _formatDuration(value.position);
                              final duration = _formatDuration(value.duration);
                              return Text(
                                '$position / $duration',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                          const Spacer(),
                          // Mute Toggle
                          InkWell(
                            onTap: _toggleMute,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Fullscreen Button
                          if (widget.onFullScreenTap != null)
                            InkWell(
                              onTap: widget.onFullScreenTap,
                              borderRadius: BorderRadius.circular(16),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
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
