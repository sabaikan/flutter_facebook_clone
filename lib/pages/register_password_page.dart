import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_terms_page.dart';

class RegisterPasswordPage extends StatefulWidget {
  final String name;
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;
  final String contact;

  const RegisterPasswordPage({
    super.key,
    this.name = 'Ok E',
    this.firstName = 'Ok',
    this.lastName = 'E',
    this.birthday = '24 September 2002',
    this.gender = 'Laki-laki',
    this.contact = '',
  });

  @override
  State<RegisterPasswordPage> createState() => _RegisterPasswordPageState();
}

class _RegisterPasswordPageState extends State<RegisterPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = true;
  bool _rememberLoginInfo = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleNext() {
    final password = _passwordController.text;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterTermsPage(
          name: widget.name,
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: widget.gender,
          contact: widget.contact,
          password: password,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _handleLearnMore() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Info login Anda disimpan dengan aman di perangkat ini.'),
        backgroundColor: Color(0xFF050505),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    const inputFillColor = Color(0xFFF5F6F8);
    const borderColor = Color(0xFFCED0D4);
    const primaryBlue = Color(0xFF1877F2);
    const titleColor = Color(0xFF050505);
    const subtitleColor = Color(0xFF65676B);
    const linkBlueColor = Color(0xFF1877F2);
    const hintTextColor = Color(0xFF8A8D91);

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
                                  'Buat kata sandi',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Subtitle
                                const Text(
                                  'Buat kata sandi yang berisi minimal 6 huruf atau angka. Kata sandi tersebut harus sesuatu yang tidak bisa ditebak orang lain.',
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14.2,
                                    height: 1.45,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Password input field
                                TextField(
                                  controller: _passwordController,
                                  focusNode: _focusNode,
                                  obscureText: _obscureText,
                                  style: const TextStyle(
                                    color: Color(0xFF050505),
                                    fontSize: 15,
                                  ),
                                  cursorColor: primaryBlue,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _handleNext(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputFillColor,
                                    hintText: 'Kata sandi',
                                    hintStyle: const TextStyle(
                                      color: hintTextColor,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: hintTextColor,
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
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

                                const SizedBox(height: 14),

                                // Checkbox row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _rememberLoginInfo = !_rememberLoginInfo;
                                        });
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: _rememberLoginInfo
                                              ? primaryBlue
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: _rememberLoginInfo
                                                ? primaryBlue
                                                : const Color(0xFFCED0D4),
                                            width: 1.8,
                                          ),
                                        ),
                                        child: _rememberLoginInfo
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          const Text(
                                            'Ingat info login. ',
                                            style: TextStyle(
                                              color: Color(0xFF050505),
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _handleLearnMore,
                                            child: const Text(
                                              'Pelajari selengkapnya',
                                              style: TextStyle(
                                                color: linkBlueColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
