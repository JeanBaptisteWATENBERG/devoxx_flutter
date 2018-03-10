import 'package:flutter/material.dart';

class SpeakerAvatar extends StatelessWidget {
  Map _speaker;

  SpeakerAvatar(this._speaker);

  _loadImageOrFailSilently(url) {
    try {
      NetworkImage image = new NetworkImage(url);
      return image;
    } catch (Exception) {
      return new AssetImage('images/failed.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new CircleAvatar(
      backgroundImage: _loadImageOrFailSilently(_speaker['avatarURL']),
    );
  }
}
