import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef OnError = void Function(Exception exception);

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
  // @override
  // _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<AudioPlayer> players =
  List.generate(4, (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop));
  int selectedPlayerIdx = 0;

  AudioPlayer get selectedPlayer => players[selectedPlayerIdx];
  List<StreamSubscription> streams = [];

  @override
  void initState() {
    super.initState();
    // var url = Uri.http('localhost:3000', 'song/url/v1?id=5267808&level=exhigh');
    // var response = http.get(url);
    // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    // var musicUrl = decodedResponse['url'] as String;
    // print(musicUrl);
    //
    // // http://localhost:3000/song/url/v1?id=33894312&level=exhigh
    // // var musicUrl = "https://m701.music.126.net/20220929175249/2c424d76fb57938e0d608e03e819e30d/jdyyaac/0753/525b/070e/09e1afd181e168ec37a20dd3f9ddd791.m4a";
    // // await player.setSourceUrl(url);
    // players[0].play(UrlSource(musicUrl));
    players.asMap().forEach((index, player) async {
      streams.add(
        player.onPlayerComplete.listen(
              (it) => print("2222"),
        ),
      );
      streams.add(
        player.onSeekComplete.listen(
              (it) => print("111"),
          ),
        );
    });
  }

  @override
  void dispose() {
    for (var it in streams) {
      it.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('rate your music'),
        ),
        body: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FloatingActionButton ( //FloatingActionButton 按钮
                    onPressed: () {
                      playMusic("33894312");
                    },
                    backgroundColor: Colors.lightGreen,
                    elevation: 20,
                    child: Icon(Icons.search),
                  ),
              ),
            ],
        ),
    );
  }

  playMusic(songId) async {
    var url = Uri.http('192.168.31.113:3000', '/song/url/v1', {'id': songId, 'level': 'exhigh'});
    // print(url);
    var response = await http.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var musicUrl = decodedResponse['data'][0]['url'] as String;
    var httpsMusicUrl = musicUrl.replaceAll("http", "https");
    // var musicUrl = "https://m701.music.126.net/20220929175249/2c424d76fb57938e0d608e03e819e30d/jdyyaac/0753/525b/070e/09e1afd181e168ec37a20dd3f9ddd791.m4a";
    // await player.setSourceUrl(url);
    players[0].stop();
    players[0].play(UrlSource(httpsMusicUrl));
  }
}