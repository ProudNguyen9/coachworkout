import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ActiveChart extends StatelessWidget {
  const ActiveChart({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 20,
        labelFormat: '{value}%',
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<ChartData, String>>[
        AreaSeries<ChartData, String>(
          dataSource: _getChartData(locale),
          xValueMapper: (ChartData data, _) => data.day,
          yValueMapper: (ChartData data, _) => data.value,
          borderColor: Colors.blue.shade700,
          borderWidth: 1.5,
          gradient: LinearGradient(
            colors: [Colors.blue.shade200.withOpacity(0.5), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    );
  }

  List<ChartData> _getChartData(String locale) {
    final now = DateTime.now();

    return List.generate(6, (index) {
      final day = now.subtract(Duration(days: 5 - index));
      final label = DateFormat.E(locale).format(day); // auto vi/en
      return ChartData(label, _mockValue(index));
    });
  }

  double _mockValue(int index) {
    return [5, 25, 20, 45, 55, 80][index].toDouble();
  }
}

class ChartData {
  ChartData(this.day, this.value);
  final String day;
  final double value;
}
