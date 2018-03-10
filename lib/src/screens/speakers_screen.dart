import 'package:devoxx_flutter/src/screens/speaker_screen.dart';
import 'package:devoxx_flutter/src/services/conferences_api.dart';
import 'package:devoxx_flutter/src/utils/network_exception.dart';
import 'package:devoxx_flutter/src/widgets/speaker_list_item.dart';
import 'package:flutter/material.dart';

class SpeakersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SpeakersScreen();
}

class _SpeakersScreen extends State<SpeakersScreen> {
  List _speakers;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSpeakers();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return new Center(
        child: new CircularProgressIndicator(
          value: null,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
        ),
      );
    }

    return new ListView(
      children: _speakers.map((speaker) {
        return new SpeakerListItem(
          speaker: speaker,
          onSelect: (Map s) {
            Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new SpeakerScreen(s);
              },
            ));
          });
      }).toList(),
    );
  }

  _loadSpeakers() async {
    try {
      ConferencesApi api = new ConferencesApi.fromConfig();

      List<Map> speakers = await api.fetchAllSpeakers();

      setState(() {
        _speakers = speakers;
        _loading = false;
      });
    } on NetworkException catch (exception) {
      print(exception);
      setState(() {
        _loading = false;
      });
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('An error occured, please try again later')));
    }
  }
}