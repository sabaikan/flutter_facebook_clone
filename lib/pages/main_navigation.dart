import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomeTab(),
    _FriendsTab(),
    _WatchTab(),
    _MarketplaceTab(),
    _NotificationsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1877F2),
        unselectedItemColor: const Color(0xFF8A8D91),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video_outlined),
            activeIcon: Icon(Icons.ondemand_video),
            label: 'Watch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}

// ── Placeholder tab pages ──────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Home'));
}

class _FriendsTab extends StatelessWidget {
  const _FriendsTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Friends'));
}

class _WatchTab extends StatelessWidget {
  const _WatchTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Watch'));
}

class _MarketplaceTab extends StatelessWidget {
  const _MarketplaceTab();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Marketplace'));
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Notifications'));
}
