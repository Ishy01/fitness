import 'package:cloud_firestore/cloud_firestore.dart';

class DailyProgressData {
  final int steps;
  final double calories;
  final int workouts;
  final double distance;
  final DateTime date;

  DailyProgressData({
    required this.steps,
    required this.calories,
    required this.workouts,
    required this.distance,
    required this.date,
  });

  // Convert JSON data to a DailyProgressData object
  factory DailyProgressData.fromJson(Map<String, dynamic> json) {
    return DailyProgressData(
      date: (json['date'] as Timestamp).toDate(),
      steps: json['steps'] ?? 0,
      calories: json['calories']?.toDouble() ?? 0.0,
      workouts: json['workouts'] ?? 0,
      distance: json['distance']?.toDouble() ?? 0.0,
    );
  }

  // Convert a DailyProgressData object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'date': Timestamp.fromDate(date),
      'steps': steps,
      'calories': calories,
      'workouts': workouts,
      'distance': distance,
    };
  }

}
