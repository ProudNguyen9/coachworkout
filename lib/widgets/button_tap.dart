import 'package:coach_workout/config/theme/color_scheme_extension.dart';
import 'package:coach_workout/providers/provider.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonTap extends StatefulWidget {
  const ButtonTap({super.key});

  @override
  State<ButtonTap> createState() => _ButtonTapState();
}

class _ButtonTapState extends State<ButtonTap> {
  final List<String> buttons = [
    'Overview',
    'Your Coach',
    'Nutrition Plan',
    'Workout Schedule',
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = context.watch<TabProvider>().selectedIndex;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(buttons.length, (index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                context.read<TabProvider>().setindex(index);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80, 32),
                backgroundColor: isSelected
                    ? context.colorScheme.secondary
                    : context.colorScheme.surface,
                side: BorderSide(
                  width: isSelected ? 0 : 2,
                  color: context.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                buttons[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : context.colorScheme.customWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
