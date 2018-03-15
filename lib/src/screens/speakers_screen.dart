import 'package:devoxx_flutter/src/screens/speaker_screen.dart';
import 'package:devoxx_flutter/src/services/conferences_api.dart';
import 'package:devoxx_flutter/src/utils/network_exception.dart';
import 'package:devoxx_flutter/src/utils/searchable.dart';
import 'package:devoxx_flutter/src/widgets/speaker_list_item.dart';
import 'package:flutter/material.dart';

class SpeakersScreen extends StatefulWidget implements Searchable {
  @override
  State<StatefulWidget> createState() => new _SpeakersScreen();

  final TextEditingController _searchQuery = new TextEditingController();

  @override
  TextEditingController getSearchQuery() {
    return _searchQuery;
  }
}

class _SpeakersScreen extends State<SpeakersScreen> {
  List _speakers;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSpeakers();
    widget._searchQuery.addListener(didValueChange);
  }

  didValueChange() {
    //force widget to repaint
    setState(() {});
  }

  @override
  void dispose() {
    widget._searchQuery.removeListener(didValueChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building speakers..');
    if (_loading) {
      return new Center(
        child: new CircularProgressIndicator(
          value: null,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
        ),
      );
    }

    return new ListView(
      children: _filterBySearchQuery(_speakers).map((speaker) {
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

  List<Map> _filterBySearchQuery(List<Map> speakers) {
    if (widget._searchQuery == null || widget._searchQuery.text.isEmpty)
      return speakers;
    final RegExp regexp = new RegExp(widget._searchQuery.text, caseSensitive: false);
    return speakers.where((Map speaker) {
      return speaker['firstName'].contains(regexp) ||
          speaker['lastName'].contains(regexp) ||
          (speaker.containsKey('company') &&
            speaker['company'] != null &&
            speaker['company'].contains(regexp));
    }).toList();
  }

  _loadSpeakers() async {
    try {
      ConferencesApi api = new ConferencesApi.fromConfig();

      List<Map> speakers = await api.fetchAllSpeakers();

      if(mounted) {
        setState(() {
          _speakers = speakers;
          _loading = false;
        });
      }
    } on NetworkException catch (exception) {
      print(exception);
      if(mounted) {
        setState(() {
          _loading = false;
        });
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('An error occured, please try again later')));
      }
    }
  }
}