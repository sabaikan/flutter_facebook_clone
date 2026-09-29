import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_clone/pages/login_page.dart';
import 'package:facebook_clone/pages/manual_login_page.dart';
import 'package:facebook_clone/pages/register_intro_page.dart';
import 'package:facebook_clone/pages/register_name_page.dart';
import 'package:facebook_clone/pages/register_choose_name_page.dart';
import 'package:facebook_clone/pages/register_birthday_page.dart';
import 'package:facebook_clone/pages/register_gender_page.dart';
import 'package:facebook_clone/pages/register_contact_page.dart';
import 'package:facebook_clone/pages/register_password_page.dart';
import 'package:facebook_clone/pages/register_terms_page.dart';
import 'package:facebook_clone/pages/main_navigation.dart';
import 'package:facebook_clone/pages/reel_player_page.dart';
import 'package:facebook_clone/widgets/reels_shelf.dart';
import 'package:facebook_clone/pages/profile_page.dart';

void main() {
  testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    expect(find.text('Lanjutkan sebagai intelecta.tech'), findsOneWidget);
    expect(find.text('Login ke akun lain'), findsOneWidget);
    expect(find.text('Buat akun baru'), findsOneWidget);
    expect(find.text('Meta'), findsOneWidget);
    expect(find.text('INTELECTA'), findsOneWidget);
  });

  testWidgets('ManualLoginPage renders form fields and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ManualLoginPage(),
      ),
    );

    expect(find.text('Bahasa Indonesia'), findsOneWidget);
    expect(find.text('Nomor ponsel atau email'), findsOneWidget);
    expect(find.text('Kata sandi'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Lupa kata sandi?'), findsOneWidget);
    expect(find.text('Buat akun baru'), findsOneWidget);
  });

  testWidgets('RegisterIntroPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterIntroPage(),
      ),
    );

    expect(find.text('Mulai di Facebook dengan Akun Meta'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
    expect(find.text('Cari akun saya'), findsOneWidget);
  });

  testWidgets('RegisterNamePage renders name fields and next button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterNamePage(),
      ),
    );

    expect(find.text('Siapa nama Anda?'), findsOneWidget);
    expect(find.text('Nama depan'), findsOneWidget);
    expect(find.text('Nama belakang'), findsOneWidget);
    expect(find.text('Berikutnya'), findsOneWidget);
    expect(find.text('Cari akun saya'), findsOneWidget);
  });

  testWidgets('RegisterChooseNamePage renders suggestion list and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterChooseNamePage(
          firstName: 'Hjj',
          lastName: 'Uhh',
        ),
      ),
    );

    expect(find.text('Piilih nama Anda'), findsOneWidget);
    expect(find.text('Hajj Uhh'), findsOneWidget);
    expect(find.text('Hjj Uhl'), findsOneWidget);
    expect(find.text('Hjj Uhs'), findsOneWidget);
    expect(find.text('Berikutnya'), findsOneWidget);
    expect(find.text('Gunakan nama lainnya'), findsOneWidget);
    expect(find.text('Cari akun saya'), findsOneWidget);
  });

  testWidgets('RegisterBirthdayPage renders birthday field and next button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterBirthdayPage(),
      ),
    );

    expect(find.text('Kapan tanggal lahir Anda?'), findsOneWidget);
    expect(find.text('Mengapa saya harus memberikan tanggal lahir?'), findsOneWidget);
    expect(find.text('Berikutnya'), findsOneWidget);
    expect(find.text('Cari akun saya'), findsOneWidget);
  });

  testWidgets('RegisterGenderPage renders gender options', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterGenderPage(),
      ),
    );

    expect(find.text('Apa jenis kelamin Anda?'), findsOneWidget);
    expect(find.text('Perempuan'), findsOneWidget);
    expect(find.text('Laki-laki'), findsOneWidget);
    expect(find.text('Opsi lainnya'), findsOneWidget);
    expect(find.text('Berikutnya'), findsOneWidget);
    expect(find.text('Cari akun saya'), findsOneWidget);
  });

  testWidgets('RegisterContactPage renders phone input and email toggle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterContactPage(),
      ),
    );

    expect(find.text('Berapa nomor ponsel Anda?'), findsOneWidget);
    expect(find.text('Nomor ponsel'), findsOneWidget);
    expect(find.text('Daftar dengan email'), findsOneWidget);
    expect(find.text('Berikutnya'), findsOneWidget);
  });

  testWidgets('RegisterPasswordPage renders password input and remember checkbox', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterPasswordPage(),
      ),
    );

    expect(find.text('Buat kata sandi'), findsOneWidget);
    expect(find.text('Kata sandi'), findsOneWidget);
    expect(find.text('Ingat info login. '), findsOneWidget);
    expect(find.text('Berikutnya'), findsOneWidget);
  });

  testWidgets('RegisterTermsPage renders terms text and agree button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterTermsPage(),
      ),
    );

    expect(find.text('Setujui ketentuan dan kebijakan Facebook'), findsOneWidget);
    expect(find.text('Saya setuju'), findsOneWidget);
    expect(find.text('Cari akun saya'), findsOneWidget);
  });

  testWidgets('MainNavigation and HomeFeedPage render properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigation(),
      ),
    );

    // Verify Facebook wordmark and composer
    expect(find.text('facebook'), findsOneWidget);
    expect(find.text('Apa yang Anda pikirkan?'), findsOneWidget);
    expect(find.text('Buat cerita'), findsOneWidget);

    // Scroll down to verify Reels shelf
    await tester.scrollUntilVisible(
      find.text('Reels'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Reels'), findsOneWidget);
  });

  testWidgets('FacebookTopBar switches to WatchFeedPage with playable video feed', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigation(),
      ),
    );

    // Verify badges on Top Bar
    expect(find.text('9+'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);

    // Tap Watch tab (icon smart_display_outlined or smart_display)
    await tester.tap(find.byIcon(Icons.smart_display_outlined));
    await tester.pumpAndSettle();

    // Verify Watch chips
    expect(find.text('Untuk Anda'), findsOneWidget);
    expect(find.text('Siaran Langsung'), findsOneWidget);
    expect(find.text('Game'), findsOneWidget);
  });

  testWidgets('ReelPlayerPage renders exact screenshot layout and metadata', (WidgetTester tester) async {
    const manhwaReel = ReelItem(
      id: 'reel_manhwa',
      title: 'Manhwa isn\'t just "another type o... selengkapnya',
      videoUrl: 'assets/videos/sample.mp4',
      videoThumbnailUrl: 'images/manhwaink.jpg',
      viewCount: '4,3 rb tayangan',
      authorName: 'Manhwaink',
      authorAvatarUrl: 'images/manhwaink.jpg',
      subtitle: 'New for you · 6 dari 16',
      likesCount: '4.383',
      commentsCount: '40',
      sharesCount: '257',
      savesCount: '3.345',
      isVerified: true,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: ReelPlayerPage(initialReel: manhwaReel),
      ),
    );

    // Verify Header
    expect(find.text('Reels'), findsOneWidget);

    // Verify Author, verified badge, and Follow button
    expect(find.text('Manhwaink'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
    expect(find.text('Ikuti'), findsOneWidget);

    // Verify Subtitle and engagement counters
    expect(find.text('New for you · 6 dari 16'), findsOneWidget);
    expect(find.text('4.383'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('257'), findsOneWidget);
    expect(find.text('3.345'), findsOneWidget);
  });

  testWidgets('Sidebar drawer opens and renders all exact menu items and logout dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigation(),
      ),
    );

    // Tap hamburger menu on top bar
    await tester.tap(find.byIcon(Icons.menu).first);
    await tester.pumpAndSettle();

    // Verify profile section
    expect(find.text('Ok E'), findsOneWidget);
    expect(find.text('Buat Halaman Facebook'), findsOneWidget);

    // Verify shortcuts
    expect(find.text('Marketplace'), findsOneWidget);
    expect(find.text('Meta AI'), findsOneWidget);
    expect(find.text('Tersimpan'), findsOneWidget);
    expect(find.text('Kenangan'), findsOneWidget);
    expect(find.text('Grup'), findsOneWidget);
    expect(find.text('Lihat selengkapnya'), findsOneWidget);

    // Verify Accordions
    expect(find.text('Bantuan dan dukungan'), findsOneWidget);
    expect(find.text('Pengaturan dan privasi'), findsOneWidget);
    expect(find.text('Upgrade'), findsOneWidget);

    // Verify Upgrade cards
    expect(find.text('Eksistensi publik'), findsOneWidget);
    expect(find.text('Facebook Plus'), findsOneWidget);

    // Scroll down in drawer to verify Juga dari Meta and Keluar
    await tester.scrollUntilVisible(
      find.text('Keluar'),
      200,
      scrollable: find.descendant(
        of: find.byKey(const Key('facebook_sidebar_list')),
        matching: find.byType(Scrollable),
      ).first,
    );

    expect(find.text('Juga dari Meta'), findsOneWidget);
    expect(find.text('Edits'), findsOneWidget);
    expect(find.text('Threads'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('Mengobrol dengan AI'), findsOneWidget);
    expect(find.text('Messenger'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);

    // Drag further up so Keluar is well within viewport bounds
    await tester.drag(
      find.descendant(
        of: find.byKey(const Key('facebook_sidebar_list')),
        matching: find.byType(Scrollable),
      ).first,
      const Offset(0, -150),
    );
    await tester.pumpAndSettle();

    // Tap Keluar to verify confirmation dialog
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari Facebook?'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
  });

  testWidgets('ProfilePage renders exact screenshot UI elements and sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfilePage(isStandalone: true),
      ),
    );

    // Profile header & Thought Bubble
    expect(find.text('Bagikan pendapat...'), findsOneWidget);
    expect(find.text('Ok E'), findsOneWidget);
    expect(find.text('4,3 rb teman · 1 postingan'), findsOneWidget);
    expect(find.text('Teman yang memiliki kesamaan'), findsOneWidget);

    // Action buttons
    expect(find.text('Tambahkan ke cerita'), findsOneWidget);
    expect(find.text('Edit profil'), findsOneWidget);

    // Filter pills
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Foto'), findsOneWidget);
    expect(find.text('Reels'), findsOneWidget);
    expect(find.text('Kenangan'), findsOneWidget);

    // Detail pribadi
    expect(find.text('Detail pribadi'), findsOneWidget);
    expect(find.text('Nonbiner'), findsOneWidget);

    // Teman list
    expect(find.text('Teman'), findsOneWidget);
    expect(find.text('Lihat semua'), findsOneWidget);
    expect(find.text('Dimas Pratama'), findsOneWidget);
    expect(find.text('5 teman bersama'), findsOneWidget);
    expect(find.text('Nadia Safitri'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Siti Rahmawati'), findsOneWidget);
    expect(find.text('8 teman bersama'), findsOneWidget);

    // Scroll down to verify post composer and empty posts state
    await tester.scrollUntilVisible(
      find.text('Tidak tersedia postingan'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Semua postingan'), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('Apa yang Anda pikirkan?'), findsOneWidget);
    expect(find.text('Reel'), findsOneWidget);
    expect(find.text('Siaran Langsung'), findsOneWidget);
    expect(find.text('Kelola postingan'), findsOneWidget);
    expect(find.text('Tidak tersedia postingan'), findsOneWidget);
  });

  testWidgets('Top bar switches to FriendsPage, GroupsPage, and NotificationsPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigation(),
      ),
    );

    // ── Tab 2: Teman ──
    await tester.tap(find.byIcon(Icons.people_alt_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Teman'), findsWidgets);
    expect(find.text('Saran'), findsOneWidget);
    expect(find.text('Teman Anda'), findsOneWidget);
    expect(find.text('Dimas Pratama'), findsOneWidget);
    expect(find.text('Nadia Safitri'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.text('Siti Rahmawati'), findsOneWidget);
    expect(find.text('Orang yang mungkin Anda kenal'), findsOneWidget);
    expect(find.text('Reza Aditya Pratama'), findsOneWidget);

    // ── Tab 3: Grup ──
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Grup'), findsOneWidget);
    expect(find.text('Grup Anda'), findsWidgets);
    expect(find.text('Komunitas Developer & Programmer ID'), findsOneWidget);
    expect(find.text('Info Kuliner & Tempat Nongkrong Hits'), findsWidgets);
    expect(find.text('Pecinta Kucing & Hewan Lucu Indonesia'), findsOneWidget);
    expect(find.text('Direkomendasikan untuk Anda'), findsOneWidget);
    expect(find.text('Spill hidden gem ramen kuah toripaitan terkental dan terenak yang pernah saya coba di Jaksel! Kuahnya bener-bener gurih gurih medok, chashu-nya tebel lembut meleleh di mulut. Wajib dateng sebelum jam makan siang biar gak antre panjang! 🍜🤤✨'), findsOneWidget);

    // ── Tab 4: Notifikasi ──
    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Baru'), findsOneWidget);
    expect(find.text('F1'), findsOneWidget);
    expect(find.text('Notifikasi otomatis Anda tidak aktif.'), findsOneWidget);
  });
}


