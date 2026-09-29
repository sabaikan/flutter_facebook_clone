import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/auth_provider.dart';
import '../widgets/meta_footer.dart';
import 'main_navigation.dart';
import 'register_intro_page.dart';

class ManualLoginPage extends StatefulWidget {
  const ManualLoginPage({super.key});

  @override
  State<ManualLoginPage> createState() => _ManualLoginPageState();
}

class _ManualLoginPageState extends State<ManualLoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedLanguage = 'Bahasa Indonesia';

  final List<String> _languages = [
    'Bahasa Indonesia',
    'English (US)',
    'Bahasa Melayu',
    'Español',
    'Português (Brasil)',
    'Français (France)',
  ];

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    final id = _identifierController.text.trim();
    final auth = AuthProvider.of(context, listen: false);
    await auth.loginUser(
      name: id.isNotEmpty ? (id.contains('@') ? id.split('@')[0] : id) : 'Pengguna Facebook',
      emailOrPhone: id,
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

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Pilih Bahasa',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(color: Color(0xFFCED0D4), height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = lang == _selectedLanguage;
                    return ListTile(
                      title: Text(
                        lang,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF1877F2) : const Color(0xFF050505),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Color(0xFF1877F2))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedLanguage = lang;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showForgotPasswordDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mengarahkan ke pemulihan akun...'),
        backgroundColor: Color(0xFF050505),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openRegisterFlow() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegisterIntroPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    const inputFillColor = Color(0xFFF5F6F8);
    const borderColor = Color(0xFFCED0D4);
    const primaryBlue = Color(0xFF1877F2);
    const hintTextColor = Color(0xFF8A8D91);
    const languageTextColor = Color(0xFF65676B);

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
            children: [
              // Top Bar: Back Button & Language Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF050505), size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _showLanguagePicker,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedLanguage,
                                style: const TextStyle(
                                  color: languageTextColor,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: languageTextColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
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
                              children: [
                                const Spacer(flex: 2),

                                // Facebook Logo (SVG)
                                SvgPicture.asset(
                                  'images/facebook_logo.svg',
                                  width: 68,
                                  height: 68,
                                ),

                                const SizedBox(height: 52),

                                // Input 1: Nomor ponsel atau email
                                TextField(
                                  controller: _identifierController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    color: Color(0xFF050505),
                                    fontSize: 15,
                                  ),
                                  cursorColor: primaryBlue,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputFillColor,
                                    hintText: 'Nomor ponsel atau email',
                                    hintStyle: const TextStyle(
                                      color: hintTextColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: borderColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: primaryBlue,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Input 2: Kata sandi
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(
                                    color: Color(0xFF050505),
                                    fontSize: 15,
                                  ),
                                  cursorColor: primaryBlue,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputFillColor,
                                    hintText: 'Kata sandi',
                                    hintStyle: const TextStyle(
                                      color: hintTextColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    suffixIcon: _passwordController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: hintTextColor,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                          )
                                        : null,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: borderColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: primaryBlue,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),

                                const SizedBox(height: 14),

                                // Button: Login
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      disabledBackgroundColor: primaryBlue.withValues(alpha: 0.6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // Text link: Lupa kata sandi?
                                GestureDetector(
                                  onTap: _showForgotPasswordDialog,
                                  child: const Text(
                                    'Lupa kata sandi?',
                                    style: TextStyle(
                                      color: primaryBlue,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const Spacer(flex: 3),

                                // Button: Buat akun baru
                                SizedBox(
                                  width: double.infinity,
                                  height: 46,
                                  child: OutlinedButton(
                                    onPressed: _openRegisterFlow,
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: primaryBlue,
                                        width: 1.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text(
                                      'Buat akun baru',
                                      style: TextStyle(
                                        color: primaryBlue,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // Footer: Meta Logo
                                const MetaFooter(
                                  color: Color(0xFF65676B),
                                  fontSize: 15,
                                ),

                                const SizedBox(height: 14),
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
