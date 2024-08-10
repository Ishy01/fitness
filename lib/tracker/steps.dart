import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class StepTracker extends ChangeNotifier {
  Stream<StepCount>? _stepCountStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  int steps = 0;
  int _initialStepCount = 0;
  bool _isPaused = false;

  StepTracker() {
    _stepCountStream = Pedometer.stepCountStream;
  }

  void startTracking() {
    _initialStepCount = 0; // Reset initial step count on start
    _stepCountSubscription = _stepCountStream?.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  void stopTracking() {
    _stepCountSubscription?.cancel();
    _initialStepCount = 0; // Reset initial step count on stop
    notifyListeners();
  }

  void pauseTracking() {
    _isPaused = true;
    notifyListeners();
  }

  void resumeTracking() {
    _isPaused = false;
    notifyListeners();
  }

  void _onStepCount(StepCount event) {
    if (_isPaused) return; // Don't update steps if paused
    if (_initialStepCount == 0) {
      _initialStepCount = event.steps;
    }
    steps = event.steps - _initialStepCount;
    notifyListeners();
  }


  void _onStepCountError(error) {
    print('Step Count not available');
  }
}
