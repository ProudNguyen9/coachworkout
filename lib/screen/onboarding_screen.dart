import 'package:coach_workout/config/routes/routes_location.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../widgets/widgets.dart';

class OnboardingScreen extends StatelessWidget {
  static OnboardingScreen builder(BuildContext context, GoRouterState state) =>
      OnboardingScreen();
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const Gap(30),
            Center(
              child: const Text(
                "Body measurements",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const Gap(5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'To recommend suitable workouts, please enter the following information:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),

            NumberPickerField(
              initialValue: 39.8,
              label: 'Weight',
              maxInteger: 180,
              minInteger: 35,
              unit: 'kg',
              onChanged: (value) {},
            ),

            NumberPickerField(
              label: "Age",
              unit: "years",
              minInteger: 15,
              maxInteger: 80,
              initialValue: 20,
              allowDecimal: false,
              onChanged: (value) {},
            ),

            NumberPickerField(
              label: "Height",
              unit: "cm",
              minInteger: 100,
              maxInteger: 220,
              initialValue: 170.5,
              allowDecimal: false,
              onChanged: (v) {},
            ),
            const Gap(5),
            ElevatedButton(
              onPressed: () {
                context.go(RouteLocation.profilesetup);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[600],
                foregroundColor: Colors.white,
                minimumSize: Size(context.deviceSize.width - 50, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
