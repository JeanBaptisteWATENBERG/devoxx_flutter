import 'package:devoxx_flutter/src/models/e_day.dart';
import 'package:devoxx_flutter/src/screens/talk_card_screen.dart';
import 'package:devoxx_flutter/src/state_provider.dart';
import 'package:devoxx_flutter/src/utils/searchable.dart';
import 'package:devoxx_flutter/src/utils/string_utils.dart';
import 'package:devoxx_flutter/src/widgets/slot_list_item.dart';
import 'package:flutter/material.dart';

class PinnedTalksScreen extends StatefulWidget implements Searchable {
  final TextEditingController _searchQuery = new TextEditingController();

  @override
  TextEditingController getSearchQuery() {
    return _searchQuery;
  }

  @override
  State<StatefulWidget> createState() => new _PinnedTalksScreen();

}

class _PinnedTalksScreen extends State<PinnedTalksScreen> {
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

    List slots = new List.from(new List(0));

    EDay.values.forEach((day) {
      var dayString = EDayAsString.asString(day);
      slots.add({'daySeparator': capitalize(dayString)});
      slots.addAll(pinnedTalks.where((slot) { return slot['day'] == dayString; }).toList());
    });

    return new ListView(
      children: _filterBySearchQuery(slots).map((slot) {
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