import 'dart:math';

class CaloriesTracker {
  static const double MET_WALKING = 3.5; // Metabolic equivalent for walking
  static const double MET_RUNNING = 7.5; // Metabolic equivalent for running
  bool _isPaused = false;
  double _totalCalories = 0.0;
  //double _weight = 0.0;


  double calculateCaloriesBurned(double distance, double weight, double speed) {
    double met = speed > 2.0 ? MET_RUNNING : MET_WALKING;
    return met * weight * distance / 1000.0;
  }

  double getTotalCalories() {
    return _totalCalories;
  }

  void pauseTracking() {
    _isPaused = true;
  }

  void resumeTracking() {
    _isPaused = false;
  }
}
