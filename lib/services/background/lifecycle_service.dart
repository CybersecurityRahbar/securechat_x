import 'package:flutter/widgets.dart';

/// Holds application lifecycle state outside presentation widgets.
final class LifecycleService extends ChangeNotifier {
  AppLifecycleState _state = AppLifecycleState.resumed;
  AppLifecycleState get state => _state;

  void update(AppLifecycleState state) {
    if (_state == state) return;
    _state = state;
    notifyListeners();
  }
}
