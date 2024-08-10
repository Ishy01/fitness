import 'package:flutter/material.dart';
import 'package:fitness/models/activity_session.dart';

class ActivityDetailScreen extends StatelessWidget {
  final ActivitySession activity;

  ActivityDetailScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    final duration = activity.endTime.difference(activity.startTime).inMinutes;
    final distance = activity.distance / 1000; // Convert to km
    final steps = activity.steps;
    final calories = activity.calories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity: ${activity.activityType}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Date: ${activity.startTime.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Time: ${activity.startTime.toLocal().toString().split(' ')[1].split('.')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            Divider(height: 32, thickness: 2),
            Text(
              'Duration: $duration minutes',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Distance: ${distance.toStringAsFixed(2)} km',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Steps: $steps',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Calories Burned: ${calories.toStringAsFixed(2)} kcal',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
