class ActivitySession {
  final String activityId;
  final String userId;
  final String activityType;
  final DateTime startTime;
  final DateTime endTime;
  final double distance;
  final int steps;
  final double calories;
  final double speed;
  final List<Map<String, double>> route;

  ActivitySession({
    required this.activityId,
    required this.userId,
    required this.activityType,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.steps,
    required this.calories,
    required this.speed,
    required this.route,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityId': activityId,
      'userId': userId,
      'activityType': activityType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'steps': steps,
      'calories': calories,
      'speed': speed,
      'route': route
          .map((point) => {'lat': point['lat'], 'lng': point['lng']})
          .toList(),
    };
  }

  factory ActivitySession.fromMap(Map<String, dynamic> map) {
    return ActivitySession(
      activityId: map['activityId'],
      userId: map['userId'],
      activityType: map['activityType'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      distance: (map['distance'] as num).toDouble(),
      steps: map['steps'],
      calories: (map['calories'] as num).toDouble(),
      speed: (map['speed'] as num).toDouble(),
      route: (map['route'] as List<dynamic>)
          .map<Map<String, double>>((point) => {
                'lat': (point['lat'] as num).toDouble(),
                'lng': (point['lng'] as num).toDouble(),
              })
          .toList(),
    );
  }
}
