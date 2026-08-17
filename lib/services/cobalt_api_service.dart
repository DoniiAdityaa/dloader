import 'package:dio/dio.dart';
import '../models/media_item.dart';

class CobaltApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.cobalt.tools',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'User-Agent': 'dloader-app/1.0',
      },
    ),
  );

  /// Extract media download URL from Instagram / any supported platform link
  Future<MediaItem> extractMedia(String url, {String mode = 'auto'}) async {
    try {
      final response = await _dio.post(
        '/',
        data: {
          'url': url,
          'downloadMode': mode,
          'videoQuality': 'max',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'] as String? ?? '';

        if (status == 'error') {
          final errorText = data['text'] as String? ?? 'Gagal memproses link';
          throw Exception(errorText);
        }

        return MediaItem.fromCobaltJson(data, url);
      } else {
        throw Exception('Server mengembalikan respon (${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Koneksi internet lambat / timeout');
      } else if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('text')) {
          throw Exception(data['text']);
        }
      }
      throw Exception('Gagal terhubung ke Cobalt API: ${e.message}');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
