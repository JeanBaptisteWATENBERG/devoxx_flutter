import 'package:devoxx_flutter/src/services/starred_api.dart';
import 'package:devoxx_flutter/src/widgets/talk_speakers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:meta/meta.dart';

class TalkCardScreen extends StatefulWidget {
  final Map slot;
  final ValueChanged<bool> onStarredChanged;

  TalkCardScreen({Key key, @required this.slot,  @required this.onStarredChanged}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _TalkCardScreen();
}

class _TalkCardScreen extends State<TalkCardScreen> {

  bool _isTalkStarred = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isTalkStarred = widget.slot['talk']['isStarred'];
    });
  }

  @override
  void didUpdateWidget(TalkCardScreen oldWidget) {
    widget.onStarredChanged(_isTalkStarred);
  }

  @override
  Widget build(BuildContext context) {
    var talk = widget.slot['talk'];
    return new Scaffold(
        floatingActionButton: _isTalkStarred ?
        new FloatingActionButton(
            child: new Icon(Icons.favorite),
            backgroundColor: Colors.red,
            onPressed: () {
              var starredApi = new StarredApi();
              starredApi.unStarATalk(talk['id']);
              setState(() {
                _isTalkStarred = false;
              });
            })
            : new FloatingActionButton(
            child: new Icon(Icons.favorite_border),
            backgroundColor: Colors.grey,
            onPressed: () {
              var starredApi = new StarredApi();
              starredApi.starATalk(talk['id']);
              setState(() {
                _isTalkStarred = true;
              });
            }
        ),
        appBar: new AppBar(
            title: new Text(widget.slot['talk']['title'])
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
                                        widget.slot['roomName'] +
                                        ' from ' +
                                        widget.slot['fromTime'] +
                                        ' to ' +
                                        widget.slot['toTime'],
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
