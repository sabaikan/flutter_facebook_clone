import 'package:flutter/material.dart';
import 'app_network_image.dart';
import 'facebook_video_player.dart';

class SharedPostData {
  final String authorName;
  final String authorAvatarUrl;
  final String subtitle;
  final String? caption;
  final String? imageUrl;
  final String? videoUrl;
  final bool isVerified;
  final String? actionLinkText;

  const SharedPostData({
    required this.authorName,
    required this.authorAvatarUrl,
    required this.subtitle,
    this.caption,
    this.imageUrl,
    this.videoUrl,
    this.isVerified = false,
    this.actionLinkText,
  });
}

class FeedPostCard extends StatefulWidget {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String timeAgo;
  final String? groupName;
  final String? actionLinkText;
  final String? caption;
  final String? translationLink;
  final String? singleImageUrl;
  final String? videoUrl;
  final List<String> gridImageUrls;
  final SharedPostData? sharedPost;
  final int initialLikes;
  final int commentCount;
  final int? shareCount;
  final String? responderNote;
  final List<String> responderAvatarUrls;
  final bool hasAudioBadge;

  const FeedPostCard({
    super.key,
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.timeAgo,
    this.groupName,
    this.actionLinkText,
    this.caption,
    this.translationLink,
    this.singleImageUrl,
    this.videoUrl,
    this.gridImageUrls = const [],
    this.sharedPost,
    this.initialLikes = 0,
    this.commentCount = 0,
    this.shareCount,
    this.responderNote,
    this.responderAvatarUrls = const [],
    this.hasAudioBadge = false,
  });

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard> {
  late bool _isLiked;
  late int _likesCount;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likesCount = widget.initialLikes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
  }

