import 'package:devoxx_flutter/src/layout.dart';
import 'package:devoxx_flutter/src/screens/pinned_talks_screen.dart';
import 'package:devoxx_flutter/src/screens/speakers_screen.dart';
import 'package:flutter/material.dart';

class DevoxxFlutter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DevoxxFlutter();
}

class _DevoxxFlutter extends State<DevoxxFlutter> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.amber),
      home: new Layout(),
      routes: <String, WidgetBuilder> {
        '/speakers': (BuildContext context) => new SpeakersPage(),
        '/talks/pinned': (BuildContext context) => new PinnedTalksPage(),
      },
    );
  }

}
