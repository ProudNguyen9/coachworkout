import 'package:flutter/material.dart';

class PasswordProvider extends ChangeNotifier {
  bool _isVisible = false;
  bool get isVisible => _isVisible;
  void toggle() {
    _isVisible = !isVisible;
    notifyListeners();
  }
}
