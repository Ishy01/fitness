import 'dart:async';
import 'package:flutter/material.dart';

class TimerTracker extends ChangeNotifier {
  Timer? _timer;
  Duration _elapsed = Duration();
  bool _isPaused = false;
  DateTime? startTime;

  String get formattedTime => _formatDuration(_elapsed);

  void startTracking() {
    _elapsed = Duration();
    startTime = DateTime.now(); // Reset elapsed time on start
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  void stopTracking() {
    _timer?.cancel();
    _elapsed = Duration(); // Reset elapsed time on stop
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

  void _onTick(Timer timer) {
    if (!_isPaused) {
      _elapsed = Duration(seconds: _elapsed.inSeconds + 1);
      notifyListeners();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
