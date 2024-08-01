import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  // Placeholder data for achievements
  final List<String> achievements = [
    'Ran 10km',
    'Lost 5kg',
    'Completed 100 workouts'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: ListView.builder(
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(achievements[index]),
          );
        },
      ),
    );
  }
}
