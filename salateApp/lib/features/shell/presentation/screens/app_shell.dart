import 'package:flutter/material.dart';

import '../../../dua/presentation/screens/dua_list_screen.dart';
import '../../../prayer_times/presentation/screens/home_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../widgets/coming_soon_tab.dart';

/// Bottom-nav shell hosting Home and Settings (real) plus Qibla/Dua
/// placeholders, matching the reference app's intended long-term nav
/// structure. Uses local tab-index state + IndexedStack rather than
/// go_router branches — see docs/architecture.md for why that's deferred
/// until the remaining tabs have real content and their own navigation
/// stacks.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _tabs = [
    HomeTab(),
    ComingSoonTab(title: 'Qibla', icon: Icons.explore),
    DuaListScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Qibla'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Dua'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
