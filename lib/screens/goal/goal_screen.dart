import 'package:fitness/common/color_extension.dart';
import 'package:fitness/models/goal_model.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';
import 'goal_card.dart';
import 'add_goal_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late final DatabaseService dbService;
  List<GoalModel> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    dbService = DatabaseService(userId: FirebaseAuth.instance.currentUser!.uid);
    _loadGoals();
    dbService.updateGoalProgressBasedOnActivities(); // Update progress on load
  }

  Future<void> _loadGoals() async {
    List<GoalModel> goals = await dbService.getGoals();
    setState(() {
      _goals = goals;
      _isLoading = false;
    });
  }

  void _addGoal(GoalModel goal) async {
    await dbService.addGoal(goal);
    _loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColor.white,
      appBar: AppBar(
        backgroundColor: TextColor.white,
        title: Text('Goals', style: TextStyle(color: TextColor.black)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _goals.isEmpty
              ? Center(child: Text('No goals yet, add a new one!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _goals.length,
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    return GoalCard(
                      title: goal.title,
                      progress: goal.progress,
                      target: goal.target,
                      current: goal.current,
                      date: goal.date,
                      completed: goal.completed,
                    );
                  },
                ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () async {
            final newGoal = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddGoalScreen()),
            );

            if (newGoal != null) {
              _addGoal(newGoal);
            }
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: TextColor.primaryGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
