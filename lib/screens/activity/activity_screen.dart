import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:fitness/common_widgets/start_button.dart';
import 'activity_type_selector.dart';
import 'activity_tracking_screen.dart';
import '../../tracker/timer.dart';
import '../../tracker/location.dart';
import '../../tracker/steps.dart';
import '../../tracker/calories.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String currentActivity = 'Running';
  bool isTracking = false;
  bool isPaused = false;
  TimerTracker? _timerTracker;
  LocationTracker? _locationTracker;
  StepTracker? _stepTracker;
  CaloriesTracker? _caloriesTracker;
  double userWeight = 70.0; // Example user weight in kg

  @override
  void initState() {
    super.initState();
    _timerTracker = TimerTracker();
    _locationTracker = LocationTracker();
    _stepTracker = StepTracker();
    _caloriesTracker = CaloriesTracker();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      await Permission.activityRecognition.request();
    }

    var locationStatus = await Permission.location.status;
    if (locationStatus.isDenied) {
      await Permission.location.request();
    }
  }

  void startActivity() {
    _timerTracker?.startTracking();
    _locationTracker?.startTracking();
    _stepTracker?.startTracking();
    setState(() {
      isTracking = true;
      isPaused = false;
    });
  }

  void stopActivity() {
    _timerTracker?.stopTracking();
    _locationTracker?.stopTracking();
    _stepTracker?.stopTracking();
    setState(() {
      isTracking = false;
      isPaused = false;
    });
    _showSaveOrDiscardDialog();
  }

  void pauseActivity() {
    _timerTracker?.pauseTracking();
    _locationTracker?.pauseTracking();
    _stepTracker?.pauseTracking();
    setState(() {
      isPaused = true;
    });
  }

  void resumeActivity() {
    _timerTracker?.resumeTracking();
    _locationTracker?.resumeTracking();
    _stepTracker?.resumeTracking();
    setState(() {
      isPaused = false;
    });
  }

  void selectActivity(String activity) {
    setState(() {
      currentActivity = activity;
    });
  }

  void _showSaveOrDiscardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Activity Finished'),
          content: Text('Do you want to save or discard this activity?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle discard action
                Navigator.of(context).pop();
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                // Handle save action
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _timerTracker!),
        ChangeNotifierProvider(create: (_) => _locationTracker!),
        ChangeNotifierProvider(create: (_) => _stepTracker!),
      ],
      child: Scaffold(
        backgroundColor: TextColor.white,
        body: Stack(
          children: [
            Placeholder(
              fallbackHeight: MediaQuery.of(context).size.height,
              fallbackWidth: double.infinity,
              color: Colors.grey,
            ),
            if (!isTracking)
              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: ActivityTypeSelector(
                  currentActivity: currentActivity,
                  onSelectActivity: (activity) => selectActivity(activity),
                ),
              ),
            if (isTracking)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Consumer3<TimerTracker, LocationTracker, StepTracker>(
                  builder: (context, timer, location, steps, child) {
                    double caloriesBurned = _caloriesTracker!.calculateCaloriesBurned(
                      location.totalDistance,
                      userWeight,
                      location.speed,
                    );
                    return ActivityTrackingScreen(
                      activityName: currentActivity,
                      time: timer.formattedTime,
                      speed: '${(location.speed * 3.6).toStringAsFixed(2)} km/h',
                      distance: '${(location.totalDistance / 1000).toStringAsFixed(2)} km',
                      steps: steps.steps.toString(),
                      calories: caloriesBurned.toStringAsFixed(2),
                      isPaused: isPaused,
                      onStop: stopActivity,
                      onPause: isPaused ? resumeActivity : pauseActivity,
                    );
                  },
                ),
              ),
            if (!isTracking)
              Positioned(
                bottom: 50,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: StartButton(onPressed: startActivity),
              ),
          ],
        ),
      ),
    );
  }
}
