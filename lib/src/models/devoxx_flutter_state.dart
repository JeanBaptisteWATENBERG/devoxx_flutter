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

  Map _currentSlot;

  Map get currentSlot => _currentSlot;

  void set currentSlot(Map currentSlot) {
    _currentSlot = currentSlot;
    print(_currentSlot['talk']['isStarred']);
    notifyListeners();
  }

  DevoxxFlutterState(this._areSlotsLoading);

  void updateTalkStar(isStarred) {
    if (currentSlot != null) {
      currentSlot['talk']['isStarred'] = isStarred;
    }
    if (slots != null && currentSlot != null) {
      slots = slots.map((slot) {
        if (slot.containsKey('talk') && slot['talk'] != null) {
          if (slot['talk']['id'] == currentSlot['talk']['id']) {
            slot['talk']['isStarred'] = isStarred;
          }
        }
        return slot;
      }).toList();
    }
  }

}