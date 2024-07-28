class ActivitySession {
  final String userId;
  final String activityType;
  final DateTime startTime;
  final DateTime endTime;
  final double distance;
  final int steps;
  final double calories;
  final double speed;

  ActivitySession({
    required this.userId,
    required this.activityType,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.steps,
    required this.calories,
    required this.speed,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'activityType': activityType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'steps': steps,
      'calories': calories,
      'speed': speed,
    };
  }

  factory ActivitySession.fromMap(Map<String, dynamic> map) {
    return ActivitySession(
      userId: map['userId'],
      activityType: map['activityType'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      distance: map['distance'],
      steps: map['steps'],
      calories: map['calories'],
      speed: map['speed'],
    );
  }
}
