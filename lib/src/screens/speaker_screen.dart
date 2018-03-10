import 'package:devoxx_flutter/src/services/conferences_api.dart';
import 'package:devoxx_flutter/src/services/starred_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const List<Tab> tabs = const <Tab>[
  const Tab(text: 'Speaker', icon: const Icon(Icons.person)),
  const Tab(text: 'Talks', icon: const Icon(Icons.slideshow))
];

class SpeakerScreen extends StatefulWidget {
  Map _speaker;

  SpeakerScreen(this._speaker);

  @override
  State<StatefulWidget> createState() => new _SpeakerScreen();
}

class _SpeakerScreen extends State<SpeakerScreen> {
  Map _fullSpeaker;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadFullSpeaker();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: tabs.length,
        child: new Scaffold(
            appBar: new AppBar(
                title: new Text(widget._speaker['firstName'] + ' ' + widget._speaker['lastName']),
                bottom: new TabBar(
                  isScrollable: true,
                  tabs: tabs,
                )
            ),
            body: new TabBarView(
              children: tabs.map((Tab tab) {
                if (_isLoading) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      value: null,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
                    ),
                  );
                }

                if (tab.text == 'Speaker') {
                  return new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Markdown(data: _fullSpeaker['bio']),
                  );
                } else {
                  return new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new ListView(children: _fullSpeaker['acceptedTalks'].map((Map talk) {
                      return new ListTile(
                        leading: new Icon(talk['isStarred'] ? Icons.favorite : Icons.slideshow),
                        title: new Text(talk['title']),
                      );
                    }).toList())
                  );
                }
              }).toList(),
            )
        )
    );
  }

  void _loadFullSpeaker() async {
    try {
      ConferencesApi api = new ConferencesApi.fromConfig();
      StarredApi starredApi = new StarredApi();
      var fullSpeaker = await api.fetchASpeaker(widget._speaker['uuid']);
      var starredTalks = await starredApi.fetchAllStarredTalks();
      fullSpeaker['acceptedTalks'] = fullSpeaker['acceptedTalks'].map((talk) {
        if (starredTalks.contains(talk['id'])) {
          talk['isStarred'] = true;
        } else {
          talk['isStarred'] = false;
        }
        return talk;
      }).toList();

      setState(() {
        _isLoading = false;
        _fullSpeaker = fullSpeaker;
      });
    } catch(e) {
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('An error occured while loading speaker profile, please try again later')));
    }
  }
}