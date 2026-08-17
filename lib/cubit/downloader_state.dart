import 'package:equatable/equatable.dart';
import '../models/media_item.dart';

abstract class DownloaderState extends Equatable {
  const DownloaderState();

  @override
  List<Object?> get props => [];
}

class DownloaderInitial extends DownloaderState {}

class DownloaderLoading extends DownloaderState {}

class MediaExtractedSuccess extends DownloaderState {
  final MediaItem mediaItem;

  const MediaExtractedSuccess(this.mediaItem);

  @override
  List<Object?> get props => [mediaItem];
}

class DownloadingProgress extends DownloaderState {
  final MediaItem mediaItem;
  final double progress; // 0.0 - 1.0

  const DownloadingProgress(this.mediaItem, this.progress);

  @override
  List<Object?> get props => [mediaItem, progress];
}

class DownloadSuccess extends DownloaderState {
  final MediaItem mediaItem;

  const DownloadSuccess(this.mediaItem);

  @override
  List<Object?> get props => [mediaItem];
}

class DownloaderFailure extends DownloaderState {
  final String errorMessage;

  const DownloaderFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
