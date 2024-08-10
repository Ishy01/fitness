import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fitness/models/goal_model.dart';
import 'package:provider/provider.dart';

class AchievementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: FutureBuilder<List<GoalModel>>(
        future: databaseService.getGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No achievements yet.'));
          }

          List<GoalModel> completedGoals = snapshot.data!
              .where((goal) => goal.completed)
              .toList();

          if (completedGoals.isEmpty) {
            return Center(child: Text('No achievements yet.'));
          }

          return ListView.builder(
            itemCount: completedGoals.length,
            itemBuilder: (context, index) {
              GoalModel goal = completedGoals[index];
              return ListTile(
                title: Text(goal.title),
                subtitle: Text("Target: ${goal.target}"),
                trailing: Text("Completed on: ${goal.date}"),
              );
            },
          );
        },
      ),
    );
  }
}
