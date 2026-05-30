import 'package:coach_workout/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:coach_workout/widgets/widgets.dart';
import 'package:coach_workout/screen/screens.dart';
import 'package:coach_workout/features/workout/presentation/providers/group_exercise_provider.dart';

class Workouts extends StatefulWidget {
  const Workouts({super.key});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  @override
  void initState() {
    super.initState();

    /// 🔹 Load Supabase data – run once
    Future.microtask(() {
      final provider = context.read<GroupExerciseProvider>();
      provider.fetchBeginnerExercises(limitCount: 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupExerciseProvider>();
    final beginnerList = provider.beginnerList;
    final isLoading = provider.isLoading;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(19),

            /// 🔍 Search
            Center(
              child: SizedBox(
                height: 52,
                width: context.deviceSize.width - 30,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'workouts.search_hint'.tr(),
                    fillColor: context.colorScheme.surface,
                    focusColor: context.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),

            const Gap(10),

            /// 🎯 Target Area
            TextTile(title: 'workouts.target_area'.tr()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MuscleScrollRow(),
            ),

            /// 🏁 Weekly Challenge
            BannerChild(
              Title: 'workouts.weekly_challenge'.tr(),
              TitleChild: 'Plank With Hip Twist', // data cố định
              path: 'assets/banner_library.png',
            ),

            /// 🏋️ Beginner Workout
            TitleTextAndButtonSA(
              onPressed: () {},
              title: 'workouts.beginner_workout'.tr(),
            ),

            if (isLoading)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (_, __) => const WorkoutSkeletonItem(),
              )
            else if (beginnerList.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('workouts.no_workouts'.tr()),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: beginnerList.length,
                itemBuilder: (context, index) {
                  final workout = beginnerList[index];
                  return ItemListBeginner(
                    path: workout.urlThumbnail,
                    title: workout.title, // ❗ DB data
                    description: workout.description, // ❗ DB data
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkoutScreen(
                            groupId: workout.id,
                            groupName: workout.title,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

            const Gap(15),

            /// ❤️ Just For You
            TitleTextAndButtonSA(
              onPressed: () {},
              title: 'workouts.just_for_you'.tr(),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI9J598TmGZgO2bHvdpw8BUkqRajVV2EqScw&s',
                      'workouts.workout_plan'.tr(),
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdqhHRm1HgAHL9k6cyYfWCEM0M7REXUyeGyw&s',
                      'workouts.ai_coaching'.tr(),
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxV7ToOVEGNyP05_I6kdLnxDrGwKF_mOmcqQ&s',
                      'workouts.nutrition'.tr(),
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrdOI-pFGm7VdHOcUd6oDxmu1KVtpPMRqE_A&s',
                      'workouts.yoga'.tr(),
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJlgqbfsLrI7FIO0gPUoMYVde1nwCUixjxaA&s',
                      'workouts.cardio'.tr(),
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyaV0bWwrQvU3TKjhtqMbMoXssD23mDFa2g&s',
                      'workouts.hiit'.tr(),
                    ),
                  ],
                ),
              ),
            ),

            const Gap(10),

            /// 💪 Full Body
            TitleTextAndButtonSA(
              onPressed: () {},
              title: 'workouts.full_body'.tr(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardTip(
                    onTap: () {},
                    title: 'workouts.supplement_guide'.tr(),
                    path: 'assets/fullbody1.png',
                  ),
                  CardTip(
                    onTap: () {},
                    title: 'workouts.quick_effective'.tr(),
                    path: 'assets/fullbody2.png',
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

/// ================= SKELETON =================
class WorkoutSkeletonItem extends StatelessWidget {
  const WorkoutSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


