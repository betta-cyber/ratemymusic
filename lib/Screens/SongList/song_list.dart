import 'package:flutter/material.dart';
import 'package:ratemymusic/APIs/api.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ratemymusic/Screens/Player/audioplayer.dart';
import 'package:ratemymusic/Services/audio_service.dart';

class SongsListPage extends StatefulWidget {
  final Map listItem;

  const SongsListPage({
    super.key,
    required this.listItem,
  });

  @override
  _SongsListPageState createState() => _SongsListPageState();
}

class _SongsListPageState extends State<SongsListPage> {
  int page = 1;
  bool loading = false;
  List songList = [];
  bool fetched = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchSongs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          widget.listItem['type'].toString() == 'songs' &&
          !loading) {
        page += 1;
        _fetchSongs();
      }
    });
  }

  void _fetchSongs() {
    loading = true;
    widget.listItem['type'] == 'songs';
    switch (widget.listItem['type'].toString()) {
      case 'songs':
        getSongList("111").then((value) {
          setState(() {
            songList.addAll(value as List);
            fetched = true;
            loading = false;
          });
        });
        break;
    }
  }

  List<Widget> _getSongList() {
    return songList.map((item) {
      return Card(
          child: ListTile(
              title: Text(item['name']),
              onTap: () async {
                var url = await getSongUrl('${item['id']}');
                playMusic(url);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => PlayScreen(
                            songsList: songList,
                            index: songList.indexOf(item),
                          )),
                );
              }));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: !fetched
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: _getSongList(),
              // children: <Widget>[_getSongList()],
            ),
    );
  }
}
