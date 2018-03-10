import 'package:devoxx_flutter/src/layout.dart';
import 'package:devoxx_flutter/src/screens/pinned_talks_screen.dart';
import 'package:devoxx_flutter/src/screens/slot_list_screen.dart';
import 'package:devoxx_flutter/src/screens/speakers_screen.dart';
import 'package:flutter/material.dart';

class DevoxxFlutter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DevoxxFlutter();
}

class _DevoxxFlutter extends State<DevoxxFlutter> {
  Layout layout = new Layout();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.amber),
      routes: <String, WidgetBuilder> {
        '/': (BuildContext context) => buildHomePage(),
        '/speakers': (BuildContext context) => buildSpeakerPage(),
        '/talks/pinned': (BuildContext context) => buildPinnedTalkPage(),
      },
    );
  }

  Layout buildHomePage() {
    layout.title = 'Devoxx FR - Schedule';
    layout.body = new SlotListScreen();
    return layout;
  }

  Layout buildSpeakerPage() {
    layout.title = 'Devoxx FR - Speakers';
    layout.body = new SpeakersScreen();
    return layout;
  }

  Layout buildPinnedTalkPage() {
    layout.title = 'Devoxx FR - Pinned Talks';
    layout.body = new PinnedTalksScreen();
    return layout;
  }

}