  void _showCommentSheet() {
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
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Komentar',
                    style: TextStyle(
                      color: Color(0xFF050505),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Color(0xFFCED0D4)),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Belum ada komentar terbaru.',
                        style: TextStyle(color: Color(0xFF65676B)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Color(0xFF050505)),
                          decoration: InputDecoration(
                            hintText: 'Tulis komentar...',
                            hintStyle: const TextStyle(color: Color(0xFF65676B)),
                            filled: true,
                            fillColor: const Color(0xFFF0F2F5),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF1877F2)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showShareModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.share, color: Color(0xFF050505), size: 24),
                  title: const Text('Bagikan Sekarang (Publik)', style: TextStyle(color: Color(0xFF050505))),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Berhasil dibagikan ke linimasa Anda')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.send, color: Color(0xFF050505), size: 24),
                  title: const Text('Kirim di Messenger', style: TextStyle(color: Color(0xFF050505))),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.link, color: Color(0xFF050505), size: 24),
                  title: const Text('Salin tautan', style: TextStyle(color: Color(0xFF050505))),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      final double formatted = number / 1000;
      return '${formatted.toStringAsFixed(1).replaceAll('.', ',')}RB';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Colors.white;
    const textGrey = Color(0xFF65676B);

    return Container(
      color: cardBgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Post Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                ClipOval(
                  child: AppNetworkImage(
                    imageUrl: widget.authorAvatarUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),

                // Name & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author / Group Name Row
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            widget.groupName ?? widget.authorName,
                            style: const TextStyle(
                              color: Color(0xFF050505),
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.actionLinkText != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '· ${widget.actionLinkText!}',
                              style: const TextStyle(
                                color: Color(0xFF1877F2),
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (widget.groupName != null) ...[
                            Text(
                              '${widget.authorName} · ',
                              style: const TextStyle(
                                color: textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          Text(
                            widget.timeAgo,
                            style: const TextStyle(
                              color: textGrey,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.public,
                            color: textGrey,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right controls: more and close (larger size 24)
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: textGrey, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                ),
                const SizedBox(width: 14),
                IconButton(
                  icon: const Icon(Icons.close, color: textGrey, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 2. Caption Text
          if (widget.caption != null && widget.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                widget.caption!,
                style: const TextStyle(
                  color: Color(0xFF050505),
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
            ),

          // Translation link
          if (widget.translationLink != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 6),
              child: Text(
                widget.translationLink!,
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 13,
                ),
              ),
            ),

          // 3. Post Content / Media (with Real Playable Video Support)
          if (widget.videoUrl != null)
            FacebookVideoPlayer(
              videoUrl: widget.videoUrl!,
              posterImageUrl: widget.singleImageUrl,
              autoPlay: true,
              loop: false,
              showControls: true,
            )
          else if (widget.sharedPost != null)
            _buildSharedPost(widget.sharedPost!)
          else if (widget.gridImageUrls.isNotEmpty)
            _buildGridImages(widget.gridImageUrls)
          else if (widget.singleImageUrl != null)
            _buildSingleImage(widget.singleImageUrl!),

          // 4. Modern Post Action Bar (Exact match to Screenshots 2, 4, 5)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                // Like Button & Counter
                InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: _isLiked ? const Color(0xFF1877F2) : textGrey,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatNumber(_likesCount),
                          style: TextStyle(
                            color: _isLiked ? const Color(0xFF1877F2) : textGrey,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 18),

                // Comment Button & Counter
                InkWell(
                  onTap: _showCommentSheet,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: textGrey,
                          size: 23,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.commentCount}',
                          style: const TextStyle(
                            color: textGrey,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 18),

                // Share Button & Counter
                InkWell(
                  onTap: _showShareModal,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.flip(
                          flipX: true,
                          child: const Icon(
                            Icons.reply_rounded,
                            color: textGrey,
                            size: 24,
                          ),
                        ),
                        if (widget.shareCount != null && widget.shareCount! > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${widget.shareCount}',
                            style: const TextStyle(
                              color: textGrey,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 18),

                // Bookmark / Save
                InkWell(
                  onTap: () {
                    setState(() {
                      _isBookmarked = !_isBookmarked;
                    });
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Icon(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                      color: _isBookmarked ? const Color(0xFF1877F2) : textGrey,
                      size: 24,
                    ),
                  ),
                ),

                const Spacer(),

                // Reactions Emojis Stack on the right (😆 👍)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 21,
                      height: 21,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7B125),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '😆',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-4, 0),
                      child: Container(
                        width: 21,
                        height: 21,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1877F2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.thumb_up,
                          size: 11.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 5. Responder text note (e.g. "Farhan Nym dan lainnya menanggapi")
          if (widget.responderNote != null)
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
              child: Row(
                children: [
                  if (widget.responderAvatarUrls.isNotEmpty)
                    SizedBox(
                      width: 32,
                      height: 20,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: ClipOval(
                              child: AppNetworkImage(
                                imageUrl: widget.responderAvatarUrls[0],
                                width: 18,
                                height: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (widget.responderAvatarUrls.length > 1)
                            Positioned(
                              left: 12,
                              child: ClipOval(
                                child: AppNetworkImage(
                                  imageUrl: widget.responderAvatarUrls[1],
                                  width: 18,
                                  height: 18,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.responderNote!,
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSingleImage(String url) {
    return Stack(
      children: [
        AppNetworkImage(
          imageUrl: url,
          width: double.infinity,
          height: 380,
          fit: BoxFit.cover,
        ),
        if (widget.hasAudioBadge)
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volume_up,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGridImages(List<String> urls) {
    if (urls.length == 1) return _buildSingleImage(urls[0]);

    if (urls.length == 2) {
      return Row(
        children: [
          Expanded(
            child: AppNetworkImage(imageUrl: urls[0], height: 260, fit: BoxFit.cover),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: AppNetworkImage(imageUrl: urls[1], height: 260, fit: BoxFit.cover),
          ),
        ],
      );
    }

    // 4 grid
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppNetworkImage(imageUrl: urls[0], height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: AppNetworkImage(imageUrl: urls[1], height: 180, fit: BoxFit.cover),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: AppNetworkImage(
                imageUrl: urls.length > 2 ? urls[2] : urls[0],
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: AppNetworkImage(
                imageUrl: urls.length > 3 ? urls[3] : urls[1],
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSharedPost(SharedPostData shared) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCED0D4), width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reshared Header
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipOval(
                  child: AppNetworkImage(
                    imageUrl: shared.authorAvatarUrl,
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            shared.authorName,
                            style: const TextStyle(
                              color: Color(0xFF050505),
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (shared.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, color: Color(0xFF1877F2), size: 15),
                          ],
                          if (shared.actionLinkText != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '· ${shared.actionLinkText!}',
                              style: const TextStyle(
                                color: Color(0xFF1877F2),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            shared.subtitle,
                            style: const TextStyle(
                              color: Color(0xFF65676B),
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.public, color: Color(0xFF65676B), size: 13),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reshared Caption
          if (shared.caption != null && shared.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
              child: Text(
                shared.caption!,
                style: const TextStyle(
                  color: Color(0xFF050505),
                  fontSize: 14.5,
                ),
              ),
            ),

          // Shared Media Video or Image
          if (shared.videoUrl != null)
            FacebookVideoPlayer(
              videoUrl: shared.videoUrl!,
              posterImageUrl: shared.imageUrl,
              autoPlay: true,
              loop: false,
              showControls: true,
            )
          else if (shared.imageUrl != null)
            AppNetworkImage(
              imageUrl: shared.imageUrl!,
              width: double.infinity,
              height: 360,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
