import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_password_page.dart';

class RegisterContactPage extends StatefulWidget {
  final String name;
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;

  const RegisterContactPage({
    super.key,
    this.name = 'Ok E',
    this.firstName = 'Ok',
    this.lastName = 'E',
    this.birthday = '24 September 2002',
    this.gender = 'Laki-laki',
  });

  @override
  State<RegisterContactPage> createState() => _RegisterContactPageState();
}

class _RegisterContactPageState extends State<RegisterContactPage> {
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isUsingEmail = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contactController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleNext() {
    final contact = _contactController.text.trim();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterPasswordPage(
          name: widget.name,
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: widget.gender,
          contact: contact,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _toggleContactMethod() {
    setState(() {
      _isUsingEmail = !_isUsingEmail;
      _contactController.clear();
    });
    _focusNode.requestFocus();
  }

  void _handleLearnMore() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifikasi WhatsApp dan SMS digunakan untuk keamanan dan verifikasi.'),
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
    const buttonSecondaryColor = Color(0xFFE4E6EB);
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
                                Text(
                                  _isUsingEmail
                                      ? 'Berapa email Anda?'
                                      : 'Berapa nomor ponsel Anda?',
                                  style: const TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Subtitle
                                Text(
                                  _isUsingEmail
                                      ? 'Masukkan email yang bisa dihubungi. Tidak ada yang akan melihat informasi ini di profil Anda.'
                                      : 'Masukkan nomor ponsel yang bisa dihubungi. Tidak ada yang akan melihat informasi ini di profil Anda.',
                                  style: const TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14.2,
                                    height: 1.45,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Input Field
                                TextField(
                                  controller: _contactController,
                                  focusNode: _focusNode,
                                  keyboardType: _isUsingEmail
                                      ? TextInputType.emailAddress
                                      : TextInputType.phone,
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
                                    hintText: _isUsingEmail ? 'Email' : 'Nomor ponsel',
                                    hintStyle: const TextStyle(
                                      color: hintTextColor,
                                      fontSize: 14.5,
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

                                const SizedBox(height: 14),

                                // Info note with link
                                Wrap(
                                  children: [
                                    const Text(
                                      'Anda mungkin menerima notifikasi WhatsApp dan SMS dari kami. ',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 13.5,
                                        height: 1.4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _handleLearnMore,
                                      child: const Text(
                                        'Pelajari selengkapnya',
                                        style: TextStyle(
                                          color: linkBlueColor,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Button 1: Berikutnya
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

                                const SizedBox(height: 12),

                                // Button 2: Daftar dengan email / nomor ponsel
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _toggleContactMethod,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonSecondaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: Text(
                                      _isUsingEmail
                                          ? 'Daftar dengan nomor ponsel'
                                          : 'Daftar dengan email',
                                      style: const TextStyle(
                                        color: Color(0xFF050505),
                                        fontSize: 15,
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
