import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class YoutubePlayerState extends Equatable {
  YoutubePlayerState([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class InitialYoutubePlayerState extends YoutubePlayerState {}

class VideosLoading extends YoutubePlayerState {}

class VideosLoaded extends YoutubePlayerState {
  VideosLoaded(this.videos) : super([videos]);
  final List videos;
}

class YoutubePlayerLoading extends YoutubePlayerState {}

class YoutubePlayerLoaded extends YoutubePlayerState {
  YoutubePlayerLoaded(this.video) : super([video]);
  final video;
}

class YoutubePlayerError extends YoutubePlayerState {}
