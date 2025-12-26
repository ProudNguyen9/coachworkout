import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:easy_localization/easy_localization.dart';

/// ===============================
/// SCREEN
/// ===============================
class FitnessStatsScreen extends StatelessWidget {
  const FitnessStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.secondary;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _Summary(),
            const SizedBox(height: 24),
            _WorkoutChart(primary: primary),
            const SizedBox(height: 24),
            _WalkingChart(primary: primary),
            const SizedBox(height: 24),
            _CaloriesChart(primary: primary),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// SUMMARY
/// ===============================
class _Summary extends StatelessWidget {
  const _Summary();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          title: 'fitness.workouts'.tr(),
          value: '5',
          icon: Icons.fitness_center,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          title: 'fitness.steps'.tr(),
          value: '42k',
          icon: Icons.directions_walk,
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          title: 'fitness.calories'.tr(),
          value: '3,200',
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// WORKOUT CHART
/// ===============================
class _WorkoutChart extends StatelessWidget {
  final Color primary;

  const _WorkoutChart({required this.primary});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: 'fitness.workout_sessions'.tr(),
      child: SfCartesianChart(
        key: ValueKey(context.locale.languageCode),
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<_DayData, String>>[
          LineSeries(
            color: primary,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
            dataSource: _weekWorkout,
            xValueMapper: (d, _) => d.day.tr(),
            yValueMapper: (d, _) => d.value,
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// WALKING CHART
/// ===============================
class _WalkingChart extends StatelessWidget {
  final Color primary;

  const _WalkingChart({required this.primary});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: 'fitness.walking'.tr(),
      child: SfCartesianChart(
        key: ValueKey(context.locale.languageCode),
        primaryXAxis: CategoryAxis(),
        series: <ColumnSeries<_DayData, String>>[
          ColumnSeries(
            color: primary,
            borderRadius: BorderRadius.circular(6),
            dataSource: _weekSteps,
            xValueMapper: (d, _) => d.day.tr(),
            yValueMapper: (d, _) => d.value,
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// CALORIES CHART
/// ===============================
class _CaloriesChart extends StatelessWidget {
  final Color primary;

  const _CaloriesChart({required this.primary});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: 'fitness.calories_burned'.tr(),
      child: SfCartesianChart(
        key: ValueKey(context.locale.languageCode),
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<_DayData, String>>[
          SplineSeries(
            color: primary,
            width: 3,
            dataSource: _weekCalories,
            xValueMapper: (d, _) => d.day.tr(),
            yValueMapper: (d, _) => d.value,
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// CHART CARD
/// ===============================
class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.06)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 200, child: child),
        ],
      ),
    );
  }
}

/// ===============================
/// DATA
/// ===============================
class _DayData {
  final String day;
  final double value;

  _DayData(this.day, this.value);
}

final _weekWorkout = [
  _DayData('day.mon', 1),
  _DayData('day.tue', 0),
  _DayData('day.wed', 1),
  _DayData('day.thu', 1),
  _DayData('day.fri', 0),
  _DayData('day.sat', 1),
  _DayData('day.sun', 1),
];

final _weekSteps = [
  _DayData('day.mon', 6000),
  _DayData('day.tue', 4500),
  _DayData('day.wed', 7000),
  _DayData('day.thu', 8000),
  _DayData('day.fri', 5000),
  _DayData('day.sat', 9000),
  _DayData('day.sun', 6500),
];

final _weekCalories = [
  _DayData('day.mon', 400),
  _DayData('day.tue', 350),
  _DayData('day.wed', 500),
  _DayData('day.thu', 600),
  _DayData('day.fri', 420),
  _DayData('day.sat', 700),
  _DayData('day.sun', 530),
];
