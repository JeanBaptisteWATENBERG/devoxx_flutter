import 'dart:async';

import 'package:devoxx_flutter/src/state_provider.dart';
import 'package:devoxx_flutter/src/models/e_day.dart';
import 'package:devoxx_flutter/src/screens/talk_card_screen.dart';
import 'package:devoxx_flutter/src/services/conferences_api.dart';
import 'package:devoxx_flutter/src/services/starred_api.dart';
import 'package:devoxx_flutter/src/utils/searchable.dart';
import 'package:devoxx_flutter/src/utils/string_utils.dart';
import 'package:devoxx_flutter/src/widgets/slot_list_item.dart';
import 'package:flutter/material.dart';

class SlotListScreen extends StatefulWidget implements Searchable {
  final TextEditingController _searchQuery = new TextEditingController();

  @override
  TextEditingController getSearchQuery() {
    return _searchQuery;
  }

  @override
  State<StatefulWidget> createState()  => new _SlotListScreen();

}

class _SlotListScreen extends State<SlotListScreen> {
  @override
  Widget build(BuildContext context) {
    print('Building home..');
    _loadState(context);
    var appState = StateProvider.of(context);
    if (appState.areSlotsLoading) {
      return new Center(
        child: new CircularProgressIndicator(
          value: null,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
        ),
      );
    }

    if (appState.slots == null || appState.slots.isEmpty) {
      return new Center(
          child: new Text('An error occured while loading schedule, please restart your application')
      );
    }

    return new ListView(
      children: _filterBySearchQuery(appState.slots).map((slot) {
        return new SlotListItem(
          slot: slot,
          onSelect: (Map s) {
            if (s != null && s.containsKey('talk') && s['talk'] != null) {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return new TalkCardScreen(slot: s);
                },
              ));
            }
          });
      }).toList(),
    );
  }

  _loadState(context) async {
    try {
      ConferencesApi api = new ConferencesApi.fromConfig();

      var starredApi = new StarredApi();
      var futures = EDay.values.map((day) async {
        return await api.fetchAllSlotsByDay(day);
      }).toList();
      var starredTalksFuture = starredApi.fetchAllStarredTalks();
      futures.add(starredTalksFuture);

      var futuresResult = await Future.wait(futures);
      var starredTalks = futuresResult[EDay.values.length];

      List<Map> slots = new List();

      var index = 0;
      EDay.values.forEach((day) {
        Map daySlotsObject = futuresResult[index++];
        slots.add({'daySeparator': capitalize(EDayAsString.asString(day))});
        slots.addAll(daySlotsObject['slots'].map((slot) { return _starredTalks(starredTalks, slot); }).toList());
      });

      var appState = StateProvider.of(context);
      appState.slots = slots;
      appState.areSlotsLoading = false;
    } catch (exception) {
      var appState = StateProvider.of(context);
      appState.areSlotsLoading = false;
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('An error occured, please try again later')));
    }
  }

  Map _starredTalks(List<String> starredTalks, Map slot) {
    if (slot.containsKey('talk') && slot['talk'] != null) {
      slot['talk']['isStarred'] = starredTalks.contains(slot['talk']['id']);
    }
    return slot;
  }

  List<Map> _filterBySearchQuery(List<Map> slots) {
    if (widget._searchQuery == null || widget._searchQuery.text.isEmpty)
      return slots;
    final RegExp regexp = new RegExp(widget._searchQuery.text, caseSensitive: false);
    return slots.where((Map slot) {
      final bool isTalk = slot.containsKey('talk') && slot['talk'] != null;
      final bool isBreak = slot.containsKey('break') && slot['break'] != null;
      final String title = isTalk ? slot['talk']['title'] :
      isBreak ? slot['break']['nameEN'] : 'Conference' ;
      return title.contains(regexp) || (slot['roomName'] != null && slot['roomName'].contains(regexp));
    }).toList();
  }


  @override
  void initState() {
    super.initState();
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


}
