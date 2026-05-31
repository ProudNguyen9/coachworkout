import 'package:coach_workout/features/profile/presentation/screens/training_schedule/my_training_schedule_screen.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:coach_workout/widgets/widgets.dart';
import 'package:coach_workout/screen/screens.dart';

class ProfileScreen extends StatelessWidget {
  static ProfileScreen builder(BuildContext context, GoRouterState state) =>
      ProfileScreen();
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        centerTitle: true,
        title: Text(
          'profile_screen.title'.tr(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/male.png',
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Nguyen Huu Hao',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Nguyenhuuhao9@gmail.com',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ],
              ),

              const Gap(20),

              _ScheduleButton(),

              const Gap(20),

              TextTile(title: 'profile_screen.activities'.tr()),

              SizedBox(
                height: 240,
                width: context.deviceSize.width - 5,
                child: ActiveChart(),
              ),

              const Gap(10),

              TextTile(title: 'profile_screen.today_report'.tr()),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoCard(
                    title: 'profile_screen.calories_burned'.tr(),
                    value: '245',
                    unit: 'Kcal',
                    iconPath: 'assets/icons/bxs-hot 1.svg',
                    backgroundColor: const Color(0xFF4C6EF5),
                  ),
                  InfoCard(
                    title: 'profile_screen.heart_rate'.tr(),
                    value: '78',
                    unit: 'Bpm',
                    iconPath: 'assets/icons/bxs-heart 1.svg',
                    backgroundColor: const Color(0xFFFF6B6B),
                  ),
                ],
              ),

              const Gap(20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoCard(
                    title: 'profile_screen.carbohydrate'.tr(),
                    value: '123',
                    unit: 'Gram',
                    iconPath: 'assets/icons/bxs-bowl-rice 1.svg',
                    backgroundColor: const Color(0xFF4DD0E1),
                  ),
                  InfoCard(
                    title: 'profile_screen.workout'.tr(),
                    value: '60',
                    unit: 'Mins',
                    iconPath: 'assets/icons/bx-dumbbell.svg',
                    backgroundColor: const Color(0xFFFFA726),
                  ),
                ],
              ),

              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleButton extends StatelessWidget {
  const _ScheduleButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyTrainingScheduleScreen()),
          );
        },
        icon: const Icon(Icons.calendar_month, color: Colors.white),
        label: Text(
          'Lịch luyện tập của tôi',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
