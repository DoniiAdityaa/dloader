import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'settings/appearance_setting_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCategory = 'appearance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Pinned Header (Header diam di atas persis seperti HistoryScreen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(child: _settingsHeader()),
            ),

            // 2. Scrollable Settings Categories
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 8,
                  bottom: 100,
                ),
                child: _settingsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Fixed Header Title (Monospace Center)
  Widget _settingsHeader() {
    return Column(
      children: const [
        Text(
          'Settings',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// 2. Glass Settings Category Cards (Desain Cobalt UI)
  Widget _settingsList() {
    final categories = [
      {
        'key': 'appearance',
        'label': 'appearance',
        'icon': Icons.wb_sunny_rounded,
        'color': Colors.blueAccent,
      },
      {
        'key': 'accessibility',
        'label': 'accessibility',
        'icon': Icons.accessibility_new_rounded,
        'color': Colors.purpleAccent,
      },
      {
        'key': 'video',
        'label': 'video',
        'icon': Icons.movie_creation_rounded,
        'color': Colors.redAccent,
      },
      {
        'key': 'audio',
        'label': 'audio',
        'icon': Icons.music_note_rounded,
        'color': Colors.orangeAccent,
      },
      {
        'key': 'metadata',
        'label': 'metadata',
        'icon': Icons.file_download_outlined,
        'color': Colors.greenAccent,
      },
      {
        'key': 'privacy',
        'label': 'privacy',
        'icon': Icons.lock_outline_rounded,
        'color': Colors.cyanAccent,
      },
      {
        'key': 'advanced',
        'label': 'advanced',
        'icon': Icons.tune_rounded,
        'color': Colors.amberAccent,
      },
    ];

    return Column(
      children: categories.map((cat) {
        final isSelected = _selectedCategory == cat['key'];
        final iconColor = cat['color'] as Color;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat['key'] as String;
              });
              if (cat['key'] == 'appearance') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppearanceSettingScreen(),
                  ),
                );
              }
            },
            child: GlassCard(
              shape: const LiquidRoundedRectangle(borderRadius: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon Tile Box dengan Warna Accent Khas Cobalt
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Label Teks Kategori
                  Expanded(
                    child: Text(
                      cat['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Indikator Panah
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white38,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
