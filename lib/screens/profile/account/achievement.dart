import 'package:fitness/models/goal_model.dart';
import 'package:flutter/material.dart';


class AchievementCard extends StatelessWidget {
  final GoalModel goal;

  const AchievementCard({Key? key, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Target: ${goal.target}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Progress: ${goal.progress}%',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
