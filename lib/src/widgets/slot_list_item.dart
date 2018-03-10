import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SlotListItem extends StatelessWidget {
  var slot;
  var onSelect;

  SlotListItem({
    Key key,
    @required this.slot,
    this.onSelect,
  }): assert(slot != null), super(key: key);

  void _handleSelect() {
    onSelect?.call(slot);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDaySeparator = slot.containsKey('daySeparator');

    if (isDaySeparator) {
      return new Material(
        color: Colors.white,
        child: new ListTile(
            enabled: true,
            onTap: _handleSelect,
            isThreeLine: false,
            title: new Text(slot['daySeparator'])
        ),
      );
    }

    final bool isTalk = slot.containsKey('talk') && slot['talk'] != null;
    final bool isStarred = isTalk && slot['talk']['isStarred'];
    final bool isBreak = slot.containsKey('break') && slot['break'] != null;
    final String title = isTalk ? slot['talk']['title'] :
      isBreak ? slot['break']['nameEN'] : 'Conference' ;

    Widget icon = new Icon(isTalk ? Icons.slideshow :
    isBreak ? Icons.free_breakfast : Icons.group);
    if (isStarred) icon = new Icon(Icons.favorite, color: Colors.red);

    return new Material(
      color: Colors.white,
      child: new ListTile(
        enabled: true,
        onTap: _handleSelect,
        isThreeLine: false,
        leading: icon,
        title: new Text(title),
        subtitle: new Text('In ' + slot['roomName'] + ' from ' + slot['fromTime'] + ' to ' + slot['toTime']),
      ),
    );
  }


}