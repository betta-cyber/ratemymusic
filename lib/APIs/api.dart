import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

getSongUrl(songId) async {
  var url = Uri.http(
      '192.168.31.94:3000', '/song/url/v1', {'id': songId, 'level': 'exhigh'});
  // print(url);
  var response = await http.get(url);
  var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var musicUrl = decodedResponse['data'][0]['url'] as String;
  var httpsMusicUrl = musicUrl.replaceAll("http", "https");
  return httpsMusicUrl;
}

getSongList(songListId) async {
  var url = Uri.http('192.168.31.94:3000', '/personal_fm');
  // print(url);
  var response = await http.get(url);
  var decodedResponse =
      await jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var songList = decodedResponse['data'];
  return songList;
}
