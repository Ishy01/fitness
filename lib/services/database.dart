import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/activity_session.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({required this.userId});

  // Create or update user data
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  // Get user data
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
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
      await _db.collection('users').doc(userId).collection('activities').add(activityData);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUser(UserModel user) async {
    return await userCollection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  // Get a specific activity
  Future<ActivitySession?> getActivity(String activityId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).collection('activities').doc(activityId).get();
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
      QuerySnapshot snapshot = await _db.collection('users').doc(userId).collection('activities').get();
      return snapshot.docs.map((doc) => ActivitySession.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
