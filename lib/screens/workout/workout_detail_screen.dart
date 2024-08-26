import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:fitness/screens/workout/congratulations.dart';
import 'package:fitness/screens/workout/workout_data.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/workout_model.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String category;
  WorkoutDetailScreen({required this.category});

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  String selectedLevel = 'Beginner';
  List<Map<String, dynamic>> workouts = [];
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  DateTime? workoutStartTime;

  @override
  void initState() {
    super.initState();
    workouts = _getWorkoutsForCategory(widget.category, selectedLevel);
    workoutStartTime = DateTime.now();
  }

  List<Map<String, dynamic>> _getWorkoutsForCategory(
      String category, String level) {
    return getWorkoutsByCategoryAndLevel(category, level);
  }

  Future<void> _completeWorkout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && workoutStartTime != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workouts')
          .doc();

      final workoutId = docRef.id;
      final workoutDuration =
          DateTime.now().difference(workoutStartTime!).inMinutes;

      WorkoutModel workout = WorkoutModel(
        id: workoutId,
        userId: user.uid,
        name: '${widget.category} Workout',
        category: widget.category,
        level: selectedLevel,
        sets: workouts.length,
        duration: workoutDuration,
        timestamp: Timestamp.now(),
      );

      final databaseService = DatabaseService(userId: user.uid);
      await databaseService.saveWorkout(workout.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout completed and saved successfully!')),
      );
    }
  }

  void _startWorkout() async {
    for (var i = 0; i < workouts.length; i++) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(workouts[i]['name']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 350, // Adjusted width
                  height: 350, // Adjusted height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(workouts[i]['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Reps: ${workouts[i]['reps']}'),
                Text('Sets: ${workouts[i]['sets']}'),
                SizedBox(height: 10),
                Text('Instructions: ${workouts[i]['instructions']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(i == workouts.length - 1 ? 'Finish' : 'Next'),
              ),
            ],
          );
        },
      );
    }

    // Complete and save the workout after finishing all exercises
    _completeWorkout();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CongratulationsScreen()),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      selectedLevel = ['Beginner', 'Intermediate', 'Advanced'][index];
      workouts = _getWorkoutsForCategory(widget.category, selectedLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} Workouts')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                Center(child: Text('Beginner')),
                Center(child: Text('Intermediate')),
                Center(child: Text('Advanced')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    workouts[index]['image'],
                    width: 80, // Same width
                    height: 80, // Same height
                  ),
                  title: Text(workouts[index]['name']),
                  subtitle: Text(
                      'Reps: ${workouts[index]['reps']} | Sets: ${workouts[index]['sets']}'),
                );
              },
            ),
          ),
          RoundedButton(
            title: 'Start Workout',
            onPressed: _startWorkout,
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
