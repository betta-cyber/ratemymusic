import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

class playerSingleton {
  playerSingleton._internal();

  factory playerSingleton() => _instance;

  static late final playerSingleton _instance = playerSingleton._internal();

  var player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
}

var player = playerSingleton();

playMusic(url) async {
  player.player.stop();
  player.player.play(UrlSource(url));
}


// AudioPlayerHandler