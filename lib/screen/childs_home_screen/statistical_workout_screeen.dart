import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      children: const [
        _SummaryCard(
          title: 'Workouts',
          value: '5',
          icon: Icons.fitness_center,
          color: Colors.blue,
        ),
        SizedBox(width: 12),
        _SummaryCard(
          title: 'Steps',
          value: '42k',
          icon: Icons.directions_walk,
          color: Colors.green,
        ),
        SizedBox(width: 12),
        _SummaryCard(
          title: 'Calories',
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
      title: 'Workout Sessions',
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<_DayData, String>>[
          LineSeries(
            color: primary,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
            dataSource: _weekWorkout,
            xValueMapper: (d, _) => d.day,
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
      title: 'Walking (Steps)',
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ColumnSeries<_DayData, String>>[
          ColumnSeries(
            color: primary,
            borderRadius: BorderRadius.circular(6),
            dataSource: _weekSteps,
            xValueMapper: (d, _) => d.day,
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
      title: 'Calories Burned',
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<_DayData, String>>[
          SplineSeries(
            color: primary,
            width: 3,
            dataSource: _weekCalories,
            xValueMapper: (d, _) => d.day,
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
  _DayData('Mon', 1),
  _DayData('Tue', 0),
  _DayData('Wed', 1),
  _DayData('Thu', 1),
  _DayData('Fri', 0),
  _DayData('Sat', 1),
  _DayData('Sun', 1),
];

final _weekSteps = [
  _DayData('Mon', 6000),
  _DayData('Tue', 4500),
  _DayData('Wed', 7000),
  _DayData('Thu', 8000),
  _DayData('Fri', 5000),
  _DayData('Sat', 9000),
  _DayData('Sun', 6500),
];

final _weekCalories = [
  _DayData('Mon', 400),
  _DayData('Tue', 350),
  _DayData('Wed', 500),
  _DayData('Thu', 600),
  _DayData('Fri', 420),
  _DayData('Sat', 700),
  _DayData('Sun', 530),
];
