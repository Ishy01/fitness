import 'package:fitness/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'goal_card.dart';
import 'add_goal_screen.dart';

class GoalsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> goals = [
    {'title': 'Lose Weight', 'progress': 70, 'target': '5 kg', 'current': '3.5 kg'},
    {'title': 'Build Muscle', 'progress': 40, 'target': '10 kg', 'current': '4 kg'},
    {'title': 'Improve Endurance', 'progress': 60, 'target': 'Run 5 km', 'current': '3 km'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColor.white,
      appBar: AppBar(
        backgroundColor: TextColor.white,
        title: Text('Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: goals.map((goal) {
            return GoalCard(
              title: goal['title'],
              progress: goal['progress'],
              target: goal['target'],
              current: goal['current'],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGoalScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
