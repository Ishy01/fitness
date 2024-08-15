import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTracker extends ChangeNotifier {
  StreamSubscription<Position>? _positionSubscription;
  Position? _previousPosition;
  double totalDistance = 0.0;
  double speed = 0.0;
  List<LatLng> routeCoords = [];
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
        routeCoords.add(LatLng(position.latitude, position.longitude));
      } else if (_previousPosition == null && !_isPaused) {
        // Add the initial position to the route
        routeCoords.add(LatLng(position.latitude, position.longitude));
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
    routeCoords.clear();
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

  // Getter to retrieve the route as a list of maps with 'lat' and 'lng'
  List<Map<String, double>> get route => routeCoords
      .map((coord) => {'lat': coord.latitude, 'lng': coord.longitude})
      .toList();
}
