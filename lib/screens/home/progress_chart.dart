import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/daily_progress.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProgressChart extends StatelessWidget {
  final String userId;
  final String chartType;
  final int activeIndex;

  ProgressChart({
    required this.userId,
    required this.chartType,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('daily_progress')
            .orderBy('date', descending: true)
            .limit(7)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final progressData = snapshot.data!.docs.map((doc) {
            return DailyProgressData.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          final today = DateTime.now();
          final daysOfWeek = List.generate(7, (index) {
            return DateFormat('EEE').format(today.subtract(Duration(days: 6 - index)));
          });

          List<BarChartGroupData> barGroups = [];
          for (int i = 0; i < 7; i++) {
            final dayDate = today.subtract(Duration(days: 6 - i));
            final data = progressData.firstWhere(
              (pd) => DateFormat('yyyy-MM-dd').format(pd.date) == DateFormat('yyyy-MM-dd').format(dayDate),
              orElse: () => DailyProgressData(date: dayDate, steps: 0, calories: 0, workouts: 0, distance: 0),
            );

            double value = 0.0;
            double maxValue = 0.0;
            switch (chartType) {
              case 'steps':
                value = data.steps.toDouble();
                maxValue = 10000; // Example max value for steps
                break;
              case 'calories':
                value = data.calories;
                maxValue = 500; // Example max value for calories
                break;
              case 'workouts':
                value = data.workouts.toDouble();
                maxValue = 10; // Example max value for workouts
                break;
            }

            List<Color> gradientColors = i % 2 == 0
                ? TextColor.primaryGradient
                : TextColor.secondaryGradient;

            barGroups.add(BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 24,
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ));
          }

          return Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 16.0), // Added padding to prevent cut-off
            child: BarChart(
              BarChartData(
                maxY: barGroups.isNotEmpty ? barGroups.map((e) => e.barRods.first.toY).reduce((a, b) => a > b ? a : b) : 1.0,
                minY: 0,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => getBottomTitles(value, meta, daysOfWeek),
                    ),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta, List<String> daysOfWeek) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      daysOfWeek[value.toInt()],
      style: style,
    ),
  );
}
