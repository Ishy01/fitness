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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            activityName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              Text(
                'Time',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('Speed', speed),
              _buildStatColumn('Distance', distance),
              _buildStatColumn('Calories', calories),
              _buildStatColumn('Steps', steps),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
