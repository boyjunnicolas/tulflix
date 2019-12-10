import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tulflix/models/api_models.dart';
import './bloc.dart';
import 'package:tulflix/services/youtube_api_provider.dart';

class YoutubePlayerBloc extends Bloc<YoutubePlayerEvent, YoutubePlayerState> {
  YoutubePlayerBloc(this.youtubeApiProvider);

  final YoutubeApiProvider youtubeApiProvider;
  @override
  YoutubePlayerState get initialState => InitialYoutubePlayerState();

  @override
  Stream<YoutubePlayerState> mapEventToState(
    YoutubePlayerEvent event,
  ) async* {
    if (event is FetchVideos) {
      yield VideosLoading();
      List<Items> _videos = await youtubeApiProvider.fetchAllVideo();
      yield VideosLoaded(_videos);
    }

    if (event is SelectVideo) {
      yield YoutubePlayerLoading();
      Items video = await youtubeApiProvider.fetchVideo();
      yield YoutubePlayerLoaded(video);
    }
  }
}
