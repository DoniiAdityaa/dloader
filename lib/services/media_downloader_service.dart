import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/media_item.dart';

class MediaDownloaderService {
  final Dio _dio = Dio();

  /// Requests storage/media permissions on Android/iOS
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final storage = await Permission.storage.request();
      final photos = await Permission.photos.request();
      final videos = await Permission.videos.request();
      return storage.isGranted || photos.isGranted || videos.isGranted;
    } else if (Platform.isIOS) {
      return await Gal.hasAccess();
    }
    return true;
  }

  /// Downloads byte file and saves directly to phone's native Gallery via `gal`
  Future<void> downloadAndSaveToGallery(
    MediaItem item, {
    required Function(double progress) onProgress,
  }) async {
    try {
      // 1. Ask Gal permission
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw Exception('Izin akses Galeri ditolak');
        }
      }

      // 2. Get temp directory path
      final tempDir = await getTemporaryDirectory();
      final extension = item.mediaType == 'photo' ? '.jpg' : '.mp4';
      final tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}$extension';

      // 3. Download file via Dio with progress callback
      await _dio.download(
        item.downloadUrl,
        tempPath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            onProgress(progress);
          }
        },
      );

      // 4. Save to Gallery using `gal`
      if (item.mediaType == 'photo') {
        await Gal.putImage(tempPath);
      } else {
        await Gal.putVideo(tempPath);
      }

      // 5. Clean temp file
      final file = File(tempPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Gagal menyimpan ke galeri: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }
}
