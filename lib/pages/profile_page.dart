import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';

class ProfilePage extends StatefulWidget {
  final bool isStandalone;
  final VoidCallback? onOpenDrawer;

  const ProfilePage({
    super.key,
    this.isStandalone = false,
    this.onOpenDrawer,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = const ['Semua', 'Foto', 'Reels', 'Kenangan'];

  void _showEditProfileDialog(BuildContext context, UserModel user, AuthProvider auth) {
    final nameController = TextEditingController(text: user.name);
    final bioController = TextEditingController(text: user.bio);
    final genderController = TextEditingController(text: user.gender);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profil',
                style: TextStyle(
                  color: Color(0xFF050505),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Color(0xFF050505)),
                decoration: const InputDecoration(
                  labelText: 'Nama Profil',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bioController,
                style: const TextStyle(color: Color(0xFF050505)),
                decoration: const InputDecoration(
                  labelText: 'Bio / Keterangan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: genderController,
                style: const TextStyle(color: Color(0xFF050505)),
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () async {
                    await auth.updateProfile(
                      name: nameController.text.trim(),
                      bio: bioController.text.trim(),
                      gender: genderController.text.trim(),
                    );
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profil berhasil diperbarui!')),
                      );
                    }
                  },
                  child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context, listen: true);
    final user = auth.currentUser;

    const bgColor = AppColors.cardSurface;
    const cardBgColor = AppColors.scaffoldBg;
    const buttonBgColor = AppColors.buttonSecondary;
    const textGrey = AppColors.textSecondary;

    final content = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cover Photo & Overlay Controls ───────────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover Image or Empty Cover Placeholder
              user.coverUrl.isNotEmpty
                  ? Image.asset(
                      user.coverUrl,
                      height: 215,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 215,
                        color: const Color(0xFFCED0D4),
                        child: const Center(
                          child: Icon(Icons.camera_alt, color: Color(0xFF65676B), size: 40),
                        ),
                      ),
                    )
                  : Container(
                      height: 215,
                      width: double.infinity,
                      color: const Color(0xFFCED0D4),
                      child: const Center(
                        child: Icon(Icons.camera_alt, color: Color(0xFF65676B), size: 40),
                      ),
                    ),

              // Top gradient vignette for readable buttons
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),

