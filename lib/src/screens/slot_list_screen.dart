import 'dart:async';

import 'package:devoxx_flutter/src/state_provider.dart';
import 'package:devoxx_flutter/src/models/e_day.dart';
import 'package:devoxx_flutter/src/screens/talk_card_screen.dart';
import 'package:devoxx_flutter/src/services/conferences_api.dart';
import 'package:devoxx_flutter/src/services/starred_api.dart';
import 'package:devoxx_flutter/src/widgets/slot_list_item.dart';
import 'package:flutter/material.dart';

class SlotListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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

    return new ListView(
      children: appState.slots.map((slot) {
        var talkCardScreen = new TalkCardScreen(slot: slot);
        return new SlotListItem(
            slot: slot,
            onSelect: (Map s) {
              if (s != null && s.containsKey('talk') && s['talk'] != null) {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return talkCardScreen;
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
        slots.add({'daySeparator': _capitalize(EDayAsString.asString(day))});
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

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

}
