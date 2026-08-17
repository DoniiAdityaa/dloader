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
  bool _showPreview = false;

  bool _isDownloadloading = false;
  double _downloadProgress = 0.0;
  bool _isDownloadedSuccess = false;

  // function
  void _startSimulatedDownload() async {
    setState(() {
      _isDownloadloading = true;
      _downloadProgress = 0.0;
      _isDownloadedSuccess = false;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _downloadProgress = i / 100.0;
      });
    }
    setState(() {
      _isDownloadloading = false;
      _isDownloadedSuccess = true;
    });
  }

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
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 20,
              bottom: 100,
            ),
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
                if (_showPreview) ...[
                  const SizedBox(height: 20),
                  _mediaPreviewCard(),
                ],
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
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          child: AnimatedScale(
            scale: hasText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
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
                          setState(() {
                            _showPreview = true;
                          });
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

  //  komponen kartu hasil preview (function)
  Widget _mediaPreviewCard() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.08),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  size: 56,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Instagram Reels Video',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mode $_selectedMode • Format: .mp4 (HD)',
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),
          const SizedBox(height: 16),
          if (_isDownloadloading) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _downloadProgress,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Mengunduh... ${(_downloadProgress * 100).toInt()}%',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ] else if (_isDownloadedSuccess) ...[
            // Tombol Sukses Centang
            Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.greenAccent,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tersimpan di Galeri!',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Tombol Biasa "Simpan ke Galeri"
            SizedBox(
              width: double.infinity,
              child: GlassButton.custom(
                height: 44,
                shape: const LiquidRoundedRectangle(borderRadius: 12),
                onTap: _startSimulatedDownload,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.download_rounded, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Simpan ke Galeri',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
