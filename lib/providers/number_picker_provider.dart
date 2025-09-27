import 'package:flutter/foundation.dart';

class NumberPickerProvider extends ChangeNotifier {
  int integerPart;
  int decimalPart;

  final int minInteger;
  final int maxInteger;
  final ValueChanged<double> onChanged;

  NumberPickerProvider({
    required double initialValue,
    required this.minInteger,
    required this.maxInteger,
    required this.onChanged,
  })  : integerPart = initialValue.floor(),
        decimalPart = ((initialValue - initialValue.floor()) * 10).round();

  double get value => integerPart + decimalPart / 10;

  void setInteger(int newValue) {
    integerPart = newValue;
    notifyListeners();
    onChanged(value);
  }

  void setDecimal(int newValue) {
    decimalPart = newValue;
    notifyListeners();
    onChanged(value);
  }
}
