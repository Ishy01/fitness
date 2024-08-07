import 'package:fitness/screens/profile/account/activity_history_detail.dart';
import 'package:flutter/material.dart';
import 'package:fitness/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/models/activity_session.dart';

class ActivityHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_history') {
                _showClearHistoryDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'clear_history',
                  child: Text('Clear History', style: TextStyle(fontSize: 14)),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ActivitySession>>(
        future: DatabaseService(userId: user!.uid).getUserActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading activities'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No activities found'));
          } else {
            final activities = snapshot.data!;
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.activityType,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Date: ${activity.startTime.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Time: ${activity.startTime.toLocal().toString().split(' ')[1].split('.')[0]}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActivityDetailScreen(activity: activity),
                                  ),
                                );
                              },
                              child: Text('View Details'),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteDialog(context, activity.activityId);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String activityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Activity'),
          content: Text('Are you sure you want to delete this activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteActivity(context, activityId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteActivity(BuildContext context, String activityId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await DatabaseService(userId: user.uid).deleteActivity(activityId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Activity deleted'),
        ));
        (context as Element).reassemble(); // Refresh the screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete activity: $e'),
        ));
      }
    }
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Activity History'),
          content: Text('Are you sure you want to clear all activity history?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _clearActivityHistory(context);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _clearActivityHistory(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await DatabaseService(userId: user.uid).clearActivityHistory();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Activity history cleared'),
        ));
        (context as Element).reassemble(); // Refresh the screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to clear history: $e'),
        ));
      }
    }
  }
}
