import 'package:coach_workout/config/routes/routes_location.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
              child: Text(
                'OnboardingScreen.body_measurements'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Gap(5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'OnboardingScreen.recommend_info'.tr(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),

            NumberPickerField(
              initialValue: 39.8,
              label: 'OnboardingScreen.weight_label'.tr(),
              maxInteger: 180,
              minInteger: 35,
              unit: 'kg',
              onChanged: (value) {},
              path: 'assets/weight.jpg',
            ),

            NumberPickerField(
              path: 'assets/age.jpg',
              label: 'OnboardingScreen.age_label'.tr(),
              unit: "",
              minInteger: 15,
              maxInteger: 80,
              initialValue: 20,
              allowDecimal: false,
              onChanged: (value) {},
            ),

            NumberPickerField(
              path: 'assets/height.jpg',
              label: 'OnboardingScreen.height_label'.tr(),
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
                'OnboardingScreen.next_button'.tr(),
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
