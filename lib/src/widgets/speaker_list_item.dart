import 'package:devoxx_flutter/src/widgets/speaker_avatar.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SpeakerListItem extends StatelessWidget {
  var speaker;
  var onSelect;

  SpeakerListItem({
    Key key,
    @required this.speaker,
    this.onSelect,
  }): assert(speaker != null), super(key: key);

  void _handleSelect() {
    onSelect?.call(speaker);
  }

  @override
  Widget build(BuildContext context) {
      return new Material(
        color: Colors.white,
        child: new ListTile(
            enabled: true,
            onTap: _handleSelect,
            isThreeLine: false,
            leading: new SpeakerAvatar(speaker),
            title: new Text(speaker['firstName'] + ' ' + speaker['lastName']),
            subtitle: speaker.containsKey('company') &&
                speaker['company'] != null ? new Text(speaker['company']) : null,
        ),
      );
  }


}