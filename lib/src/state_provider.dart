import 'package:devoxx_flutter/src/models/devoxx_flutter_state.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class StateProvider extends StatefulWidget {
  const StateProvider({this.data, this.child});

  static DevoxxFlutterState of(BuildContext context) {
    _InheritedProvider p =
      context.inheritFromWidgetOfExactType(_InheritedProvider);
    return p.data;
  }

  final DevoxxFlutterState data;
  final child;

  @override
  State<StatefulWidget> createState() => new _ProviderState();
}

class _ProviderState extends State<StateProvider> {
  @override
  initState() {
    super.initState();
    widget.data.addListener(didValueChange);
  }

  didValueChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(
      data: widget.data,
      child: widget.child,
    );
  }

  @override
  dispose() {
    widget.data.removeListener(didValueChange);
    super.dispose();
  }
}

class _InheritedProvider extends InheritedWidget {
  _InheritedProvider({DevoxxFlutterState this.data, this.child})
      : _dataSlots = data.slots,
        _dataAreSlotsLoading = data.areSlotsLoading,
        super(child: child);

  final data;
  final child;
  final List _dataSlots;
  final bool _dataAreSlotsLoading;

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    Function eq = const DeepCollectionEquality().equals;

    final shouldNotify = !eq(_dataSlots, oldWidget._dataSlots) ||
        _dataAreSlotsLoading != oldWidget._dataAreSlotsLoading;

    return shouldNotify;
  }
}