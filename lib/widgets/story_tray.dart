import 'package:flutter/material.dart';
import 'app_network_image.dart';

class StoryItem {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String storyImageUrl;
  final String? overlayText;

  const StoryItem({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.storyImageUrl,
    this.overlayText,
  });
}

class StoryTray extends StatelessWidget {
  final String userAvatarUrl;
  final List<StoryItem> stories;
  final VoidCallback? onCreateStoryTap;
  final ValueChanged<StoryItem>? onStoryTap;

  const StoryTray({
    super.key,
    required this.userAvatarUrl,
    required this.stories,
    this.onCreateStoryTap,
    this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 195,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCreateStoryCard();
          }
          final story = stories[index - 1];
          return _buildStoryCard(story);
        },
      ),
    );
  }

  Widget _buildCreateStoryCard() {
    return InkWell(
      onTap: onCreateStoryTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 108,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCED0D4), width: 0.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Top Image (68% height)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 55,
              child: AppNetworkImage(
                imageUrl: userAvatarUrl,
                fit: BoxFit.cover,
                fallbackIcon: const Icon(Icons.person, color: Color(0xFF65676B), size: 36),
              ),
            ),

            // Plus icon floating at the cut line
            Positioned(
              bottom: 38,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1877F2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Text "Buat cerita"
            const Positioned(
              bottom: 10,
              left: 4,
              right: 4,
              child: Text(
                'Buat cerita',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF050505),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(StoryItem story) {
    return InkWell(
      onTap: () => onStoryTap?.call(story),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 108,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCED0D4), width: 0.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            AppNetworkImage(
              imageUrl: story.storyImageUrl,
              fit: BoxFit.cover,
            ),

            // Gradient Overlay for readability
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black26,
                    Colors.transparent,
                    Colors.black87,
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),

            // Author Avatar with Blue Ring
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1877F2), width: 2.5),
                ),
                child: ClipOval(
                  child: AppNetworkImage(
                    imageUrl: story.authorAvatarUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Author Name
            Positioned(
              bottom: 10,
              left: 8,
              right: 8,
              child: Text(
                story.authorName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 4),
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
