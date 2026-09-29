import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';

class FacebookSidebarDrawer extends StatefulWidget {
  final bool isDrawer;

  const FacebookSidebarDrawer({
    super.key,
    this.isDrawer = true,
  });

  @override
  State<FacebookSidebarDrawer> createState() => _FacebookSidebarDrawerState();
}

class _FacebookSidebarDrawerState extends State<FacebookSidebarDrawer> {
  bool _isHelpExpanded = false;
  bool _isSettingsExpanded = false;
  bool _isUpgradeExpanded = true;
  bool _isMetaAppsExpanded = true;
  bool _showAllShortcuts = false;

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardSurface,
          title: const Text('Keluar dari Facebook?', style: TextStyle(color: AppColors.textPrimary)),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun Anda?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: AppColors.textPrimary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE41E3F),
              ),
              onPressed: () async {
                Navigator.pop(context);
                if (widget.isDrawer) {
                  Navigator.pop(context); // close drawer
                }
                final auth = AuthProvider.of(context, listen: false);
                await auth.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context, listen: true);
    final userName = auth.currentUser.name;

    const bgColor = AppColors.scaffoldBg;
    const cardBgColor = AppColors.cardSurface;
    const buttonBgColor = AppColors.buttonSecondary;

    final content = Container(
      color: bgColor,
      child: ListView(
        key: const Key('facebook_sidebar_list'),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        children: [
          // 1. Profile Section Card
          InkWell(
            onTap: () {
              if (widget.isDrawer) {
                Navigator.pop(context);
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(isStandalone: true),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Avatar
                      ClipOval(
                        child: auth.currentUser.avatarUrl.isNotEmpty
                            ? Image.asset(
                                auth.currentUser.avatarUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 44,
                                  height: 44,
                                  color: const Color(0xFFE4E6EB),
                                  child: const Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Color(0xFF8A8D91),
                                  ),
                                ),
                              )
                            : Container(
                                width: 44,
                                height: 44,
                                color: const Color(0xFFE4E6EB),
                                child: const Icon(
                                  Icons.person,
                                  size: 28,
                                  color: Color(0xFF8A8D91),
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),

                      // User Name
                      Text(
                        userName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      // Dropdown chevron button with "9+" red badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: buttonBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE41E3F),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                            child: const Center(
                              child: Text(
                                '9+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // "Buat Halaman Facebook" button
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka pembuatan Halaman...')),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                    decoration: BoxDecoration(
                      color: buttonBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.textPrimary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Buat Halaman Facebook',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

          // 2. Shortcuts Menu List
          _buildMenuItem(
            icon: Icons.storefront_outlined,
            title: 'Marketplace',
            onTap: () {},
          ),
          _buildMenuItem(
            customIcon: _buildMetaAIIcon(),
            title: 'Meta AI',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.bookmark_border_rounded,
            title: 'Tersimpan',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.history_rounded,
            title: 'Kenangan',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.groups_outlined,
            title: 'Grup',
            onTap: () {},
          ),

          if (_showAllShortcuts) ...[
            _buildMenuItem(
              icon: Icons.event_outlined,
              title: 'Acara',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.flag_outlined,
              title: 'Halaman',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.dynamic_feed_outlined,
              title: 'Feeds',
              onTap: () {},
            ),
          ],

          const SizedBox(height: 8),

          // "Lihat selengkapnya" Button
          InkWell(
            onTap: () {
              setState(() {
                _showAllShortcuts = !_showAllShortcuts;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: buttonBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                _showAllShortcuts ? 'Lihat lebih sedikit' : 'Lihat selengkapnya',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, thickness: 0.8),
          const SizedBox(height: 4),

          // 3. Accordion: Bantuan dan dukungan
          _buildAccordionHeader(
            icon: Icons.help_outline_rounded,
            title: 'Bantuan dan dukungan',
            isExpanded: _isHelpExpanded,
            onTap: () {
              setState(() {
                _isHelpExpanded = !_isHelpExpanded;
              });
            },
          ),
          if (_isHelpExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubItem('Pusat Bantuan'),
                  _buildSubItem('Kotak Masuk Dukungan'),
                  _buildSubItem('Laporkan Masalah'),
                ],
              ),
            ),

          // 4. Accordion: Pengaturan dan privasi
          _buildAccordionHeader(
            icon: Icons.settings_outlined,
            title: 'Pengaturan dan privasi',
            isExpanded: _isSettingsExpanded,
            onTap: () {
              setState(() {
                _isSettingsExpanded = !_isSettingsExpanded;
              });
            },
          ),
          if (_isSettingsExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubItem('Pengaturan'),
                  _buildSubItem('Pemeriksaan Privasi'),
                  _buildSubItem('Bahasa'),
                ],
              ),
            ),

          // 5. Accordion: Upgrade (With Promo Cards)
          _buildAccordionHeader(
            customIcon: const _UpgradeShapesIcon(),
            title: 'Upgrade',
            isExpanded: _isUpgradeExpanded,
            onTap: () {
              setState(() {
                _isUpgradeExpanded = !_isUpgradeExpanded;
              });
            },
          ),
          if (_isUpgradeExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Card 1: Eksistensi publik
                    _buildUpgradeCard(
                      imagePath: 'images/upgrade_spheres.jpg',
                      badgeIcon: Icons.rocket_launch_rounded,
                      badgeColor: const Color(0xFF1877F2),
                      title: 'Eksistensi publik',
                      subtitle: 'Dapatkan fitur untuk membantu Anda berke...',
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),

                    // Card 2: Facebook Plus
                    _buildUpgradeCard(
                      imagePath: 'images/facebook_plus_card.jpg',
                      badgeIcon: Icons.star_rounded,
                      badgeColor: const Color(0xFF1877F2),
                      title: 'Facebook Plus',
                      subtitle: 'Buka fitur eksklusif dan lainnya.',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 4),
          const Divider(color: AppColors.divider, thickness: 0.8),
          const SizedBox(height: 4),

          // 6. Accordion: Juga dari Meta
          _buildAccordionHeader(
            icon: Icons.grid_view_rounded,
            title: 'Juga dari Meta',
            isExpanded: _isMetaAppsExpanded,
            onTap: () {
              setState(() {
                _isMetaAppsExpanded = !_isMetaAppsExpanded;
              });
            },
          ),
          if (_isMetaAppsExpanded) ...[
            _buildMetaAppItem(
              iconWidget: _buildEditsIcon(),
              title: 'Edits',
            ),
            _buildMetaAppItem(
              iconWidget: _buildThreadsIcon(),
              title: 'Threads',
            ),
            _buildMetaAppItem(
              iconWidget: _buildInstagramIcon(),
              title: 'Instagram',
            ),
            _buildMetaAppItem(
              iconWidget: _buildAIBotsIcon(),
              title: 'Mengobrol dengan AI',
            ),
            _buildMetaAppItem(
              iconWidget: _buildMessengerIcon(),
              title: 'Messenger',
            ),
            _buildMetaAppItem(
              iconWidget: _buildWhatsAppIcon(),
              title: 'WhatsApp',
            ),
          ],

          const SizedBox(height: 24),

          // 7. "Keluar" Button (Logout)
          InkWell(
            onTap: _confirmLogout,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: buttonBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );

    if (widget.isDrawer) {
      return Drawer(
        width: MediaQuery.of(context).size.width * 0.86,
        backgroundColor: bgColor,
        child: SafeArea(child: content),
      );
    }

    return SafeArea(child: content);
  }

  // ── Widgets Helpers ───────────────────────────────────────────────────────

  Widget _buildMenuItem({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            if (customIcon != null)
              customIcon
            else
              Icon(icon, color: AppColors.textPrimary, size: 24),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordionHeader({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            if (customIcon != null)
              customIcon
            else
              Icon(icon, color: AppColors.textPrimary, size: 23),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14.5),
      ),
    );
  }

  Widget _buildUpgradeCard({
    required String imagePath,
    required IconData badgeIcon,
    required Color badgeColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 168,
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 0.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  imagePath,
                  height: 92,
                  width: 168,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 92,
                    color: AppColors.buttonSecondary,
                    child: const Icon(Icons.image, color: AppColors.textSecondary),
                  ),
                ),
                Positioned(
                  bottom: -12,
                  left: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.cardSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(badgeIcon, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.5,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaAppItem({
    required Widget iconWidget,
    required String title,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Meta Icons ────────────────────────────────────────────────────────────

  Widget _buildMetaAIIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Color(0xFF0064E0),
            Color(0xFF9B51E0),
            Color(0xFFFF2A6D),
            Color(0xFF0064E0),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.all_inclusive, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildEditsIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFF02849), width: 1.8),
      ),
      child: const Icon(Icons.crop_original, color: Colors.white, size: 15),
    );
  }

  Widget _buildThreadsIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Colors.black12,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '@',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildInstagramIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: const RadialGradient(
          center: Alignment(0.7, -0.7),
          radius: 1.2,
          colors: [
            Color(0xFFFFDC80),
            Color(0xFFF77737),
            Color(0xFFF56040),
            Color(0xFFFD1D1D),
            Color(0xFFE1306C),
            Color(0xFFC13584),
            Color(0xFF833AB4),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildAIBotsIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, color: Color(0xFF1877F2), size: 18),
        ],
      ),
    );
  }

  Widget _buildMessengerIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.bolt, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildWhatsAppIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Color(0xFF25D366),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.call, color: Colors.white, size: 15),
      ),
    );
  }
}

// ── Custom Upgrade Shapes Icon ──────────────────────────────────────────────

class _UpgradeShapesIcon extends StatelessWidget {
  const _UpgradeShapesIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Icon(Icons.crop_square_rounded, color: AppColors.textPrimary, size: 11),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(Icons.circle_outlined, color: AppColors.textPrimary, size: 10),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(Icons.change_history_rounded, color: AppColors.textPrimary, size: 11),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(Icons.circle_outlined, color: AppColors.textPrimary, size: 10),
          ),
        ],
      ),
    );
  }
}
