import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  String _selectedMode = 'auto';

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  // Function untuk membaca Clipboard & Paste otomatis
  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _urlController.text = clipboardData.text!;
      });
    }
  }

  // Function untuk hapus teks
  void _clearInput() {
    setState(() {
      _urlController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _brandHeader(),
                const SizedBox(height: 28),
                _maskotHero(),
                const SizedBox(height: 32),
                _inputSection(),
                const SizedBox(height: 16),
                _modeOptions(),
                const SizedBox(height: 12),
                _pasteAndDownloadButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Komponen Brand Header
  Widget _brandHeader() {
    return Column(
      children: const [
        Text(
          'DLoader',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'downloader — fast, clean, no ads',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white54,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // komponen maskot
  Widget _maskotHero() {
    return SizedBox(
      height: 180,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }

  // komponen Input Section
  Widget _inputSection() {
    final hasText = _urlController.text.isNotEmpty;
    return Row(
      children: [
        // Input Field Kaca (100% Full saat kosong, menyempit halus saat ada teks)
        Expanded(
          child: GlassTextField(
            controller: _urlController,
            height: 48,
            shape: const LiquidRoundedRectangle(borderRadius: 999),
            placeholder: 'paste the link here...',
            prefixIcon: const Icon(Icons.link_rounded, color: Colors.white70),
            // Tombol 'X' clear
            suffixIcon: hasText
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                    onPressed: _clearInput,
                  )
                : null,
            onChanged: (_) => setState(() {}),
          ),
        ),
        // Animasi "Tuing" Membal Tombol '>>' saat Ada Teks
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          child: AnimatedScale(
            scale: hasText ? 1.0 : 0.0, // Scale 0 -> 1 saat teks terisi
            duration: const Duration(milliseconds: 400),
            curve: Curves
                .elasticOut, // 👈 Kurva 'elasticOut' untuk efek membal "Tuing"!
            alignment: Alignment.center,
            child: hasText
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RepaintBoundary(
                      child: GlassIconButton(
                        icon: const Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          // Pemicu fetch media
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  // komponen action buttons
  Widget _modeOptions() {
    final isAuto = _selectedMode == 'auto';
    final isAudio = _selectedMode == 'audio';
    final isMute = _selectedMode == 'mute';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GlassChip(
          label: 'auto',
          selected: isAuto,
          selectedColor: Colors.white.withValues(alpha: 0.25),
          icon: const Icon(Icons.auto_awesome_rounded, size: 14),
          onTap: () => setState(() => _selectedMode = 'auto'),
        ),
        GlassChip(
          label: 'audio',
          selected: isAudio,
          selectedColor: Colors.white.withValues(alpha: 0.25),
          icon: const Icon(Icons.music_note_rounded, size: 14),
          onTap: () => setState(() => _selectedMode = 'audio'),
        ),
        GlassChip(
          label: 'mute',
          selected: isMute,
          selectedColor: Colors.white.withValues(alpha: 0.25),
          icon: const Icon(Icons.volume_off_rounded, size: 14),
          onTap: () => setState(() => _selectedMode = 'mute'),
        ),
      ],
    );
  }

  /// Tombol Utama Lebar: Paste & Download
  Widget _pasteAndDownloadButton() {
    return GlassButton.custom(
      height: 50,
      shape: const LiquidRoundedRectangle(
        borderRadius: 999,
      ), // 👈 Bentuk tombol persegi melayang
      onTap: () async {
        await _pasteFromClipboard();
        if (_urlController.text.isNotEmpty) {
          FocusScope.of(context).unfocus();
          // Pemicu fetch & download!
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.assignment_rounded, size: 18, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'paste and download',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
