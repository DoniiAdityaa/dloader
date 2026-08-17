class MediaItem {
  final String originalUrl;
  final String downloadUrl;
  final String? thumbnailUrl;
  final String filename;
  final String mediaType; // 'video', 'photo', 'audio', 'picker'
  final String title;
  final String? size;

  const MediaItem({
    required this.originalUrl,
    required this.downloadUrl,
    this.thumbnailUrl,
    required this.filename,
    required this.mediaType,
    required this.title,
    this.size,
  });

  factory MediaItem.fromCobaltJson(Map<String, dynamic> json, String originalUrl) {
    // Status 'stream' atau 'redirect'
    String downloadUrl = json['url'] as String? ?? '';
    String filename = json['filename'] as String? ?? 'dloader_media';
    String mediaType = 'video';

    if (downloadUrl.endsWith('.mp3') || downloadUrl.contains('audio')) {
      mediaType = 'audio';
    } else if (downloadUrl.endsWith('.jpg') || downloadUrl.endsWith('.png') || downloadUrl.endsWith('.webp')) {
      mediaType = 'photo';
    }

    return MediaItem(
      originalUrl: originalUrl,
      downloadUrl: downloadUrl,
      thumbnailUrl: json['picker'] != null && (json['picker'] as List).isNotEmpty
          ? (json['picker'] as List).first['thumb'] as String?
          : null,
      filename: filename,
      mediaType: mediaType,
      title: 'Instagram $mediaType',
      size: 'HD',
    );
  }
}
