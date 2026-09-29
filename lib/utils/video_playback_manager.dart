import 'package:video_player/video_player.dart';

class VideoPlaybackManager {
  static VideoPlayerController? _activeController;

  static void play(VideoPlayerController? controller) {
    if (controller == null) return;
    if (_activeController != null && _activeController != controller) {
      try {
        _activeController?.pause();
      } catch (_) {}
    }
    _activeController = controller;
    try {
      controller.setLooping(false);
      controller.play();
    } catch (_) {}
  }

  static void pause(VideoPlayerController? controller) {
    if (controller == null) return;
    try {
      controller.pause();
    } catch (_) {}
    if (_activeController == controller) {
      _activeController = null;
    }
  }

  static void stopAll() {
    try {
      _activeController?.pause();
    } catch (_) {}
    _activeController = null;
  }
}
