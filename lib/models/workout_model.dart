import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String level;
  final int sets;
  final int duration; // Add duration here
  final Timestamp timestamp;

  WorkoutModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.level,
    required this.sets,
    required this.duration, // Initialize duration
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'category': category,
      'level': level,
      'sets': sets,
      'duration': duration, // Add duration to the map
      'timestamp': timestamp,
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      level: map['level'] ?? '',
      sets: map['sets'] ?? 0,
      duration: map['duration'] ?? 0, // Add duration here
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}
