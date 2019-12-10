import 'dart:convert';

import '../models/api_models.dart';
import 'package:http/http.dart' as http;

class YoutubeApiProvider {
  String baseUrl =
      'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCxhygwqQ1ZMoBGQM2yEcNug&maxResults=50&order=date&key=AIzaSyC3aDSPhmhFiOV7P-W7kFy06bNyBa-Y0n8';
  final successCode = 200;

  Future<List<Items>> fetchAllVideo() async {
    final response = await http.get(baseUrl);

    return parseResponse(response);
  }

  Future<Items> fetchVideo() async {
    final response = await http.get(baseUrl);

    return parseResponse(response)[0];
  }

  List<Items> parseResponse(http.Response response) {
    final responseString = jsonDecode(response.body);

    if (response.statusCode == successCode) {
      return YoutubeApi.fromJson(responseString).items;
    } else {
      throw Exception('failed to load video');
    }
  }
}
