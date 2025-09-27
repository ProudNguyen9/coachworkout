import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class AtGymScreen extends StatelessWidget {
  const AtGymScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),

            // banner  movivated
            BannerChild(
              Title: '  Weekly Challenge',
              TitleChild: 'Plank With Hip Twist',
              path: 'assets/banner_library.png',
            ),
            //
            const Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                  const Gap(6),
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                ],
              ),
            ),
            const Gap(10),

            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                  const Gap(6),
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                ],
              ),
            ),
            const Gap(10),

            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                  const Gap(6),
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                ],
              ),
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                  const Gap(6),
                  GymCard(
                    Title: 'Barbell Rows',
                    onTap: () {},
                    path: 'assets/tip1.jpg',
                    time: '10 Minutes',
                    rep: '9',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
