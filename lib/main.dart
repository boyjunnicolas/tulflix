import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  YoutubePlayerController _controller;
  Map data;
  int currentVideoId = Random().nextInt(50);
  String currentTitle = '';

  Future getData() async {
    http.Response response = await http.get(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCxhygwqQ1ZMoBGQM2yEcNug&maxResults=50&key=AIzaSyC3aDSPhmhFiOV7P-W7kFy06bNyBa-Y0n8');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      data = json.decode(response.body);

      if (data != null) {
        setState(() {
          _controller = YoutubePlayerController(
            initialVideoId:
                data['items'][currentVideoId]['id']['videoId'].toString(),
            flags: YoutubePlayerFlags(
              mute: false,
              autoPlay: false,
              forceHideAnnotation: true,
            ),
          );

          currentTitle =
              data['items'][currentVideoId]['snippet']['title'].toString();
        });
      } else {
        print('error');
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  void reloadPlayer() {
    _controller.load(data['items'][currentVideoId]['id']['videoId'].toString());
    currentTitle = data['items'][currentVideoId]['snippet']['title'].toString();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tulflix'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              //width: MediaQuery.of(context).size.width,
              //
              child: Center(
                child: _controller != null
                    ? YoutubePlayer(
                        width: 500.0,
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        progressColors: ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent,
                        ),
                        onReady: () {
                          print('Player is ready.');
                        },
                      )
                    : CircularProgressIndicator(),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        currentTitle,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 400.0, //Your custom height
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: data['items'].length,
                itemBuilder: (context, index) {
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentVideoId = index;
                          reloadPlayer();
                        });
                      },
                      child: index != currentVideoId
                          ? Container(
                              padding: new EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 6.0),
                              margin: EdgeInsets.symmetric(vertical: 6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Image.network(
                                        data['items'][index]['snippet']
                                                ['thumbnails']['default']['url']
                                            .toString(),
                                        width: double.parse(data['items'][index]
                                                    ['snippet']['thumbnails']
                                                ['default']['width']
                                            .toString()),
                                        height: double.parse(data['items']
                                                        [index]['snippet']
                                                    ['thumbnails']['default']
                                                ['height']
                                            .toString()),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 20.0)),
                                      Expanded(
                                        child: Text(
                                          data['items'][index]['snippet']
                                                  ['title']
                                              .toString(),
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.clip,
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  );
                },
              ).build(context),
            ),
          ],
        ),
      ),
    );
  }
}
