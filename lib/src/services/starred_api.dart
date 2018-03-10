import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StarredApi {

  starATalk(String talkId) async {
    List<String> starredTalks = await fetchAllStarredTalks();
    if (!starredTalks.contains(talkId)) {
      starredTalks.add(talkId);
    }
    await (await _getLocalFile()).writeAsString(JSON.encode(starredTalks));
  }

  unStarATalk(String talkId) async {
    List<String> starredTalks = await fetchAllStarredTalks();
    if (starredTalks.contains(talkId)) {
      starredTalks.remove(talkId);
    }
    await (await _getLocalFile()).writeAsString(JSON.encode(starredTalks));
  }

  Future<List<String>> fetchAllStarredTalks() async {
    var savedContents = await (await _getLocalFile()).readAsString();
    if (savedContents.isEmpty) {
      savedContents = '[]';
    }
    return JSON.decode(savedContents);
  }

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/starredTalks.json').create();
  }

}