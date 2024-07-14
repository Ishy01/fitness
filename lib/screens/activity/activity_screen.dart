import 'package:fitness/common/color_extension.dart';
import 'package:fitness/common_widgets/resume_button.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/start_button.dart';
import 'activity_type_selector.dart';
import 'activity_tracking_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String currentActivity = 'Running';
  bool isTracking = false;
  bool isPaused = false;

  void startActivity() {
    setState(() {
      isTracking = true;
      isPaused = false;
    });
  }

  void stopActivity() {
    setState(() {
      isTracking = false;
      isPaused = false;
    });
  }

  void pauseActivity() {
    setState(() {
      isPaused = true;
    });
  }

  void resumeActivity() {
    setState(() {
      isPaused = false;
    });
  }

  void selectActivity(String activity) {
    setState(() {
      currentActivity = activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColor.white,
      body: Stack(
        children: [
          Placeholder(
            fallbackHeight: MediaQuery.of(context).size.height,
            fallbackWidth: double.infinity,
            color: Colors.grey,
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: ActivityTypeSelector(
              currentActivity: currentActivity,
              onSelectActivity: (activity) => selectActivity(activity),
            ),
          ),
          if (isTracking && !isPaused)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ActivityTrackingScreen(
                time: '00:15:32',
                speed: '5.5 km/h',
                distance: '2.7 km',
                onStop: stopActivity,
                onPause: pauseActivity,
              ),
            ),
          if (!isTracking)
            Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: StartButton(onPressed: startActivity),
            ),
          if (isPaused)
            Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: ResumeButton(onPressed: resumeActivity),
            ),
        ],
      ),
    );
  }
}
