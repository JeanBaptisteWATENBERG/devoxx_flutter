import 'dart:async';

import 'package:devoxx_flutter/src/services/conferences_api.dart';
import 'package:devoxx_flutter/src/widgets/speaker_avatar.dart';
import 'package:flutter/material.dart';
import 'package:devoxx_flutter/src/utils/network_exception.dart';

class TalkSpeakers extends StatefulWidget {
  final Map talk;

  TalkSpeakers(this.talk);

  @override
  State<StatefulWidget> createState() => new _TalkSpeakers();
}

class _TalkSpeakers extends State<TalkSpeakers> {
  List _speakers;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadSpeakers();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return new Container();
    }
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _speakers.map((speaker) {
          print(speaker['avatarURL']);
          return new Expanded(
              child: new Container(
                  margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: new Column(children: <Widget>[
                    new SpeakerAvatar(speaker),
                    new Text(speaker['firstName'] + ' ' + speaker['lastName'], textAlign: TextAlign.center)
                  ])));
        }).toList());
  }

  _loadSpeakers() async {
    try {
      ConferencesApi api = new ConferencesApi.fromConfig();

      var talk = widget.talk;
      List<Future> speakers = talk['speakers'].map((speakerLink) async {
        Map speaker =
            await api.fetchASpeakerFromLink(speakerLink['link']['href']);
        return speaker;
      }).toList();

      var resolvedSpeakers = await Future.wait(speakers);

      setState(() {
        _speakers = resolvedSpeakers;
        _loading = false;
      });
    } on NetworkException catch (exception) {
      setState(() {
        _loading = false;
      });
    }
  }
}