              // Top action buttons overlay
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    // Hamburger Menu button or Back Button
                    _buildCircleIconButton(
                      icon: widget.isStandalone && Navigator.canPop(context)
                          ? Icons.arrow_back
                          : Icons.menu,
                      onTap: () {
                        if (widget.isStandalone && Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else if (widget.onOpenDrawer != null) {
                          widget.onOpenDrawer!();
                        } else {
                          Scaffold.maybeOf(context)?.openDrawer();
                        }
                      },
                    ),
                    const Spacer(),
                    // Edit cover button
                    _buildCircleIconButton(
                      icon: Icons.edit_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit foto sampul...')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    // Search button
                    _buildCircleIconButton(
                      icon: Icons.search,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cari di profil...')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    // More options button
                    _buildCircleIconButton(
                      icon: Icons.more_horiz,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pengaturan profil...')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Camera button on bottom right of cover photo
              Positioned(
                bottom: 12,
                right: 12,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Avatar & Thought Bubble (positioned to overlap bottom edge)
              Positioned(
                bottom: -72,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thought Bubble: "Bagikan pendapat..."
                    _buildThoughtBubble(),
                    const SizedBox(height: 4),

                    // Avatar with Camera Badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 138,
                          height: 138,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: bgColor,
                              width: 4.5,
                            ),
                          ),
                          child: ClipOval(
                            child: user.avatarUrl.isNotEmpty
                                ? Image.asset(
                                    user.avatarUrl,
                                    width: 129,
                                    height: 129,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      width: 129,
                                      height: 129,
                                      color: const Color(0xFFE4E6EB),
                                      child: const Icon(
                                        Icons.person,
                                        color: Color(0xFF8A8D91),
                                        size: 80,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 129,
                                    height: 129,
                                    color: const Color(0xFFE4E6EB),
                                    child: const Icon(
                                      Icons.person,
                                      color: Color(0xFF8A8D91),
                                      size: 80,
                                    ),
                                  ),
                          ),
                        ),
                        // Camera badge on bottom right of avatar
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: buttonBgColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.textPrimary,
                              size: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Spacing compensation for overlapping avatar
          const SizedBox(height: 84),

          // ── User Information Header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Name & Chevron dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: buttonBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Friends & Posts count
                Text(
                  '${user.formattedFriendsCount} · ${user.postsCount} postingan',
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),

                // Mutual Friends Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user.friendsCount > 0) ...[
                      // 3 Overlapping Avatars
                      SizedBox(
                        width: 58,
                        height: 26,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: _buildMiniAvatar('images/friend_hyam.jpg'),
                            ),
                            Positioned(
                              left: 16,
                              child: _buildMiniAvatar('images/friend_fabian.jpg'),
                            ),
                            Positioned(
                              left: 32,
                              child: _buildMiniAvatar('images/friend_rido.jpg'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      user.bio.isNotEmpty ? user.bio : 'Teman yang memiliki kesamaan',
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons: "+ Tambahkan ke cerita" & "Edit profil"
                Row(
                  children: [
                    // Blue button: Tambahkan ke cerita
                    Expanded(
                      flex: 5,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.fbBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle, size: 20),
                        label: const Text(
                          'Tambahkan ke cerita',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Grey button: Edit profil
                    Expanded(
                      flex: 4,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBgColor,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _showEditProfileDialog(context, user, auth),
                        icon: const Icon(Icons.edit, size: 18, color: AppColors.textPrimary),
                        label: const Text(
                          'Edit profil',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Filter Pills: Semua, Foto, Reels, Kenangan ───────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = index == _selectedFilterIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE7F3FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? null
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.fbBlue
                                : textGrey,
                            fontSize: 14.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Detail pribadi ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Detail pribadi',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: textGrey, size: 21),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () => _showEditProfileDialog(context, user, auth),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Gender row: rings icon + user.gender + lock
                Row(
                  children: [
                    const CustomPaint(
                      size: Size(26, 16),
                      painter: _InterlockingRingsPainter(color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      user.gender,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.lock,
                      color: textGrey,
                      size: 14,
                    ),
                  ],
                ),
                if (user.birthday.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.cake_outlined,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 18),
                      Text(
                        'Lahir ${user.birthday}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.lock,
                        color: textGrey,
                        size: 14,
                      ),
                    ],
                  ),
                ],
                if (user.emailOrPhone.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.alternate_email,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 18),
                      Text(
                        user.emailOrPhone,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.lock,
                        color: textGrey,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Teman (Friends section) ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Teman',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(
                          color: AppColors.fbBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 4 Friends horizontally
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildFriendCard(
                        imagePath: 'images/friend_hyam.jpg',
                        name: 'Dimas Pratama',
                        mutual: '5 teman bersama',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFriendCard(
                        imagePath: 'images/friend_fabian.jpg',
                        name: 'Nadia Safitri',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFriendCard(
                        imagePath: 'images/friend_rido.jpg',
                        name: 'Budi Santoso',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFriendCard(
                        name: 'Siti Rahmawati',
                        isSilhouette: true,
                        mutual: '8 teman bersama',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Semua postingan ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Semua postingan',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        'Filter',
                        style: TextStyle(
                          color: AppColors.fbBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Post Composer Card
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'images/profile_avatar.jpg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Apa yang Anda pikirkan?',
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.photo_size_select_actual,
                        color: Color(0xFF45BD62),
                        size: 26,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: AppColors.divider, thickness: 0.6),
                const SizedBox(height: 6),

                // Action chips: Reel & Siaran Langsung
                Row(
                  children: [
                    _buildPostTypeChip(
                      icon: Icons.movie_creation_outlined,
                      label: 'Reel',
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),
                    _buildPostTypeChip(
                      icon: Icons.videocam,
                      label: 'Siaran Langsung',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // "Kelola postingan" full width button
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: buttonBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Kelola postingan',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // ── Empty Posts Illustration & Text ──────────────────────────────
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'images/empty_folder.jpg',
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.folder_open_rounded,
                        color: Color(0xFF1877F2),
                        size: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tidak tersedia postingan',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );

    if (widget.isStandalone) {
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(child: content),
      );
    }

    return Container(
      color: bgColor,
      child: content,
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildThoughtBubble() {
    const bubbleColor = AppColors.buttonSecondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Bagikan pendapat...',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        // Downward triangular tail
        CustomPaint(
          size: const Size(12, 6),
          painter: const _BubbleTailPainter(color: bubbleColor),
        ),
      ],
    );
  }

  Widget _buildMiniAvatar(String assetPath) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.8,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Icon(Icons.person, size: 14, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildFriendCard({
    String? imagePath,
    bool isSilhouette = false,
    required String name,
    String? mutual,
  }) {
    return Column(
      children: [
        // Circular Avatar
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.buttonSecondary,
          ),
          child: isSilhouette || imagePath == null
              ? const Icon(Icons.person, color: AppColors.textSecondary, size: 50)
              : ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 50,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 6),

        // Friend Name
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
        ),

        // Mutual Friends Count
        if (mutual != null) ...[
          const SizedBox(height: 3),
          Text(
            mutual,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              height: 1.1,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPostTypeChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.buttonSecondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFF3425F), size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom Interlocking Rings Painter ───────────────────────────────────────

class _InterlockingRingsPainter extends CustomPainter {
  final Color color;
  const _InterlockingRingsPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final r = size.height * 0.44;
    final cy = size.height * 0.5;

    canvas.drawCircle(Offset(r + 1.5, cy), r, strokePaint);
    canvas.drawCircle(Offset(size.width - r - 1.5, cy), r, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Custom Bubble Tail Painter ──────────────────────────────────────────────

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  const _BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
