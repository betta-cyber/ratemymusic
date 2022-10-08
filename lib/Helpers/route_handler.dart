import 'package:flutter/material.dart';
import 'package:rateyourmusic/Screens/SongList/song_list.dart';

class HandleRoute {
  static Route? handleRoute(String? url) {
    if (url == null) return null;
    if (url.contains('saavn')) {
      final RegExpMatch? songResult =
          RegExp(r'.*saavn.com.*?\/(song)\/.*?\/(.*)').firstMatch('$url?');
      if (songResult != null) {
        return PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => UrlHandler(
            token: songResult[2]!,
            type: songResult[1]!,
          ),
        );
      } else {
        final RegExpMatch? playlistResult = RegExp(
          r'.*saavn.com\/?s?\/(featured|playlist|album)\/.*\/(.*_)?[?/]',
        ).firstMatch('$url?');
        if (playlistResult != null) {
          return PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => UrlHandler(
              token: playlistResult[2]!,
              type: playlistResult[1]!,
            ),
          );
        }
      }
    } else if (url.contains('spotify')) {
      // TODO: Add support for spotify links
      // print('it is a spotify link');
    } else if (url.contains('youtube')) {
      // TODO: Add support for youtube links
      // print('it is an youtube link');
      final RegExpMatch? videoId =
          RegExp(r'.*\.com\/watch\?v=(.*)\?').firstMatch('$url?');
      if (videoId != null) {
        // TODO: Extract audio data and play audio
        // return PageRouteBuilder(
        //   opaque: false,
        //   pageBuilder: (_, __, ___) => YtUrlHandler(
        //     id: songResult[1]!,
        //     type: song,
        //   ),
        // );
      }
    }
    return null;
  }
}

class UrlHandler extends StatelessWidget {
  final String token;
  final String type;
  const UrlHandler({super.key, required this.token, required this.type});

  @override
  Widget build(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const SongsListPage(
          listItem: {},
        ),
      ),
    );
    return Container();
  }
}

// class OfflinePlayHandler extends StatelessWidget {
//   final String id;
//   const OfflinePlayHandler({super.key, required this.id});
//
//   Future<List> playOfflineSong(String id) async {
//     final OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
//     await offlineAudioQuery.requestPermission();
//
//     final List<SongModel> songs = await offlineAudioQuery.getSongs();
//     final int index = songs.indexWhere((i) => i.id.toString() == id);
//
//     return [index, songs];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     playOfflineSong(id).then((value) {
//       Navigator.pushReplacement(
//         context,
//         PageRouteBuilder(
//           opaque: false,
//           pageBuilder: (_, __, ___) => PlayScreen(
//             songsList: value[1] as List<SongModel>,
//             index: value[0] as int,
//             offline: true,
//             fromDownloads: false,
//             recommend: false,
//             fromMiniplayer: false,
//           ),
//         ),
//       );
//     });
//     return Container();
//   }
// }
