import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/activity_session.dart';
import 'package:fitness/models/daily_progress.dart';
import 'package:fitness/models/workout_model.dart';
import '../models/user_model.dart';
import '../models/goal_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({required this.userId});

  // Create or update user data
  Future<void> createUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      await userCollection
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  // Get user data
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Save activity
  Future<void> saveActivity(Map<String, dynamic> activityData) async {
    try {
      await userCollection.doc(userId).collection('activities').add(activityData);
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete a specific activity
  Future<void> deleteActivity(String activityId) async {
    try {
      await userCollection.doc(userId).collection('activities').doc(activityId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Clear all activities for the user
  Future<void> clearActivityHistory() async {
    try {
      QuerySnapshot snapshot = await userCollection.doc(userId).collection('activities').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Get a specific activity
  Future<ActivitySession?> getActivity(String activityId) async {
    try {
      DocumentSnapshot doc = await userCollection
          .doc(userId)
          .collection('activities')
          .doc(activityId)
          .get();
      if (doc.exists) {
        return ActivitySession.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get all activities for a user
  Future<List<ActivitySession>> getUserActivities() async {
    try {
      QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('activities')
          .orderBy('startTime', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ActivitySession.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }


// Save workout to Firestore
  Future<void> saveWorkout(Map<String, dynamic> workoutData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .add(workoutData);
    } catch (e) {
      print(e.toString());
    }
  }

// Get all workouts for a user
Future<List<WorkoutModel>> getUserWorkouts() async {
  try {
    QuerySnapshot snapshot = await userCollection.doc(userId).collection('workouts').get();
    return snapshot.docs
        .map((doc) => WorkoutModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print(e.toString());
    return [];
  }
}

// Save or update daily progress
  Future<void> saveDailyProgress(DailyProgressData progress) async {
    try {
      await userCollection
          .doc(userId)
          .collection('daily_progress')
          .doc(progress.date.toIso8601String().substring(0, 10))
          .set(progress.toJson(), SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

   // Fetch daily progress
  Future<DailyProgressData?> getDailyProgress(DateTime date) async {
    try {
      DocumentSnapshot doc = await userCollection
          .doc(userId)
          .collection('daily_progress')
          .doc(date.toIso8601String().substring(0, 10))
          .get();

      if (doc.exists) {
        return DailyProgressData.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // Add a new goal for the user
  Future<void> addGoal(GoalModel goal) async {
    try {
      await userCollection.doc(userId).collection('goals').add(goal.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  // Update an existing goal
  Future<void> updateGoal(String goalId, GoalModel goal) async {
    try {
      await userCollection
          .doc(userId)
          .collection('goals')
          .doc(goalId)
          .update(goal.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete an existing goal
  Future<void> deleteGoal(String goalId) async {
    try {
      await userCollection.doc(userId).collection('goals').doc(goalId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get all goals for the user
  Future<List<GoalModel>> getGoals() async {
    try {
      QuerySnapshot snapshot = await userCollection.doc(userId).collection('goals').get();
      return snapshot.docs
          .map((doc) => GoalModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get goals for a specific day
  Future<List<GoalModel>> getDailyGoals(DateTime date) async {
    try {
      String dateString = "${date.year}-${date.month}-${date.day}";
      QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('goals')
          .where('date', isEqualTo: dateString)
          .get();
      return snapshot.docs
          .map((doc) => GoalModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Update progress for a specific goal
  Future<void> updateGoalProgress(String goalId, double progress) async {
    try {
      await userCollection
          .doc(userId)
          .collection('goals')
          .doc(goalId)
          .update({'progress': progress});
    } catch (e) {
      print(e.toString());
    }
  }

  // Fetch and update progress for each goal based on user's activities
  Future<void> updateGoalProgressBasedOnActivities() async {
    List<GoalModel> goals = await getGoals();

    // Fetch current activity data
    int currentSteps = await getTotalStepsForToday();
    int currentCalories = await getTotalCaloriesForToday();
    double currentDistance = await getTotalDistanceForToday();
    int currentWorkouts = await getTotalWorkoutsForToday();

    for (var goal in goals) {
      double progress = 0.0;

      switch (goal.title) {
        case 'Steps':
          progress = (currentSteps / int.parse(goal.target)) * 100;
          break;
        case 'Calories':
          progress = (currentCalories / int.parse(goal.target)) * 100;
          break;
        case 'Distance':
          progress = (currentDistance / double.parse(goal.target)) * 100;
          break;
        case 'Workout':
          progress = (currentWorkouts / int.parse(goal.target)) * 100;
          break;
        default:
          break;
      }

      progress = progress.clamp(0, 100);

      // Update the goal's progress in Firestore
      await updateGoalProgress(goal.id, progress);

    }
  }

  // Get total steps for today
  Future<int> getTotalStepsForToday() async {
    try {
      QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('activities')
          .where('date', isEqualTo: DateTime.now())
          .get();

      int totalSteps = 0;
      for (var doc in snapshot.docs) {
        num? steps = (doc.data() as Map<String, dynamic>)['steps'];
        totalSteps += (steps ?? 0).toInt();
      }
      return totalSteps;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  // Get total calories for today
  Future<int> getTotalCaloriesForToday() async {
    try {
      QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('activities')
          .where('date', isEqualTo: DateTime.now())
          .get();

      int totalCalories = 0;
      for (var doc in snapshot.docs) {
        num? calories = (doc.data() as Map<String, dynamic>)['calories'];
        totalCalories += (calories ?? 0).toInt();
      }
      return totalCalories;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  // Get total distance for today
  Future<double> getTotalDistanceForToday() async {
    try {
      QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('activities')
          .where('date', isEqualTo: DateTime.now())
          .get();

      double totalDistance = 0.0;
      for (var doc in snapshot.docs) {
        num? distance = (doc.data() as Map<String, dynamic>)['distance'];
        totalDistance += (distance ?? 0.0).toDouble();
      }
      return totalDistance;
    } catch (e) {
      print(e.toString());
      return 0.0;
    }
  }

  // Get total workouts for today
  Future<int> getTotalWorkoutsForToday() async {
    try {
      QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('activities')
          .where('date', isEqualTo: DateTime.now())
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  // Get completed goals for achievements
  Future<List<GoalModel>> getCompletedGoals() async {
    try {
      QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('goals')
          .where('progress', isEqualTo: 100.0)
          .get();

      return snapshot.docs
          .map((doc) => GoalModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
