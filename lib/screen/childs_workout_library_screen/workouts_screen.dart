import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../screens.dart';
import '../../providers/group_exercise_provider.dart';

class Workouts extends StatefulWidget {
  const Workouts({super.key});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  @override
  void initState() {
    super.initState();

    /// 🔹 Gọi load dữ liệu Supabase, chỉ chạy 1 lần duy nhất
    Future.microtask(() {
      // ignore: use_build_context_synchronously
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

            // 🔍 Search Field
            Center(
              child: SizedBox(
                height: 52,
                width: context.deviceSize.width - 30,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Find your workout...',
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

            // 🎯 Target Area
            const TextTile(title: 'Target Area'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MuscleScrollRow(),
            ),

            // 🏁 Weekly Challenge Banner
            const BannerChild(
              Title: '  Weekly Challenge',
              TitleChild: 'Plank With Hip Twist',
              path: 'assets/banner_library.png',
            ),

            // 🏋️ Beginner Workout Section
            TitleTextAndButtonSA(onPressed: () {}, title: 'Beginner Workout'),

            if (isLoading)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (_, __) => const WorkoutSkeletonItem(),
              )
            else if (beginnerList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("No workouts found 😕"),
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
                    title: workout.title,
                    description: workout.description,
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
            TitleTextAndButtonSA(onPressed: () {}, title: 'Just For You'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI9J598TmGZgO2bHvdpw8BUkqRajVV2EqScw&s',
                      'Workout Plan',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdqhHRm1HgAHL9k6cyYfWCEM0M7REXUyeGyw&s',
                      'AI Coaching',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxV7ToOVEGNyP05_I6kdLnxDrGwKF_mOmcqQ&s',
                      'Nutrition',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrdOI-pFGm7VdHOcUd6oDxmu1KVtpPMRqE_A&s',
                      'Yoga',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJlgqbfsLrI7FIO0gPUoMYVde1nwCUixjxaA&s',
                      'Cardio',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyaV0bWwrQvU3TKjhtqMbMoXssD23mDFa2g&s',
                      'HIIT',
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),

            // 💪 Full Body Section (phần dưới giữ nguyên)
            TitleTextAndButtonSA(onPressed: () {}, title: 'Full Body'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardTip(
                    onTap: () {},
                    title: 'Supplement Guide...',
                    path: 'assets/fullbody1.png',
                  ),
                  CardTip(
                    onTap: () {},
                    title: '15 Quick & Effective',
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

class WorkoutSkeletonItem extends StatelessWidget {
  const WorkoutSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // thumbnail
          Container(
            width: 90,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),

          // text
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
