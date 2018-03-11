import 'package:flutter/material.dart';
class DevoxxFlutterState extends ChangeNotifier {
  List<Map> _slots;

  List<Map> get slots => _slots;

  void set slots(List<Map> slots) {
    _slots = slots;
    notifyListeners();
  }

  bool _areSlotsLoading;

  bool get areSlotsLoading => _areSlotsLoading;

  void set areSlotsLoading(bool areSlotsLoading) {
    _areSlotsLoading = areSlotsLoading;
    notifyListeners();
  }

  DevoxxFlutterState(this._areSlotsLoading);

  void updateTalkStar(talkId, isStarred) {
    if (slots != null) {
      slots = slots.map((slot) {
        if (slot.containsKey('talk') && slot['talk'] != null) {
          if (slot['talk']['id'] == talkId) {
            slot['talk']['isStarred'] = isStarred;
          }
        }
        return slot;
      }).toList();
      notifyListeners();
    }
  }

}