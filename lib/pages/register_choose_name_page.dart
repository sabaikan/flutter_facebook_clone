import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_birthday_page.dart';

class RegisterChooseNamePage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const RegisterChooseNamePage({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<RegisterChooseNamePage> createState() => _RegisterChooseNamePageState();
}

class _RegisterChooseNamePageState extends State<RegisterChooseNamePage> {
  int _selectedIndex = 0;
  late final List<String> _suggestions;

  @override
  void initState() {
    super.initState();
    final first = widget.firstName.trim().isEmpty ? 'Hjj' : widget.firstName.trim();
    final last = widget.lastName.trim().isEmpty ? 'Uhh' : widget.lastName.trim();

    _suggestions = [
      'Hajj $last',
      '$first Uhl',
      '$first Uhs',
    ];
  }

  void _handleNext() {
    final chosenName = _suggestions[_selectedIndex];
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterBirthdayPage(
          name: chosenName,
          firstName: widget.firstName,
          lastName: widget.lastName,
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
    const buttonSecondaryColor = Color(0xFFE4E6EB);

    final typedName = '${widget.firstName} ${widget.lastName}'.trim().isEmpty
        ? 'Hjj Uhh'
        : '${widget.firstName} ${widget.lastName}'.trim();

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
                                  'Piilih nama Anda',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Subtitle
                                Text(
                                  'Anda mengetikkan $typedName. Kami mengharuskan semua orang untuk menggunakan nama yang mereka gunakan dalam kehidupan sehari-hari, yang digunakan teman-teman untuk memanggil mereka, di Facebook. Apakah maksud Anda:',
                                  style: const TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14.2,
                                    height: 1.45,
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // Selection Box
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: borderColor, width: 1.0),
                                  ),
                                  child: Column(
                                    children: List.generate(_suggestions.length, (index) {
                                      final name = _suggestions[index];
                                      final isSelected = _selectedIndex == index;
                                      final isLast = index == _suggestions.length - 1;

                                      return Column(
                                        children: [
                                          InkWell(
                                            borderRadius: BorderRadius.vertical(
                                              top: index == 0 ? const Radius.circular(14) : Radius.zero,
                                              bottom: isLast ? const Radius.circular(14) : Radius.zero,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _selectedIndex = index;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 18,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      name,
                                                      style: const TextStyle(
                                                        color: Color(0xFF050505),
                                                        fontSize: 15.5,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  // Radio indicator
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
                                          ),
                                          if (!isLast)
                                            const Divider(
                                              color: borderColor,
                                              height: 1,
                                              thickness: 1,
                                            ),
                                        ],
                                      );
                                    }),
                                  ),
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

                                // Button 2: Gunakan nama lainnya
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonSecondaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text(
                                      'Gunakan nama lainnya',
                                      style: TextStyle(
                                        color: Color(0xFF050505),
                                        fontSize: 15,
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
