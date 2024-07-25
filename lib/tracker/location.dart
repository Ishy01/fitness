import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationTracker extends ChangeNotifier {
  StreamSubscription<Position>? _positionSubscription;
  Position? _previousPosition;
  double totalDistance = 0.0;
  double speed = 0.0;
  bool _isPaused = false;

  Future<void> startTracking() async {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      if (_previousPosition != null && !_isPaused) {
        totalDistance += Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        speed = position.speed;
      }
      _previousPosition = position;
      notifyListeners();
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _previousPosition = null;
    totalDistance = 0.0;
    speed = 0.0;
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
}