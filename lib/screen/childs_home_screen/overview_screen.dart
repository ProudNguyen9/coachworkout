import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/widgets.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> data = [
      ChartData('Jan', 160, 65),
      ChartData('Feb', 160.5, 65.5),
      ChartData('Mar', 171, 66),
      ChartData('Apr', 175.2, 66.2),
      ChartData('May', 181.5, 69.5),
      ChartData('Jun', 190, 70),
    ];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextTile(title: 'Your Physical Condition'),
          const Gap(10),
          SizedBox(
            height: 320,
            width: context.deviceSize.width,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Weight (kg)'),
                minimum: 30,
                maximum: 100,
                interval: 10,
              ),
              axes: <NumericAxis>[
                NumericAxis(
                  name: 'HeightAxis',
                  opposedPosition: true,
                  title: AxisTitle(text: 'Height (cm)'),
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
                  name: 'Height',
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
                  name: 'Weight',
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

          TextTile(title: 'Today’s workout schedule'),
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
                  // Text bên phải
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Today's workout:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const Gap(5),
                        Text(
                          "No workout found for today",
                          style: TextStyle(
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
          TextTile(title: 'Workout with AI'),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Row(
              children: [
                // Nút 1: Workout with AI
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF673AB7),
                          Color(0xFF00B5D8),
                          Color(0xFFCA33FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'AI\nTraining',
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'AI\nCoaching',
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
          TextTile(title: 'Popular wourkouts'),
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
          TextTile(title: 'Personal Coach'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  buildCoachCard(
                    "https://images.unsplash.com/photo-1606813907291-25c3bbf3f79f?w=300",
                    "Kolbjørn Lindberg",
                  ),
                  buildCoachCard(
                    "https://images.unsplash.com/photo-1571019613576-2b22c76fd955?w=300",
                    "Seba Vega",
                  ),
                  buildCoachCard(
                    "https://images.unsplash.com/photo-1594737625785-c5c87c92a0f9?w=300",
                    "Reborn Coach",
                  ),
                  buildCoachCard(
                    "https://images.unsplash.com/photo-1606813907291-25c3bbf3f79f?w=300",
                    "Kolbjørn Lindberg",
                  ),
                  buildCoachCard(
                    "https://images.unsplash.com/photo-1571019613576-2b22c76fd955?w=300",
                    "Seba Vega",
                  ),
                  buildCoachCard(
                    "https://images.unsplash.com/photo-1594737625785-c5c87c92a0f9?w=300",
                    "Reborn Coach",
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
          TextTile(title: 'New wourkouts'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
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
                ],
              ),
            ),
          ),
          const Gap(10),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text.rich(
                  TextSpan(
                    text: "Cannot find you want ? ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Tell us please",
                        style: TextStyle(color: context.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}

class ChartData {
  final String month;
  final double height;
  final double weight;

  ChartData(this.month, this.height, this.weight);
}
