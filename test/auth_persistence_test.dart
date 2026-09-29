import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:facebook_clone/providers/auth_provider.dart';
import 'package:facebook_clone/pages/profile_page.dart';
import 'package:facebook_clone/widgets/facebook_sidebar_drawer.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('AuthProvider registers account and saves to current user and storage', () async {
    final auth = AuthProvider();
    await auth.initStorage();

    await auth.registerUser(
      name: 'Syihabuddin Ahmad',
      firstName: 'Syihabuddin',
      lastName: 'Ahmad',
      emailOrPhone: 'syihab@example.com',
      password: 'password123',
      birthday: '15 Agustus 2000',
      gender: 'Laki-laki',
    );

    expect(auth.currentUser.name, 'Syihabuddin Ahmad');
    expect(auth.currentUser.emailOrPhone, 'syihab@example.com');
    expect(auth.currentUser.gender, 'Laki-laki');
    expect(auth.currentUser.birthday, '15 Agustus 2000');
    expect(auth.registeredAccounts.length, 1);
    expect(auth.registeredAccounts.first['name'], 'Syihabuddin Ahmad');

    // Simulate app restart by re-initializing another provider instance
    final restartedAuth = AuthProvider();
    await restartedAuth.initStorage();
    expect(restartedAuth.currentUser.name, 'Syihabuddin Ahmad');
    expect(restartedAuth.currentUser.gender, 'Laki-laki');
  });

  test('AuthProvider updates profile details dynamically and persists changes', () async {
    final auth = AuthProvider();
    await auth.initStorage();

    await auth.loginUser(
      name: 'User Baru',
      emailOrPhone: '08123456789',
      gender: 'Perempuan',
    );

    expect(auth.currentUser.name, 'User Baru');

    await auth.updateProfile(
      name: 'User Diperbarui',
      bio: 'Software engineer & traveler',
      gender: 'Perempuan',
    );

    expect(auth.currentUser.name, 'User Diperbarui');
    expect(auth.currentUser.bio, 'Software engineer & traveler');
  });

  testWidgets('ProfilePage reflects registered user data dynamically', (WidgetTester tester) async {
    final auth = AuthProvider();
    await auth.initStorage();
    await auth.registerUser(
      name: 'Rian Pratama',
      firstName: 'Rian',
      lastName: 'Pratama',
      emailOrPhone: 'rian@facebook.com',
      password: 'secret',
      birthday: '10 Mei 1999',
      gender: 'Laki-laki',
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const MaterialApp(
          home: ProfilePage(isStandalone: true),
        ),
      ),
    );

    expect(find.text('Rian Pratama'), findsOneWidget);
    expect(find.text('Laki-laki'), findsOneWidget);
    expect(find.text('Lahir 10 Mei 1999'), findsOneWidget);
    expect(find.text('rian@facebook.com'), findsOneWidget);
  });

  testWidgets('FacebookSidebarDrawer reflects user name from auth state', (WidgetTester tester) async {
    final auth = AuthProvider();
    await auth.initStorage();
    await auth.loginUser(
      name: 'intelecta.tech',
      emailOrPhone: 'intelecta@meta.com',
      gender: 'Laki-laki',
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const MaterialApp(
          home: Scaffold(
            drawer: FacebookSidebarDrawer(isDrawer: true),
            body: SizedBox.expand(),
          ),
        ),
      ),
    );

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('intelecta.tech'), findsOneWidget);
  });

  testWidgets('Newly registered user has empty avatar and renders person icon', (WidgetTester tester) async {
    final auth = AuthProvider();
    await auth.initStorage();
    await auth.registerUser(
      name: 'Akun Kosong',
      emailOrPhone: 'kosong@facebook.com',
    );

    expect(auth.currentUser.avatarUrl, isEmpty);
    expect(auth.currentUser.coverUrl, isEmpty);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const MaterialApp(
          home: ProfilePage(isStandalone: true),
        ),
      ),
    );

    expect(find.text('Akun Kosong'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsWidgets);
    expect(find.byIcon(Icons.camera_alt), findsWidgets);
  });
}
