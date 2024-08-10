import 'package:flutter/material.dart';
import 'package:fitness/common/color_extension.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final double progress;
  final String target;
  final String current;
  final String date;
  final bool completed;

  GoalCard({
    required this.title,
    required this.progress,
    required this.target,
    required this.current,
    required this.date,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Text("Current: $current / Target: $target"),
            Text("Date: $date"),
            Text("Completed: ${completed ? "Yes" : "No"}"),
          ],
        ),
      ),
    );
  }
}
