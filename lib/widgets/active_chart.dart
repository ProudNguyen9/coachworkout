import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ActiveChart extends StatelessWidget {
  const ActiveChart({super.key});

  @override
  Widget build(BuildContext context) {
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
          dataSource: _getChartData(),
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

  List<ChartData> _getChartData() {
    return [
      ChartData('Mon', 5),
      ChartData('Tues', 25),
      ChartData('Wed', 20),
      ChartData('Thu', 45),
      ChartData('Fri', 55),
      ChartData('Sat', 80),
    ];
  }
}

class ChartData {
  ChartData(this.day, this.value);
  final String day;
  final double value;
}
