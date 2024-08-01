import 'package:flutter/material.dart';

class ActivityHistoryScreen extends StatelessWidget {
  // Placeholder data for activities
  final List<String> activities = [
    'Morning Run',
    'Evening Walk',
    'Cycling'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity History'),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(activities[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Implement activity deletion
              },
            ),
          );
        },
      ),
    );
  }
}
