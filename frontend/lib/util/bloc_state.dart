import 'package:flutter/material.dart';

mixin BlocState on ChangeNotifier {
  BlocStateSelector _state = BlocStateSelector.initial;

  BlocStateSelector get state => _state;

  set state(BlocStateSelector state) {
    print('$runtimeType: Changed from $_state to $state');

    _state = state;

    notifyListeners();
  }
}

enum BlocStateSelector {
  initial,
  waiting,
  created,
  error,
}
