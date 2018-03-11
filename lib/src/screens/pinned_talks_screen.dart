import 'package:devoxx_flutter/src/models/e_day.dart';
import 'package:devoxx_flutter/src/screens/talk_card_screen.dart';
import 'package:devoxx_flutter/src/state_provider.dart';
import 'package:devoxx_flutter/src/widgets/slot_list_item.dart';
import 'package:flutter/material.dart';

class PinnedTalksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = StateProvider.of(context);

    if (appState.areSlotsLoading) {
      return new Center(
        child: new CircularProgressIndicator(
          value: null,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
        ),
      );
    }

    List pinnedTalks = appState.slots.where((slot) {
      return slot.containsKey('talk') && slot['talk'] != null && slot['talk']['isStarred'];
    }).toList();

    if (pinnedTalks == null || pinnedTalks.isEmpty) {
      return new Text('You didn\'t yet star any talk');
    }

    String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    List slots = new List.from(new List(0));

    EDay.values.forEach((day) {
      var dayString = EDayAsString.asString(day);
      slots.add({'daySeparator': _capitalize(dayString)});
      slots.addAll(pinnedTalks.where((slot) { return slot['day'] == dayString; }).toList());
    });

    return new ListView(
      children: slots.map((slot) {
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

}