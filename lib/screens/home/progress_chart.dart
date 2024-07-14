import 'package:fitness/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TextColor.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries>[
          LineSeries<ProgressData, double>(
            dataSource: [
              ProgressData(0, 1),
              ProgressData(1, 3),
              ProgressData(2, 2),
              ProgressData(3, 5),
              ProgressData(4, 3),
              ProgressData(5, 4),
            ],
            xValueMapper: (ProgressData data, _) => data.day,
            yValueMapper: (ProgressData data, _) => data.value,
            color: TextColor.secondaryColor2,
            width: 4,
          ),
        ],
      ),
    );
  }
}

class ProgressData {
  final double day;
  final double value;

  ProgressData(this.day, this.value);
}