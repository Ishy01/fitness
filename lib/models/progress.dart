import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressData {
  final DateTime date;
  final int steps;
  final double calories;
  final int workouts;

  ProgressData({
    required this.date,
    required this.steps,
    required this.calories,
    required this.workouts,
  });

  factory ProgressData.fromMap(Map<String, dynamic> data) {
    return ProgressData(
      date: (data['date'] as Timestamp).toDate(),
      steps: data['steps'] ?? 0,
      calories: data['calories'] ?? 0.0,
      workouts: data['workouts'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'steps': steps,
      'calories': calories,
      'workouts': workouts,
    };
  }
}
