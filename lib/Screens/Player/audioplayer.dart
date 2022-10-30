import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:ratemymusic/CustomWidgets/animated_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../APIs/api.dart';

class PlayScreen extends StatefulWidget {
  final List songsList;
  final int index;
  const PlayScreen({super.key, required this.songsList, required this.index});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayScreen> {
  final String repeatMode = "All";
  List globalQueue = [];
  int globalIndex = 0;
  final AudioPlayer audioHandler = GetIt.I<AudioPlayer>();

  @override
  void initState() {
    super.initState();
    // main();
    var response = widget.songsList;
    globalIndex = widget.index;
    if (globalIndex == -1) {
      globalIndex = 0;
    }
    globalQueue = response;
    updatePlayer();
  }

  Future<void> updatePlayer() async {
    // await audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    // await audioHandler.updateQueue(globalQueue);
    // await audioHandler.skipToQueueItem(globalIndex);
    // await audioHandler.play();
    // if (enforceRepeat) {
    //   switch (repeatMode) {
    //     case 'None':
    //       audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    //       break;
    //     case 'All':
    //       audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
    //       break;
    //     case 'One':
    //       audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    //       break;
    //     default:
    //       break;
    //   }
    // } else {
    //   audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    //   Hive.box('settings').put('repeatMode', 'None');
    // }
    audioHandler.stop();
    var songId = globalQueue[globalIndex]['id'];
    var musicUrl = await getSongUrl("$songId");
    audioHandler.play(UrlSource(musicUrl));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.expand_more_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            final MediaItem = globalQueue[globalIndex];
            return Container(
              color: Colors.cyan,
              child: Column(
                children: [
                  // Artwork
                  ArtWorkWidget(
                    // cardKey: cardKey,
                    mediaItem: MediaItem,
                    width: constraints.maxWidth,
                    // audioHandler: audioHandler,
                    // offline: offline,
                    // getLyricsOnline: getLyricsOnline,
                  ),

                  // title and controls
                  NameNControls(
                    width: constraints.maxWidth,
                    height:
                        constraints.maxHeight - (constraints.maxWidth * 0.85),
                    mediaItem: MediaItem,
                    audioHandler: audioHandler,
                  ),
                ],
              ),
            );
          },
        ));
    // throw UnimplementedError();
  }
}

class NameNControls extends StatelessWidget {
  // final MediaItem mediaItem;
  final double width;
  final double height;
  final mediaItem;
  final audioHandler;

  const NameNControls({
    super.key,
    required this.width,
    required this.height,
    required this.mediaItem,
    required this.audioHandler,
    // // required this.gradientColor,
    // required this.audioHandler,
    // required this.panelController,
    // this.offline = false,
  });

  @override
  Widget build(BuildContext context) {
    // print(mediaItem['name']);
    final double titleBoxHeight = height * 0.25;

    return SizedBox(
        width: width,
        height: height,
        child: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                        height: titleBoxHeight / 10,
                      ),
                      AnimatedText(
                        text: mediaItem['name'],
                        pauseAfterRound: const Duration(seconds: 3),
                        showFadingOnlyWhenScrolling: false,
                        fadingEdgeEndFraction: 0.1,
                        fadingEdgeStartFraction: 0.1,
                        startAfter: const Duration(seconds: 2),
                        style: TextStyle(
                          fontSize: titleBoxHeight / 2.75,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),

                      /// 空行
                      SizedBox(
                        height: titleBoxHeight / 40,
                      ),

                      /// 艺术家 和 专辑名
                      AnimatedText(
                        text:
                            '${mediaItem['ar'][0]['name'] ?? "Unknown"} • ${mediaItem['al']['name'] ?? "Unknown"}',
                        pauseAfterRound: const Duration(seconds: 3),
                        showFadingOnlyWhenScrolling: false,
                        fadingEdgeEndFraction: 0.1,
                        fadingEdgeStartFraction: 0.1,
                        startAfter: const Duration(seconds: 2),
                        style: TextStyle(
                          fontSize: titleBoxHeight / 6.75,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),

                      /// 控制按钮
                      ControlButtons(audioHandler),
                    ])))
          ])
        ]));
  }
}

class ControlButtons extends StatelessWidget {
  final bool shuffle;
  final List buttons;
  final AudioPlayer audioHandler;
  final Color? dominantColor;

  const ControlButtons(
    this.audioHandler, {
    this.shuffle = false,
    // this.miniplayer = false,
    this.buttons = const ['Previous', 'Play/Pause', 'Next'],
    this.dominantColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((e) {
        switch (e) {
          case 'Previous':
            return IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              iconSize: 45.0,
              tooltip: "Previous",
              color: dominantColor ?? Theme.of(context).iconTheme.color,
              onPressed: null,
            );
          case 'Play/Pause':
            var playing =
                (audioHandler.state == PlayerState.playing) ? false : true;
            return SizedBox(
                height: 65.0,
                width: 65.0,
                child: Stack(
                  children: [
                    Center(
                      child: playing
                          ? IconButton(
                              tooltip: "pause",
                              onPressed: () => audioHandler.pause(),
                              icon: const Icon(
                                Icons.pause_rounded,
                              ),
                              color: dominantColor ??
                                  Theme.of(context).iconTheme.color,
                            )
                          : IconButton(
                              tooltip: "play",
                              onPressed: () => audioHandler.resume(),
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                              ),
                              color: dominantColor ??
                                  Theme.of(context).iconTheme.color,
                            ),
                    )
                  ],
                ));
          case 'Next':
            return IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              iconSize: 45.0,
              tooltip: "Next",
              color: dominantColor ?? Theme.of(context).iconTheme.color,
              onPressed: null,
            );
          default:
            break;
        }
        return const SizedBox();
      }).toList(),
    );
  }
}

class ArtWorkWidget extends StatefulWidget {
  // final GlobalKey<FlipCardState> cardKey;
  final mediaItem;
  // final bool offline;
  // final bool getLyricsOnline;
  final double width;
  // final AudioPlayerHandler audioHandler;

  const ArtWorkWidget({
    // required this.cardKey,
    required this.mediaItem,
    required this.width,
    // this.offline = false,
    // required this.getLyricsOnline,
    // required this.audioHandler,
  });

  @override
  _ArtWorkWidgetState createState() => _ArtWorkWidgetState();
}

class _ArtWorkWidgetState extends State<ArtWorkWidget> {
  // final ValueNotifier<bool> dragging = ValueNotifier<bool>(false);
  // final ValueNotifier<bool> done = ValueNotifier<bool>(false);
  // Map lyrics = {'id': '', 'lyrics': ''};

  @override
  Widget build(BuildContext context) {
    // print(widget.mediaItem['album']['picUrl']);
    return SizedBox(
      height: widget.width * 0.85,
      width: widget.width * 0.85,
      child: Hero(
        tag: 'currentArtwork',
        child: FlipCard(
          fill: Fill
              .fillBack, // Fill the back side of the card to make in the same size as the front.
          direction: FlipDirection.HORIZONTAL, // default
          front: Stack(
            alignment: Alignment.center,
            children: [
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  errorWidget: (BuildContext context, _, __) => const Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/cover.jpg'),
                  ),
                  placeholder: (BuildContext context, _) => const Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/cover.jpg'),
                  ),
                  imageUrl: widget.mediaItem['al']['picUrl'].toString(),
                  width: widget.width * 0.85,
                ),
              ),
            ],
          ),
          back: Container(
            child: const Text(
              'Back',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
