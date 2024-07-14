import 'package:fitness/common_widgets/pause_button.dart';
import 'package:fitness/common_widgets/stop_button.dart';
import 'package:flutter/material.dart';

class ActivityTrackingScreen extends StatelessWidget {
  final String time;
  final String speed;
  final String distance;
  final VoidCallback onStop;
  final VoidCallback onPause;

  ActivityTrackingScreen(
      {required this.time,
      required this.speed,
      required this.distance,
      required this.onStop,
      required this.onPause});

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
            'Tracking',
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
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StopButton(onPressed: onStop),
              PauseButton(onPressed: onPause),
            ],
          ),
        ],
      ),
    );
  }
}
