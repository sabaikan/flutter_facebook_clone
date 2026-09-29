import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_choose_name_page.dart';

class RegisterNamePage extends StatefulWidget {
  const RegisterNamePage({super.key});

  @override
  State<RegisterNamePage> createState() => _RegisterNamePageState();
}

class _RegisterNamePageState extends State<RegisterNamePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstFocus = FocusNode();
  final FocusNode _lastFocus = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstFocus.dispose();
    _lastFocus.dispose();
    super.dispose();
  }

  void _handleNext() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterChooseNamePage(
          firstName: first.isEmpty ? 'Hjj' : first,
          lastName: last.isEmpty ? 'Uhh' : last,
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
    const inputFillColor = Color(0xFFF5F6F8);
    const borderColor = Color(0xFFCED0D4);
    const primaryBlue = Color(0xFF1877F2);
    const titleColor = Color(0xFF050505);
    const subtitleColor = Color(0xFF65676B);
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
                                  'Siapa nama Anda?',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Subtitle
                                const Text(
                                  'Masukkan nama yang Anda gunakan di kehidupan nyata.',
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14.2,
                                    height: 1.4,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Two side-by-side inputs
                                Row(
                                  children: [
                                    // First Name
                                    Expanded(
                                      child: TextField(
                                        controller: _firstNameController,
                                        focusNode: _firstFocus,
                                        style: const TextStyle(
                                          color: Color(0xFF050505),
                                          fontSize: 15,
                                        ),
                                        cursorColor: primaryBlue,
                                        textInputAction: TextInputAction.next,
                                        onSubmitted: (_) {
                                          _lastFocus.requestFocus();
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputFillColor,
                                          hintText: 'Nama depan',
                                          hintStyle: const TextStyle(
                                            color: hintTextColor,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
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
                                    ),

                                    const SizedBox(width: 12),

                                    // Last Name
                                    Expanded(
                                      child: TextField(
                                        controller: _lastNameController,
                                        focusNode: _lastFocus,
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
                                          hintText: 'Nama belakang',
                                          hintStyle: const TextStyle(
                                            color: hintTextColor,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
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
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

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
}
