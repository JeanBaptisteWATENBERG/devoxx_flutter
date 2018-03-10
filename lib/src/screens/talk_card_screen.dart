import 'package:devoxx_flutter/src/services/starred_api.dart';
import 'package:devoxx_flutter/src/state_provider.dart';
import 'package:devoxx_flutter/src/widgets/talk_speakers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:meta/meta.dart';

class TalkCardScreen extends StatelessWidget {
  final Map slot;

  TalkCardScreen({Key key, @required this.slot}) : super(key: key);

  toggleStar(appState, talk) {
    var starredApi = new StarredApi();
    appState.currentSlot = slot;
    if (talk['isStarred']) {
      starredApi.unStarATalk(talk['id']);
      appState.updateTalkStar(false);
    } else {
      starredApi.starATalk(talk['id']);
      appState.updateTalkStar(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = StateProvider.of(context);
    var talk = slot['talk'];
    return new Scaffold(
        floatingActionButton: talk['isStarred'] ?
        new FloatingActionButton(
            child: new Icon(Icons.favorite),
            backgroundColor: Colors.red,
            onPressed: () {toggleStar(appState, talk); }
        ) :
        new FloatingActionButton(
            child: new Icon(Icons.favorite_border),
            backgroundColor: Colors.grey,
            onPressed: () {toggleStar(appState, talk); }
        ),
        appBar: new AppBar(
            title: new Text(talk['title'])
        ),
        body: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new Expanded(
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.amberAccent
                  ),
                  child: new Container(
                      margin: new EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                      child: new Center(
                          child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(talk['title'],
                                    style: Theme.of(context).textTheme.title),
                                new Text(talk['track'] + ' - ' + talk['talkType'],
                                    style: Theme.of(context).textTheme.caption),
                                new Text(
                                    'In ' +
                                        slot['roomName'] +
                                        ' from ' +
                                        slot['fromTime'] +
                                        ' to ' +
                                        slot['toTime'],
                                    style: Theme.of(context).textTheme.caption),
                                new TalkSpeakers(talk)
                              ]))))),
          new Expanded(
              flex: 2,
              child: new Container(
                  margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  child: new Markdown(
                    data: talk['summary'],
                  )))
        ]));
  }
}
