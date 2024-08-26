import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String reps;

  WorkoutCard({required this.imageUrl, required this.name, required this.reps});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Text('Reps: $reps'),
        ],
      ),
    );
  }
}
