import 'package:coach_workout/core/services/local_notification_service.dart';
import 'package:coach_workout/core/services/supabase_service.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:coach_workout/widgets/widgets.dart';
import 'package:coach_workout/screen/screens.dart';
import 'package:coach_workout/features/workout/presentation/providers/group_exercise_provider.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late Future<Map<String, dynamic>?> _todayWorkoutFuture;

  @override
  void initState() {
    super.initState();
    _todayWorkoutFuture = _loadTodayWorkout();

    final provider = context.read<GroupExerciseProvider>();
    Future.microtask(() {
      provider.fetchBeginnerExercises(limitCount: 6);
    });
  }

  Future<Map<String, dynamic>?> _loadTodayWorkout() async {
    await LocalNotificationService.instance.syncTodayWorkoutReminders();

    final todayKey = _dateKey(DateTime.now());
    final schedules = await SupabaseService().getMyTrainingSchedules();

    for (final schedule in schedules) {
      final course = schedule['course'] as Map<String, dynamic>?;
      final days = (schedule['days'] as List? ?? [])
          .map((day) => Map<String, dynamic>.from(day as Map))
          .toList();

      for (final day in days) {
        final plannedDate = DateTime.tryParse('${day['planned_date']}');
        if (plannedDate == null || _dateKey(plannedDate) != todayKey) {
          continue;
        }

        return {
          'title': course?['title']?.toString() ?? 'Lịch tập của bạn',
          'completed': day['completed'] == true,
        };
      }
    }

    return null;
  }

  String _dateKey(DateTime date) {
    final local = date.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Auto chart theo tháng hiện tại
  List<ChartData> _generateAutoChartData() {
    final now = DateTime.now();
    return List.generate(6, (index) {
      final date = DateTime(now.year, now.month - (5 - index));
      return ChartData('T${date.month}', 160 + index * 5, 65 + index * 1.2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _generateAutoChartData();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===============================
            /// PHYSICAL CONDITION
            /// ===============================
            TextTile(title: 'overview.physical_condition'.tr()),
            const Gap(10),

            SizedBox(
              height: 320,
              width: context.deviceSize.width,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'overview.weight_kg'.tr()),
                  minimum: 30,
                  maximum: 100,
                  interval: 10,
                ),
                axes: <NumericAxis>[
                  NumericAxis(
                    name: 'HeightAxis',
                    opposedPosition: true,
                    title: AxisTitle(text: 'overview.height_cm'.tr()),
                    minimum: 130,
                    maximum: 200,
                    interval: 10,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  toggleSeriesVisibility: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CartesianSeries<ChartData, String>>[
                  LineSeries<ChartData, String>(
                    name: 'overview.height'.tr(),
                    dataSource: data,
                    xValueMapper: (d, _) => d.month,
                    yValueMapper: (d, _) => d.height,
                    yAxisName: 'HeightAxis',
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.pentagon,
                    ),
                    color: context.colorScheme.primary,
                    width: 2,
                  ),
                  LineSeries<ChartData, String>(
                    name: 'overview.weight'.tr(),
                    dataSource: data,
                    xValueMapper: (d, _) => d.month,
                    yValueMapper: (d, _) => d.weight,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.red,
                    width: 2,
                  ),
                ],
              ),
            ),

            /// ===============================
            /// TODAY SCHEDULE
            /// ===============================
            TextTile(title: 'overview.today_schedule'.tr()),
            FutureBuilder<Map<String, dynamic>?>(
              future: _todayWorkoutFuture,
              builder: (context, snapshot) {
                final todayWorkout = snapshot.data;
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting;
                final hasWorkout = todayWorkout != null;
                final completed = todayWorkout?['completed'] == true;
                final workoutText = isLoading
                    ? 'Đang tải lịch tập...'
                    : hasWorkout
                    ? (completed
                          ? 'Đã hoàn thành hôm nay ✅'
                          : todayWorkout['title']?.toString() ??
                                'Lịch tập của bạn')
                    : 'overview.no_workout'.tr();

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: completed
                                  ? Colors.green
                                  : context.colorScheme.primary,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/schedule.png',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'overview.today_workout'.tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(5),
                              Text(
                                workoutText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: completed
                                      ? Colors.green
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasWorkout && !completed)
                          const Icon(
                            Icons.notifications_active,
                            color: Colors.orange,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: MyCalendar(),
            ),

            const Gap(10),

            /// ===============================
            /// AI WORKOUT
            /// ===============================
            TextTile(title: 'AI Coach'),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomChatScreenAI(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF673AB7),
                        Color(0xFF00B5D8),
                        Color(0xFFCA33FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF673AB7).withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Coach cá nhân',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 21,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              'Hỏi về tập luyện, dinh dưỡng, yoga, phục hồi và kế hoạch giảm cân/tăng cơ.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Gap(10),

            /// ===============================
            /// POPULAR WORKOUT
            /// ===============================
            TextTile(title: 'overview.popular_workout'.tr()),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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

            /// ===============================
            /// PERSONAL COACH
            /// ===============================
            TextTile(title: 'overview.personal_coach'.tr()),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    buildCoachCard(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrdOI-pFGm7VdHOcUd6oDxmu1KVtpPMRqE_A&s",
                      "Alex Morgan",
                    ),
                    buildCoachCard(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxV7ToOVEGNyP05_I6kdLnxDrGwKF_mOmcqQ&s",
                      "Maya Santos",
                    ),
                    buildCoachCard(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyaV0bWwrQvU3TKjhtqMbMoXssD23mDFa2g&s",
                      "Daniel Lee",
                    ),
                  ],
                ),
              ),
            ),

            const Gap(10),

            /// ===============================
            /// NEW WORKOUT - DB BEGINNER
            /// ===============================
            TextTile(title: 'overview.new_workout'.tr()),
            Consumer<GroupExerciseProvider>(
              builder: (context, provider, _) {
                final beginnerList = provider.beginnerList;

                if (provider.isLoading && beginnerList.isEmpty) {
                  return const SizedBox(
                    height: 190,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (beginnerList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: Text('workouts.no_workouts'.tr()),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: beginnerList.map((workout) {
                        return GestureDetector(
                          onTap: () {
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
                          child: buildImageCard(
                            context,
                            workout.urlThumbnail,
                            workout.title,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// MODEL
/// ===============================
class ChartData {
  final String month;
  final double height;
  final double weight;

  ChartData(this.month, this.height, this.weight);
}
