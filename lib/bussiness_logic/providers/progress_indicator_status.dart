import 'package:flutter/material.dart';

/// Handles state for progress indicator.
class ProgressIndicatorStatus with ChangeNotifier {
  double value = 0;
  String valuePercentage = '0';

  void getCalculatedValue({required int getValue, required int getTotalValue}) {
    value = getValue / getTotalValue;
    valuePercentage = (100 * (value)).toString();
    notifyListeners();
  }

  void reset() {
    value = 0;
    valuePercentage = '0';
    notifyListeners();
  }
}
