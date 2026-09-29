import 'package:facebook_clone/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  final favProvider = FavoriteProvider();
  await favProvider.initStorage();

  final authProvider = AuthProvider.instance;
  await authProvider.initStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favProvider),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        primaryColor: const Color(0xFF1877F2),
        cardColor: Colors.white,
        dividerColor: const Color(0xFFCED0D4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF050505),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1877F2),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF050505),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}