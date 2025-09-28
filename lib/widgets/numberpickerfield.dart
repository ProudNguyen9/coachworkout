import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerField extends StatefulWidget {
  final String label;
  final String unit;
  final int minInteger;
  final int maxInteger;
  final double initialValue;
  final ValueChanged<double> onChanged;
  final bool allowDecimal;

  const NumberPickerField({
    super.key,
    required this.label,
    required this.unit,
    required this.minInteger,
    required this.maxInteger,
    required this.initialValue,
    required this.onChanged,
    this.allowDecimal = true,
  });

  @override
  State<NumberPickerField> createState() => _NumberPickerFieldState();
}

class _NumberPickerFieldState extends State<NumberPickerField> {
  late int integerPart;
  late int decimalPart;

  @override
  void initState() {
    super.initState();
    integerPart = widget.initialValue.floor();
    decimalPart = widget.allowDecimal
        ? ((widget.initialValue - integerPart) * 10).round()
        : 0;
  }

  void _updateValue() {
    final value = widget.allowDecimal
        ? integerPart + decimalPart / 10
        : integerPart.toDouble();
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 79, 81),
        borderRadius: BorderRadius.circular(22),
        image: DecorationImage(
          image: AssetImage("assets/weight.jpg"),
          opacity: 0.6,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Gap(10),
              Text(
                widget.allowDecimal
                    ? "$integerPart.$decimalPart ${widget.unit}"
                    : "$integerPart ${widget.unit}",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberPicker(
                itemHeight: 29,
                textStyle: TextStyle(fontSize: 16, color: Colors.white70),
                selectedTextStyle: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                value: integerPart,
                minValue: widget.minInteger,
                maxValue: widget.maxInteger,
                onChanged: (value) {
                  setState(() => integerPart = value);
                  _updateValue();
                },
              ),
              if (widget.allowDecimal) ...[
                const Gap(10),
                NumberPicker(
                  itemHeight: 28,
                  textStyle: TextStyle(fontSize: 16, color: Colors.white70),
                  selectedTextStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  value: decimalPart,
                  minValue: 0,
                  maxValue: 9,
                  onChanged: (value) {
                    setState(() => decimalPart = value);
                    _updateValue();
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
