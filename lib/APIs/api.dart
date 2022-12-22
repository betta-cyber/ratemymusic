import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

var baseUrl = '0.0.0.0:3000';

getSongUrl(songId) async {
  var url =
      Uri.http(baseUrl, '/song/url/v1', {'id': songId, 'level': 'exhigh'});
  // print(url);
  var response = await http.get(url);
  var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var musicUrl = decodedResponse['data'][0]['url'] as String;
  var httpsMusicUrl = musicUrl.replaceAll("http", "https");
  return httpsMusicUrl;
}

getPersonalFm(songListId) async {
  var url = Uri.http(baseUrl, '/personal_fm');
  // print(url);
  var response = await http.get(url);
  var decodedResponse =
      await jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var songList = decodedResponse['data'];
  return songList;
}

getSongList(songListId) async {
  var url = Uri.http(baseUrl, '/playlist/track/all', {'id': songListId});
  // print(url);
  var response = await http.get(url);
  var decodedResponse =
      await jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  var songList = decodedResponse['songs'];
  return songList;
}
