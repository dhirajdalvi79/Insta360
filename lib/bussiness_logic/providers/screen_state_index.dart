import 'package:flutter/cupertino.dart';

/// Handles screen state on main screen.
class ScreenStateIndex with ChangeNotifier {
  int index = 1;

  /// Set the state for various screen on main screen by taking argument.
  changeScreenIndex({required int screenNumber}) {
    index = screenNumber;
    notifyListeners();
  }
}
