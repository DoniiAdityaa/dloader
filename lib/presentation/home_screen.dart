import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../cubit/downloader_cubit.dart';
import '../cubit/downloader_state.dart';
import '../models/media_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  String _selectedMode = 'auto'; // 'auto', 'audio', 'mute'

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
    context.read<DownloaderCubit>().reset();
  }

  // Action pemicu download
  void _triggerDownload() {
    if (_urlController.text.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      context.read<DownloaderCubit>().fetchMedia(
            _urlController.text.trim(),
            mode: _selectedMode,
          );
    }
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
            child: BlocConsumer<DownloaderCubit, DownloaderState>(
              listener: (context, state) {
                if (state is MediaExtractedSuccess) {
                  // Otomatis mulai unduh byte file & simpan ke galeri
                  context.read<DownloaderCubit>().saveToGallery(state.mediaItem);
                } else if (state is DownloadSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Berhasil tersimpan di Galeri!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (state is DownloaderFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('⚠️ ${state.errorMessage}'),
                      backgroundColor: Colors.redAccent,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _brandHeader(),
                    const SizedBox(height: 28),
                    _maskotHero(),
                    const SizedBox(height: 32),
                    _inputSection(state is DownloaderLoading),
                    const SizedBox(height: 16),
                    _modeOptions(),
                    const SizedBox(height: 12),
                    _pasteAndDownloadButton(state is DownloaderLoading),
                    
                    // Card Preview & State Dynamic
                    if (state is! DownloaderInitial) ...[
                      const SizedBox(height: 20),
                      _mediaPreviewSection(state),
                    ],
                  ],
                );
              },
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
        SizedBox(height: 4),
        Text(
          'download any instagram reels & photos in seconds',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white54,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // Komponen Maskot Hero Image
  Widget _maskotHero() {
    return Image.asset(
      'assets/images/logo.png',
      height: 130,
      fit: BoxFit.contain,
    );
  }

  // Komponen Input Field Link dengan animasi tuing button >>
  Widget _inputSection(bool isLoading) {
    final hasText = _urlController.text.isNotEmpty;

    return Row(
      children: [
        // Input Field Kaca
        Expanded(
          child: GlassTextField(
            controller: _urlController,
            height: 48,
            shape: const LiquidRoundedRectangle(borderRadius: 999),
            placeholder: 'paste the link here...',
            prefixIcon: const Icon(Icons.link_rounded, color: Colors.white70),
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
                        icon: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.keyboard_double_arrow_right_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                        onPressed: isLoading ? null : _triggerDownload,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  // Komponen Mode Options Chips (auto, audio, mute)
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

  // Tombol Utama Lebar: Paste & Download
  Widget _pasteAndDownloadButton(bool isLoading) {
    return GlassButton.custom(
      height: 50,
      shape: const LiquidRoundedRectangle(borderRadius: 999),
      onTap: () {
        if (!isLoading) {
          _pasteFromClipboard().then((_) => _triggerDownload());
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'memproses link...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else ...[
            const Icon(Icons.assignment_rounded, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'paste and download',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Komponen Kartu Hasil Preview & Status Downloader
  Widget _mediaPreviewSection(DownloaderState state) {
    if (state is DownloaderLoading) {
      return GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 14),
            Text(
              'Mengekstrak media dari Instagram...',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      );
    }

    MediaItem? item;
    double progress = 0.0;
    bool isSuccess = false;

    if (state is MediaExtractedSuccess) {
      item = state.mediaItem;
    } else if (state is DownloadingProgress) {
      item = state.mediaItem;
      progress = state.progress;
    } else if (state is DownloadSuccess) {
      item = state.mediaItem;
      isSuccess = true;
      progress = 1.0;
    }

    if (item == null) return const SizedBox.shrink();

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
              child: item.thumbnailUrl != null
                  ? Image.network(
                      item.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.movie_rounded, size: 48, color: Colors.white54),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        size: 56,
                        color: Colors.white70,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mode $_selectedMode • Format: .${item.mediaType == 'photo' ? 'jpg' : 'mp4'} (HD)',
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),
          const SizedBox(height: 16),

          if (isSuccess) ...[
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
                    'Tersimpan di Galeri HP!',
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Mengunduh & Menyimpan... ${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
