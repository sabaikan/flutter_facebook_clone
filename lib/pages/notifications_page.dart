import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const NotificationsPage({super.key, this.onOpenDrawer});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _showBanner = true;
  final Set<String> _acceptedNotifs = {};

  @override
  Widget build(BuildContext context) {
    const bgColor = AppColors.cardSurface;
    const textGrey = AppColors.textSecondary;

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            children: [
              // ── Top Header Row ───────────────────────────────────────────
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.textPrimary, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      if (widget.onOpenDrawer != null) {
                        widget.onOpenDrawer!();
                      } else {
                        Scaffold.maybeOf(context)?.openDrawer();
                      }
                    },
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: AppColors.textPrimary, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Section: Baru ────────────────────────────────────────────
              const Text(
                'Baru',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Item 1: Alta friend request
              _buildNotifItem(
                id: 'alta_req',
                imagePath: 'images/friend_hyam.jpg',
                textSpans: const [
                  TextSpan(text: 'Alta ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'mengirimi Anda permintaan pertemanan. '),
                  TextSpan(text: '3 hr', style: TextStyle(color: textGrey)),
                ],
                subtitle: '2 teman bersama',
                buttons: [
                  _buildActionButton(
                    label: 'Konfirmasi',
                    isPrimary: true,
                    onTap: () => setState(() => _acceptedNotifs.add('alta_req')),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    label: 'Hapus',
                    isPrimary: false,
                    onTap: () {},
                  ),
                ],
              ),

              // Item 2: F1
              _buildNotifItem(
                id: 'f1_welcome',
                customIcon: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'F1',
                      style: TextStyle(
                        color: Color(0xFFE10600),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                textSpans: const [
                  TextSpan(text: 'Selamat datang di '),
                  TextSpan(text: 'F1', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text:
                        '. Sekarang Anda bisa memposting, menjalin interaksi dengan anggota lain, dan banyak lagi. ',
                  ),
                  TextSpan(text: '8 hr', style: TextStyle(color: textGrey)),
                ],
              ),

              // Item 3: M Fajar 1
              _buildNotifItem(
                id: 'fajar_1',
                customIcon: _buildBadgeLogo(),
                textSpans: const [
                  TextSpan(text: 'M Fajar ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'menandai semua orang di komentar di '),
                  TextSpan(
                    text: 'Ingin Mengkritik Pemerint...: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '"Hiatttt 😹😹 @semua orang". '),
                  TextSpan(text: '2 hr', style: TextStyle(color: textGrey)),
                ],
                footer: const Text(
                  'Suka',
                  style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),

              // Item 4: M Fajar 2
              _buildNotifItem(
                id: 'fajar_2',
                customIcon: _buildBadgeLogo(),
                textSpans: const [
                  TextSpan(text: 'M Fajar ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'menandai semua orang di komentar di '),
                  TextSpan(
                    text: 'Ingin Mengkritik Pemerint...: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '"@semua orang 🗣️:hey antek-ant... '),
                  TextSpan(text: '10 hr', style: TextStyle(color: textGrey)),
                ],
                footer: const Text(
                  'Suka',
                  style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),

              // Item 5: Abdrahim Kansour
              _buildNotifItem(
                id: 'abdrahim_invite',
                isSilhouette: true,
                textSpans: const [
                  TextSpan(
                    text: 'Abdrahim Kansour ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: 'mengundang Anda untuk mengikuti '),
                  TextSpan(text: 'Yam islas. ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '20 hr', style: TextStyle(color: textGrey)),
                ],
                buttons: [
                  _buildActionButton(
                    label: 'Terima',
                    isPrimary: true,
                    onTap: () => setState(() => _acceptedNotifs.add('abdrahim_invite')),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    label: 'Tolak',
                    isPrimary: false,
                    onTap: () {},
                  ),
                ],
              ),

              // Item 6: Opu Sensei
              _buildNotifItem(
                id: 'opu_invite',
                imagePath: 'images/friend_rido.jpg',
                textSpans: const [
                  TextSpan(text: 'Opu Sensei ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'mengundang Anda untuk mengikuti '),
                  TextSpan(
                    text: 'Animora News. ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '26 hr', style: TextStyle(color: textGrey)),
                ],
                buttons: [
                  _buildActionButton(
                    label: 'Ikuti',
                    isPrimary: true,
                    onTap: () => setState(() => _acceptedNotifs.add('opu_invite')),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    label: 'Abaikan',
                    isPrimary: false,
                    onTap: () {},
                  ),
                ],
              ),

              // Item 7: Roam Nyawit
              _buildNotifItem(
                id: 'roam_invite',
                imagePath: 'images/profile_avatar.jpg',
                textSpans: const [
                  TextSpan(text: 'Roam Nyawit ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'mengundang Anda untuk mengikuti '),
                  TextSpan(text: 'IndoNyawit. ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '14 hr', style: TextStyle(color: textGrey)),
                ],
              ),

              const SizedBox(height: 70),
            ],
          ),

          // ── Bottom Fixed Banner: Notifikasi otomatis ─────────────────────
          if (_showBanner)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.cardSurface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(color: AppColors.divider, width: 0.8),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _showBanner = false),
                      child: const Icon(Icons.close, color: textGrey, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Notifikasi otomatis Anda tidak aktif.',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Aktifkan untuk tetap terhubung.',
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fbBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () => setState(() => _showBanner = false),
                      child: const Text(
                        'Aktifkan',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildBadgeLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
      child: const Center(
        child: Text(
          'BGN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: SizedBox(
        height: 36,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? AppColors.fbBlue : AppColors.buttonSecondary,
            foregroundColor: isPrimary ? Colors.white : AppColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotifItem({
    required String id,
    String? imagePath,
    Widget? customIcon,
    bool isSilhouette = false,
    required List<TextSpan> textSpans,
    String? subtitle,
    Widget? footer,
    List<Widget>? buttons,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar / Icon
          if (customIcon != null)
            customIcon
          else if (isSilhouette || imagePath == null)
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.buttonSecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.textSecondary, size: 40),
            )
          else
            ClipOval(
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.buttonSecondary,
                  child: const Icon(Icons.person, color: AppColors.textSecondary, size: 40),
                ),
              ),
            ),

          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.5,
                      height: 1.3,
                    ),
                    children: textSpans,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
                if (footer != null) ...[
                  const SizedBox(height: 4),
                  footer,
                ],
                if (buttons != null) ...[
                  const SizedBox(height: 10),
                  Row(children: buttons),
                ],
              ],
            ),
          ),

          // More Options icon
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
