import 'package:flutter/material.dart';

class TabProvider extends ChangeNotifier {
  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;
  void setindex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
