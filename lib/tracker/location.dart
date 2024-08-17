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
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle appropriately
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Adjust filter if needed
      ),
    ).listen(
      (Position position) {
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
      },
      onError: (error) {
        // Handle error appropriately
        stopTracking();
      },
    );
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

  List<Map<String, double>> get route => routeCoords
      .map((coord) => {'lat': coord.latitude, 'lng': coord.longitude})
      .toList();
}
