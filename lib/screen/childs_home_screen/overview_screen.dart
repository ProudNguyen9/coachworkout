import 'package:coach_workout/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/widgets.dart';
import '../screens.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

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
            Card(
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
                          color: context.colorScheme.primary,
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
                            'overview.no_workout'.tr(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: MyCalendar(),
            ),

            const Gap(10),

            /// ===============================
            /// AI WORKOUT
            /// ===============================
            TextTile(title: 'overview.workout_ai'.tr()),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomChatScreenAI(),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF673AB7),
                              Color(0xFF00B5D8),
                              Color(0xFFCA33FF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'overview.ai_consult'.tr(),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.redAccent,
                            Color(0xD9F6A122),
                            Color(0xDEFE7676),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'overview.ai_nutrition'.tr(),
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
            /// NEW WORKOUT
            /// ===============================
            TextTile(title: 'overview.new_workout'.tr()),
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
