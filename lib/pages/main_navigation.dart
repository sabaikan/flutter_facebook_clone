import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/facebook_top_bar.dart';
import '../widgets/facebook_sidebar_drawer.dart';
import 'home_feed_page.dart';
import 'watch_feed_page.dart';
import 'friends_page.dart';
import 'groups_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  void _showCreateMenu() {
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
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Buat',
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit_note, color: Color(0xFF050505)),
                title: const Text('Postingan', style: TextStyle(color: Color(0xFF050505))),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories, color: Color(0xFF050505)),
                title: const Text('Cerita', style: TextStyle(color: Color(0xFF050505))),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.movie_creation_outlined, color: Color(0xFF050505)),
                title: const Text('Reel', style: TextStyle(color: Color(0xFF050505))),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentIndex = 1);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: _FacebookSearchDelegate(),
    );
  }

  void _showMessengerSheet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membuka Messenger...'),
        backgroundColor: Color(0xFF050505),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const lightBgColor = Color(0xFFF0F2F5);
    final isReels = _currentIndex == 1;

    final pages = [
      const HomeFeedPage(),
      WatchFeedPage(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onBackToHome: () => setState(() => _currentIndex = 0),
      ),
      const FriendsPage(),
      const GroupsPage(),
      const NotificationsPage(),
      ProfilePage(
        isStandalone: false,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: isReels ? Colors.transparent : Colors.white,
        statusBarIconBrightness: isReels ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isReels ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: isReels ? Brightness.light : Brightness.dark,
      ),
      child: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: isReels ? Colors.black : lightBgColor,
          drawer: const FacebookSidebarDrawer(isDrawer: true),
          body: SafeArea(
            top: !isReels,
            bottom: !isReels,
            child: Column(
              children: [
                // Top Facebook bar with logo, actions and 6 tabs (hidden in immersive Reels mode)
                if (!isReels)
                  FacebookTopBar(
                    selectedIndex: _currentIndex,
                    onTabSelected: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    onMenuTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    onCreateTap: _showCreateMenu,
                    onSearchTap: _showSearchDialog,
                    onMessengerTap: _showMessengerSheet,
                  ),

                // Active Tab Page
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Search Delegate ────────────────────────────────────────────────────────

class _FacebookSearchDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF050505),
        elevation: 0.5,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Color(0xFF65676B)),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Color(0xFF050505)),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF050505)),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      child: Center(
        child: Text(
          'Hasil pencarian untuk "$query"',
          style: const TextStyle(color: Color(0xFF050505)),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'Ingin Menjadi Programmer Handal',
      'Farhan Nym',
      'Classic Ace',
      'Meta AI',
      'Genshin Impact Indonesia',
    ].where((e) => e.toLowerCase().contains(query.toLowerCase())).toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final s = suggestions[index];
          return ListTile(
            leading: const Icon(Icons.search, color: Color(0xFF65676B)),
            title: Text(s, style: const TextStyle(color: Color(0xFF050505))),
            onTap: () {
              query = s;
              showResults(context);
            },
          );
        },
      ),
    );
  }
}

