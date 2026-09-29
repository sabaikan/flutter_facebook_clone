import 'package:flutter/material.dart';
import 'app_network_image.dart';

class StatusComposer extends StatelessWidget {
  final String userAvatarUrl;
  final VoidCallback? onTap;
  final VoidCallback? onPhotoTap;

  const StatusComposer({
    super.key,
    required this.userAvatarUrl,
    this.onTap,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // User Avatar
          ClipOval(
            child: userAvatarUrl.isEmpty
                ? Container(
                    width: 40,
                    height: 40,
                    color: const Color(0xFFE4E6EB),
                    child: const Icon(Icons.person, color: Color(0xFF8A8D91), size: 26),
                  )
                : (userAvatarUrl.startsWith('images/') || userAvatarUrl.startsWith('assets/')
                    ? Image.asset(
                        userAvatarUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 40,
                          height: 40,
                          color: const Color(0xFFE4E6EB),
                          child: const Icon(Icons.person, color: Color(0xFF8A8D91), size: 26),
                        ),
                      )
                    : AppNetworkImage(
                        imageUrl: userAvatarUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        fallbackIcon: const Icon(Icons.person, color: Color(0xFF8A8D91), size: 26),
                      )),
          ),
          const SizedBox(width: 10),

          // "Apa yang Anda pikirkan?" pill
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFCED0D4),
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Apa yang Anda pikirkan?',
                  style: TextStyle(
                    color: Color(0xFF65676B),
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Photo/Gallery icon
          InkWell(
            onTap: onPhotoTap,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.photo_library,
                color: Color(0xFF45BD62),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
