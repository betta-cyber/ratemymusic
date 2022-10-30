import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

var base_url = '192.168.31.114:3000';

getSongUrl(songId) async {
  var url =
      Uri.http(base_url, '/song/url/v1', {'id': songId, 'level': 'exhigh'});
  // print(url);
  var response = await http.get(url);
  var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var musicUrl = decodedResponse['data'][0]['url'] as String;
  var httpsMusicUrl = musicUrl.replaceAll("http", "https");
  return httpsMusicUrl;
}

getPersonalFm(songListId) async {
  var url = Uri.http(base_url, '/personal_fm');
  // print(url);
  var response = await http.get(url);
  var decodedResponse =
      await jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var songList = decodedResponse['data'];
  return songList;
}

getSongList(songListId) async {
  var url = Uri.http(base_url, '/playlist/track/all', {'id': songListId});
  print(url);
  var response = await http.get(url);
  var decodedResponse =
      await jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var songList = decodedResponse['songs'];
  return songList;
}
