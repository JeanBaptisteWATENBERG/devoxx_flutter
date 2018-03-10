import 'package:devoxx_flutter/src/layout.dart';
import 'package:devoxx_flutter/src/screens/pinned_talks_screen.dart';
import 'package:devoxx_flutter/src/screens/slot_list_screen.dart';
import 'package:devoxx_flutter/src/screens/speakers_screen.dart';
import 'package:flutter/material.dart';

class DevoxxFlutter extends StatelessWidget {
  Layout layout = new Layout();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.amber),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => buildHomePage(),
        '/speakers': (BuildContext context) => buildSpeakerPage(),
        '/talks/pinned': (BuildContext context) => buildPinnedTalkPage(),
      },
    );
  }

  Layout buildHomePage() {
    return layout.setPage(
        title: 'Devoxx FR - Schedule',
        body: new SlotListScreen()
    );
  }

  Layout buildSpeakerPage() {
    return layout.setPage(
        title: 'Devoxx FR - Speakers',
        body: new SpeakersScreen()
    );
  }

  Layout buildPinnedTalkPage() {
    return layout.setPage(
        title: 'Devoxx FR - Pinned Talks',
        body: new PinnedTalksScreen()
    );
  }
}
