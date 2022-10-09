import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ratemymusic/Screens/SongList/song_list.dart';
import 'package:ratemymusic/Helpers/route_handler.dart';
import 'package:ratemymusic/APIs/api.dart';

typedef OnError = void Function(Exception exception);

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
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
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Home Route'),
              ),
              body: Center(
                  child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/playlists');
                },
                child: Text('1111'),
              )));
        },
        '/about': (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('About Route'),
            ),
          );
        },
        '/playlists': (context) => const SongsListPage(
              listItem: {"type": "songs"},
            ),
      },
      onGenerateRoute: (RouteSettings settings) {
        return HandleRoute.handleRoute(settings.name);
      },
    );
  }

  // playMusic(songId) async {
  //   players[0].stop();
  //   var url = await getSongUrl(songId);
  //   players[0].play(UrlSource(url));
  // }
}
