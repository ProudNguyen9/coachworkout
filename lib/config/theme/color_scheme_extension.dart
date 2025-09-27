import 'package:flutter/material.dart';

/// Extension để thêm màu custom vào ColorScheme
extension CustomColors on ColorScheme {
  Color get customWhite =>
      brightness == Brightness.dark ? Colors.white : Color(0xFF0386D0);
  Color get colorlogogithub =>
      brightness == Brightness.dark ? Colors.white : Colors.black;
}
