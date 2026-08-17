import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/media_item.dart';
import '../services/cobalt_api_service.dart';
import '../services/media_downloader_service.dart';
import 'downloader_state.dart';

class DownloaderCubit extends Cubit<DownloaderState> {
  final CobaltApiService _cobaltApiService;
  final MediaDownloaderService _mediaDownloaderService;

  DownloaderCubit({
    CobaltApiService? cobaltApiService,
    MediaDownloaderService? mediaDownloaderService,
  })  : _cobaltApiService = cobaltApiService ?? CobaltApiService(),
        _mediaDownloaderService = mediaDownloaderService ?? MediaDownloaderService(),
        super(DownloaderInitial());

  /// Fetch media metadata from Instagram link
  Future<void> fetchMedia(String url, {String mode = 'auto'}) async {
    if (url.trim().isEmpty) {
      emit(const DownloaderFailure('Silakan tempelkan link Instagram terlebih dahulu'));
      return;
    }

    emit(DownloaderLoading());

    try {
      final mediaItem = await _cobaltApiService.extractMedia(url.trim(), mode: mode);
      emit(MediaExtractedSuccess(mediaItem));
    } catch (e) {
      emit(DownloaderFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Download media byte file and save directly to phone Gallery via `gal`
  Future<void> saveToGallery(MediaItem mediaItem) async {
    emit(DownloadingProgress(mediaItem, 0.0));

    try {
      await _mediaDownloaderService.downloadAndSaveToGallery(
        mediaItem,
        onProgress: (progress) {
          emit(DownloadingProgress(mediaItem, progress));
        },
      );
      emit(DownloadSuccess(mediaItem));
    } catch (e) {
      emit(DownloaderFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Reset state back to initial
  void reset() {
    emit(DownloaderInitial());
  }
}
