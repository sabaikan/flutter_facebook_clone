import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/auth_provider.dart';
import 'main_navigation.dart';

class RegisterTermsPage extends StatefulWidget {
  final String name;
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;
  final String contact;
  final String password;

  const RegisterTermsPage({
    super.key,
    this.name = 'Ok E',
    this.firstName = 'Ok',
    this.lastName = 'E',
    this.birthday = '24 September 2002',
    this.gender = 'Nonbiner',
    this.contact = '',
    this.password = '',
  });

  @override
  State<RegisterTermsPage> createState() => _RegisterTermsPageState();
}

class _RegisterTermsPageState extends State<RegisterTermsPage> {
  bool _isLoading = false;

  void _handleAgree() async {
    setState(() {
      _isLoading = true;
    });

    final auth = AuthProvider.of(context, listen: false);
    await auth.registerUser(
      name: widget.name,
      firstName: widget.firstName,
      lastName: widget.lastName,
      emailOrPhone: widget.contact,
      birthday: widget.birthday,
      gender: widget.gender,
      password: widget.password,
    );

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainNavigation(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  void _showPolicySheet(String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ini adalah ringkasan informasi mengenai $title Facebook untuk memberikan transparansi dan kontrol penuh atas privasi Anda.',
                  style: const TextStyle(
                    color: Color(0xFF65676B),
                    fontSize: 14.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    const primaryBlue = Color(0xFF1877F2);
    const titleColor = Color(0xFF050505);
    const subtitleColor = Color(0xFF65676B);
    const linkBlueColor = Color(0xFF1877F2);

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
                                  'Setujui ketentuan dan kebijakan Facebook',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    height: 1.25,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Paragraph 1
                                Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14.2,
                                      height: 1.45,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text:
                                            'Orang yang menggunakan layanan kami mungkin telah mengunggah informasi kontak Anda ke Facebook. ',
                                      ),
                                      TextSpan(
                                        text: 'Pelajari selengkapnya',
                                        style: const TextStyle(
                                          color: linkBlueColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              _showPolicySheet('Informasi Kontak'),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Paragraph 2
                                Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14.2,
                                      height: 1.45,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Dengan mengetuk '),
                                      const TextSpan(
                                        text: 'Saya setuju',
                                        style: TextStyle(
                                          color: Color(0xFF050505),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            ', Anda setuju untuk membuat akun dan menyetujui ',
                                      ),
                                      TextSpan(
                                        text: 'Ketentuan',
                                        style: const TextStyle(
                                          color: linkBlueColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              _showPolicySheet('Ketentuan Layanan'),
                                      ),
                                      const TextSpan(text: ', '),
                                      TextSpan(
                                        text: 'Kebijakan Privasi',
                                        style: const TextStyle(
                                          color: linkBlueColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              _showPolicySheet('Kebijakan Privasi'),
                                      ),
                                      const TextSpan(text: ', dan '),
                                      TextSpan(
                                        text: 'Kebijakan Cookie',
                                        style: const TextStyle(
                                          color: linkBlueColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              _showPolicySheet('Kebijakan Cookie'),
                                      ),
                                      const TextSpan(text: ' Facebook.'),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Paragraph 3
                                Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14.2,
                                      height: 1.45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Kebijakan Privasi',
                                        style: const TextStyle(
                                          color: linkBlueColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              _showPolicySheet('Kebijakan Privasi'),
                                      ),
                                      const TextSpan(
                                        text:
                                            ' menjelaskan cara kami dapat menggunakan informasi yang kami kumpulkan saat Anda membuat akun. Misalnya, kami menggunakan informasi ini untuk menyediakan, mempersonalisasi, dan meningkatkan produk kami, termasuk iklan.',
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // Button: Saya setuju
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleAgree,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      disabledBackgroundColor:
                                          primaryBlue.withValues(alpha: 0.6),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : const Text(
                                            'Saya setuju',
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
                                        color: linkBlueColor,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
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
}
