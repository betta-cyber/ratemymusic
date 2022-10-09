import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:ratemymusic/CustomWidgets/animated_text.dart';
import 'package:flutter/material.dart';

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
              color: Colors.black,
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

  const NameNControls({
    super.key,
    required this.width,
    required this.height,
    required this.mediaItem,
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
                    ])))
          ])
        ]));
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
                  imageUrl: widget.mediaItem['album']['picUrl'].toString(),
                  width: widget.width * 0.85,
                ),
              ),
            ],
          ),
          back: Container(
            child: Text(
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
