import 'package:devoxx_flutter/src/state_provider.dart';
import 'package:devoxx_flutter/src/layout.dart';
import 'package:devoxx_flutter/src/models/devoxx_flutter_state.dart';
import 'package:devoxx_flutter/src/screens/pinned_talks_screen.dart';
import 'package:devoxx_flutter/src/screens/slot_list_screen.dart';
import 'package:devoxx_flutter/src/screens/speakers_screen.dart';
import 'package:flutter/material.dart';

class DevoxxFlutter extends StatelessWidget {
  static final homeTitle = 'Devoxx FR - Schedule';
  static final slotListScreen = new SlotListScreen();
  static final DevoxxFlutterState state = new DevoxxFlutterState(true, homeTitle, slotListScreen);
  static final DevoxxFlutterApp devoxxFlutterApp = new DevoxxFlutterApp(homeTitle, slotListScreen);

  @override
  Widget build(BuildContext context) {
    return new StateProvider(
      data: state,
      child: devoxxFlutterApp
    );
  }
}

class DevoxxFlutterApp extends StatelessWidget {
  var homeTitle;
  var slotListScreen;

  DevoxxFlutterApp(this.homeTitle, this.slotListScreen);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.amber),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => buildHomePage(context),
        '/speakers': (BuildContext context) => buildSpeakerPage(context),
        '/talks/pinned': (BuildContext context) => buildPinnedTalkPage(context),
      },
    );
  }

  buildHomePage(BuildContext context) {
    var appState = StateProvider.of(context);
    appState.setPage(
        title: homeTitle,
        body: slotListScreen
    );
    var layout = new Layout();
    return layout;
  }

  buildSpeakerPage(BuildContext context) {
    var appState = StateProvider.of(context);
    appState.setPage(
        title: 'Devoxx FR - Speakers',
        body: new SpeakersScreen()
    );
    return new Layout();
  }

  buildPinnedTalkPage(BuildContext context) {
    var appState = StateProvider.of(context);
    appState.setPage(
        title: 'Devoxx FR - Pinned Talks',
        body: new PinnedTalksScreen()
    );
    return new Layout();
  }
}
