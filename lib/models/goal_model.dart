class GoalModel {
  final String id;
  final String title;
  final String target;
  final String current;
  final double progress;
  final String date; // New field to store the goal's date
  final bool completed; // New field to store the completion status

  GoalModel({
    this.id = '',
    required this.title,
    required this.target,
    required this.current,
    required this.progress,
    required this.date,
    this.completed = false,
  });

  factory GoalModel.fromMap(Map<String, dynamic> data) {
    return GoalModel(
      id: data['id'] ?? '',
      title: data['title'],
      target: data['target'],
      current: data['current'],
      progress: (data['progress'] as num).toDouble(),
      date: data['date'],
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'target': target,
      'current': current,
      'progress': progress,
      'date': date,
      'completed': completed,
    };
  }
}
