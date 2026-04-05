import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../module/fridge_scanner/fridge_scanner_screen.dart';
import '../module/home/home_screen.dart';
import '../module/profile/profile_screen.dart';
import '../module/recipes_catalog/recipes_catalog_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// Root shell: bottom navigation with an independent [Navigator] stack per tab.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    4,
    (_) => GlobalKey<NavigatorState>(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  Route<void> _onGenerateRoute(int tabIndex, RouteSettings settings) {
    final Widget page = switch (tabIndex) {
      0 => const HomeScreen(),
      1 => const FridgeScannerScreen(),
      2 => const RecipesCatalogScreen(),
      3 => const ProfileScreen(),
      _ => const HomeScreen(),
    };

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => page,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (var i = 0; i < 4; i++)
            Navigator(
              key: _navigatorKeys[i],
              onGenerateRoute: (settings) => _onGenerateRoute(i, settings),
            ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
