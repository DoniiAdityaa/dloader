import 'package:dloader/presentation/history_screen.dart';
import 'package:dloader/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../presentation/home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      // Latar belakang agar efek refraksi & blur kaca iOS terekspos sempurna
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF111115)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      statusBarStyle: GlassStatusBarStyle.auto,
      contentAwareBrightness: true,
      bottomBar: GlassTabBar.bottom(
        selectedIndex: _currentIndex,
        adaptiveBrightness: true,
        quality: GlassQuality.premium,
        maskingQuality: MaskingQuality.high,
        innerBlur: 4,

        settings: const LiquidGlassSettings(
          thickness: 35,
          blur: 8,
          refractiveIndex: 1.4,
          chromaticAberration: 0.02,
          specularSharpness: GlassSpecularSharpness.sharp,
        ),
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Styling warna & teks khas iOS Liquid Glass
        selectedIconColor: Colors.white,
        unselectedIconColor: Colors.white.withValues(alpha: 0.45),
        selectedLabelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.45),
        indicatorColor: Colors.white.withValues(alpha: 0.1),
        indicatorBorderRadius: 999,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.white.withValues(alpha: 0.45),
          decoration: TextDecoration.none,
        ),
        tabs: const [
          GlassTab(icon: Icon(Icons.download_rounded), label: 'save'),
          GlassTab(icon: Icon(Icons.history_rounded), label: 'history'),
          GlassTab(icon: Icon(Icons.settings_outlined), label: 'settings'),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
    );
  }
}
