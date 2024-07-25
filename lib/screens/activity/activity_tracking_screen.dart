import 'package:flutter/material.dart';
import '../../common_widgets/pause_button.dart';
import '../../common_widgets/resume_button.dart';
import '../../common_widgets/stop_button.dart';

class ActivityTrackingScreen extends StatelessWidget {
  final String activityName;
  final String time;
  final String speed;
  final String distance;
  final String calories;
  final String steps;
  final bool isPaused;
  final VoidCallback onStop;
  final VoidCallback onPause;

  ActivityTrackingScreen({
    required this.activityName,
    required this.time,
    required this.speed,
    required this.distance,
    required this.calories,
    required this.steps,
    required this.isPaused,
    required this.onStop,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            activityName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Time'),
                  Text(time),
                ],
              ),
              Column(
                children: [
                  Text('Speed'),
                  Text(speed),
                ],
              ),
              Column(
                children: [
                  Text('Distance'),
                  Text(distance),
                ],
              ),
              Column(
                children: [
                  Text('Calories'),
                  Text(calories),
                ],
              ),
              Column(
                children: [
                  Text('Steps'),
                  Text(steps),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StopButton(onPressed: onStop),
              isPaused
                  ? ResumeButton(onPressed: onPause)
                  : PauseButton(onPressed: onPause),
            ],
          ),
        ],
      ),
    );
  }
}
