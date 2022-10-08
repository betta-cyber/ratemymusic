import 'package:flutter/material.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ListTile(
          leading: Icon(Icons.album),
          title: Text('The Enchanted Nightingale'),
          subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text('BUY TICKETS'),
              onPressed: () {/* ... */},
            ),
            const SizedBox(width: 8),
            TextButton(
              child: const Text('LISTEN'),
              onPressed: () {/* ... */},
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ));
    // throw UnimplementedError();
  }
}
