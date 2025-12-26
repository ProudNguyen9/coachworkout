import 'package:coach_workout/providers/tap_homehomscreen_provider.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'screens.dart';

//  content in taps
final List<Widget> pages = const [
  OverviewScreen(),
  YoursCoach(),
  NutritionPlanScreen(),
  FitnessStatsScreen(),
];

class HomeScreen extends StatelessWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state) =>
      HomeScreen();
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Dashboard_title'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            Padding(padding: const EdgeInsets.all(8.0), child: ButtonTap()),

            Expanded(child: pages[context.watch<TabProvider>().selectedIndex]),
          ],
        ),
      ),
    );
  }
}
