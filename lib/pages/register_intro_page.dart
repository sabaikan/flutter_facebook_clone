import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/meta_cluster_art.dart';
import 'register_name_page.dart';
import 'manual_login_page.dart';
import 'login_page.dart';

class RegisterIntroPage extends StatelessWidget {
  const RegisterIntroPage({super.key});

  void _handleStart(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegisterNamePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _handleFindAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ManualLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    const primaryBlue = Color(0xFF1877F2);
    const buttonSecondaryColor = Color(0xFFE4E6EB);
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
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    }
                  },
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
                                const SizedBox(height: 10),

                                // Meta Ecosystem Cluster Graphic
                                const Center(
                                  child: MetaClusterArt(
                                    height: 230,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Heading
                                const Text(
                                  'Mulai di Facebook dengan Akun Meta',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    height: 1.25,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Subtitle
                                const Text(
                                  'Dengan Akun Meta, Anda bisa mengakses aplikasi dan perangkat Meta, seperti Facebook, dengan mudah dan aman.',
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14.5,
                                    height: 1.45,
                                  ),
                                ),

                                const Spacer(),

                                // Button 1: Mulai
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () => _handleStart(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text(
                                      'Mulai',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Button 2: Cari akun saya
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () => _handleFindAccount(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonSecondaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cari akun saya',
                                      style: TextStyle(
                                        color: Color(0xFF050505),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // "Sudah punya akun? Login" Link
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const LoginPage()),
                                      );
                                    },
                                    child: const Text(
                                      'Sudah punya akun? Login',
                                      style: TextStyle(
                                        color: primaryBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
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
