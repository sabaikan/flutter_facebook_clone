import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_contact_page.dart';

class RegisterGenderPage extends StatefulWidget {
  final String name;
  final String firstName;
  final String lastName;
  final String birthday;

  const RegisterGenderPage({
    super.key,
    this.name = 'Ok E',
    this.firstName = 'Ok',
    this.lastName = 'E',
    this.birthday = '24 September 2002',
  });

  @override
  State<RegisterGenderPage> createState() => _RegisterGenderPageState();
}

class _RegisterGenderPageState extends State<RegisterGenderPage> {
  int _selectedGenderIndex = 0; // 0: Perempuan, 1: Laki-laki, 2: Opsi lainnya

  void _handleNext() {
    final gender = _selectedGenderIndex == 0
        ? 'Perempuan'
        : (_selectedGenderIndex == 1 ? 'Laki-laki' : 'Nonbiner');

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterContactPage(
          name: widget.name,
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: gender,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _handleFindAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mencari akun yang terdaftar...'),
        backgroundColor: Color(0xFF050505),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    const borderColor = Color(0xFFCED0D4);
    const primaryBlue = Color(0xFF1877F2);
    const titleColor = Color(0xFF050505);
    const subtitleColor = Color(0xFF65676B);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Back button
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF050505), size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),

                                // Title
                                const Text(
                                  'Apa jenis kelamin Anda?',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Subtitle
                                const Text(
                                  'Anda bisa mengubah siapa yang bisa melihat jenis kelamin Anda di profil nanti.',
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14.2,
                                    height: 1.45,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Gender selection card
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: borderColor, width: 1.0),
                                  ),
                                  child: Column(
                                    children: [
                                      // Option 1: Perempuan
                                      _buildGenderTile(
                                        index: 0,
                                        title: 'Perempuan',
                                        isTop: true,
                                      ),
                                      const Divider(
                                        color: borderColor,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      // Option 2: Laki-laki
                                      _buildGenderTile(
                                        index: 1,
                                        title: 'Laki-laki',
                                      ),
                                      const Divider(
                                        color: borderColor,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      // Option 3: Opsi lainnya
                                      _buildGenderTile(
                                        index: 2,
                                        title: 'Opsi lainnya',
                                        subtitle:
                                            'Pilih opsi Lainnya untuk memilih jenis kelamin lain atau jika Anda memilih tidak menjawab.',
                                        isBottom: true,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Button: Berikutnya
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _handleNext,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text(
                                      'Berikutnya',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // Footer link: Cari akun saya
                                Center(
                                  child: TextButton(
                                    onPressed: _handleFindAccount,
                                    child: const Text(
                                      'Cari akun saya',
                                      style: TextStyle(
                                        color: primaryBlue,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderTile({
    required int index,
    required String title,
    String? subtitle,
    bool isTop = false,
    bool isBottom = false,
  }) {
    final isSelected = _selectedGenderIndex == index;
    const primaryBlue = Color(0xFF1877F2);

    return InkWell(
      borderRadius: BorderRadius.vertical(
        top: isTop ? const Radius.circular(14) : Radius.zero,
        bottom: isBottom ? const Radius.circular(14) : Radius.zero,
      ),
      onTap: () {
        setState(() {
          _selectedGenderIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment:
              subtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF050505),
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF65676B),
                        fontSize: 13.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Radio circle
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryBlue : const Color(0xFFCED0D4),
                  width: 2.0,
                ),
                color: isSelected ? primaryBlue : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
