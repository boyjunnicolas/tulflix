import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class YoutubePlayerEvent extends Equatable {
  YoutubePlayerEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class FetchVideos extends YoutubePlayerEvent {}

class SelectVideo extends YoutubePlayerEvent {
  SelectVideo(this.videoId) : super([videoId]);
  final videoId;
}
