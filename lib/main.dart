import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ratemymusic/Screens/SongList/song_list.dart';
import 'package:ratemymusic/Helpers/route_handler.dart';
import 'package:ratemymusic/APIs/api.dart';
import 'package:get_it/get_it.dart';
import 'package:ratemymusic/CustomWidgets/bottom_navigation.dart';

typedef OnError = void Function(Exception exception);

Future<void> main() async {
  runApp(const MaterialApp(home: MainApp()));
  await startService();
}

Future<void> startService() async {
  final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  GetIt.I.registerSingleton<AudioPlayer>(player);
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<AudioPlayer> players =
      List.generate(1, (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop));
  int selectedPlayerIdx = 0;
  int selectedIndex = 0;

  AudioPlayer get selectedPlayer => players[selectedPlayerIdx];
  List<StreamSubscription> streams = [];
  List<Widget> _bottomNavPages = [];

  @override
  void initState() {
    super.initState();
    var apage = Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, 'playlists');
        },
        child: const Text('sss'),
      ),
    );
    _bottomNavPages..add(SongsListPage(listItem: {"type": "songs"}));
    _bottomNavPages..add(apage);
    _bottomNavPages..add(SongsListPage(listItem: {"type": "songs"}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return Scaffold(
              body: _bottomNavPages[selectedIndex],
              bottomNavigationBar: BottomNavigation(
                selectedIndex: selectedIndex,
              ));
        },
        '/about': (BuildContext context) {
          return Scaffold();
        },
        '/playlists': (context) => Scaffold(
            body: SongsListPage(
              listItem: {"type": "songs"},
            ),
            bottomNavigationBar: BottomNavigation(
              selectedIndex: 0,
            )),
      },
      onGenerateRoute: (RouteSettings settings) {
        return HandleRoute.handleRoute(settings.name);
      },
    );
  }
}
