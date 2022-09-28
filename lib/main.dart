import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
    var url = "https://m10.music.126.net/20220929022513/0c8b97d851b61ce2b05982e6f65d5b4d/yyaac/obj/wonDkMOGw6XDiTHCmMOi/14055822107/9a2a/cbdb/34bd/85cb496fdec5db6b2c15777e306fa338.m4a";
    // await player.setSourceUrl(url);
    players[0].play(UrlSource(url));
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
          title: const Text('audio players'),
        ),
        body: Column(
            children: const [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('1111'),
              ),
            ],
        ),
    );
  }
}