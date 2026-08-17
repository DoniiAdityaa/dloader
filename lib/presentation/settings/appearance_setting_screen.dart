import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class AppearanceSettingScreen extends StatefulWidget {
  const AppearanceSettingScreen({super.key});

  @override
  State<AppearanceSettingScreen> createState() =>
      _AppearanceSettingScreenState();
}

class _AppearanceSettingScreenState extends State<AppearanceSettingScreen> {
  int _selectedThemeIndex = 0; // 0: auto, 1: light, 2: dark
  bool _autoLanguage = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GlassScaffold(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF000000), Color(0xFF111115)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Pinned Header dengan Tombol Back [ <- ]
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    GlassIconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'appearance',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Settings Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _themeSection(),
                      const SizedBox(height: 28),
                      _languageSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Section Theme (auto, light, dark)
  Widget _themeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'theme',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),

        // Segmented Switcher Theme
        GlassSegmentedControl(
          selectedIndex: _selectedThemeIndex,
          onSegmentSelected: (index) {
            setState(() {
              _selectedThemeIndex = index;
            });
          },
          segments: const [
            GlassSegment(label: 'auto'),
            GlassSegment(label: 'light'),
            GlassSegment(label: 'dark'),
          ],
        ),
        const SizedBox(height: 10),

        const Text(
          'auto theme switches between light and dark themes depending on your device\'s display mode.',
          style: TextStyle(fontSize: 12, color: Colors.white54, height: 1.4),
        ),
      ],
    );
  }

  /// 2. Section Language (Automatic selection)
  Widget _languageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'language',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),

        // Automatic Selection Card dengan Switch
        GlassCard(
          shape: const LiquidRoundedRectangle(borderRadius: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'automatic selection',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              GlassSwitch(
                value: _autoLanguage,
                activeColor: Colors.white.withValues(
                  alpha: 0.35,
                ), // Warna track saat aktif
                thumbColor: Colors.white, // Warna tombol knob kaca
                onChanged: (val) {
                  setState(() {
                    _autoLanguage = val;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        const Text(
          'dloader will use your device\'s default language if translation is available. if not, english will be used instead.',
          style: TextStyle(fontSize: 12, color: Colors.white54, height: 1.4),
        ),
      ],
    );
  }
}
