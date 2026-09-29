import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_gender_page.dart';

class RegisterBirthdayPage extends StatefulWidget {
  final String name;
  final String firstName;
  final String lastName;

  const RegisterBirthdayPage({
    super.key,
    this.name = 'Ok E',
    this.firstName = 'Ok',
    this.lastName = 'E',
  });

  @override
  State<RegisterBirthdayPage> createState() => _RegisterBirthdayPageState();
}

class _RegisterBirthdayPageState extends State<RegisterBirthdayPage> {
  DateTime _selectedDate = DateTime(2003, 3, 20);

  int get _calculatedAge {
    final now = DateTime.now();
    int age = now.year - _selectedDate.year;
    if (now.month < _selectedDate.month ||
        (now.month == _selectedDate.month && now.day < _selectedDate.day)) {
      age--;
    }
    return age;
  }

  String _formatDate(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1905),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1877F2),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF050505),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleNext() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterGenderPage(
          name: widget.name,
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: _formatDate(_selectedDate),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _handleWhyBirthday() {
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
                const Text(
                  'Mengapa kami meminta tanggal lahir?',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tanggal lahir Anda membantu kami memastikan bahwa Anda mendapatkan pengalaman Facebook yang tepat untuk usia Anda. Anda selalu dapat memilih siapa yang bisa melihat informasi ini di profil Anda.',
                  style: TextStyle(
                    color: Color(0xFF65676B),
                    fontSize: 14.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Mengerti', style: TextStyle(color: Colors.white)),
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
    const inputFillColor = Color(0xFFF5F6F8);
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
                                  'Kapan tanggal lahir Anda?',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Subtitle with inline link
                                Wrap(
                                  children: [
                                    const Text(
                                      'Pilih tanggal lahir. Anda selalu bisa membuatnya privat nanti. ',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 14.2,
                                        height: 1.45,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _handleWhyBirthday,
                                      child: const Text(
                                        'Mengapa saya harus memberikan tanggal lahir?',
                                        style: TextStyle(
                                          color: primaryBlue,
                                          fontSize: 14.2,
                                          fontWeight: FontWeight.w600,
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Date input field
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _pickDate,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: inputFillColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: borderColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tanggal lahir ($_calculatedAge tahun)',
                                          style: const TextStyle(
                                            color: subtitleColor,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatDate(_selectedDate),
                                          style: const TextStyle(
                                            color: Color(0xFF050505),
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 22),

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
