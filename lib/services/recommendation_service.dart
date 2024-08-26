import 'dart:io'; // To handle the model file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:fitness/models/activity_session.dart';
import 'package:fitness/models/recommendation.dart';
import 'package:fitness/models/user_model.dart';
import 'package:flutter/material.dart';

class RecommendationService {
  final String userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RecommendationService({required this.userId});

  Future<List<RecommendationModel>> getRecommendations(UserModel user, List<ActivitySession> activities) async {
    // Fetch custom model from Firebase ML
    FirebaseCustomModel customModel = await FirebaseModelDownloader.instance.getModel(
      "recommendation_model", // Your model name
      FirebaseModelDownloadType.latestModel,
      FirebaseModelDownloadConditions(),
    );

    File modelFile = customModel.file;
    if (modelFile != null) {
      // Here, you would load the model into your inference engine, like TFLite or similar.
      // Perform inference using the model with the user data and activities
      // This part will depend on your specific ML model implementation

      // Mocked inference logic:
      List<RecommendationModel> recommendations = _generateMockRecommendations(user, activities);

      // Return the generated recommendations
      return recommendations;
    } else {
      throw Exception('Model file not found or failed to load');
    }
  }

  List<RecommendationModel> _generateMockRecommendations(UserModel user, List<ActivitySession> activities) {
    // Example: Generate recommendations based on user activities
    List<RecommendationModel> recommendations = [];

    if (activities.isNotEmpty) {
      final int totalSteps = activities.fold(0, (prev, element) => prev + element.steps);
      final double totalCalories = activities.fold(0, (prev, element) => prev + element.calories);

      if (totalSteps < 5000) {
        recommendations.add(RecommendationModel(
          id: '1',
          title: 'Increase your daily steps',
          description: 'Try to take more walks to hit your fitness goals.',
          icon: Icons.directions_walk,
        ));
      }

      if (totalCalories < 1500) {
        recommendations.add(RecommendationModel(
          id: '2',
          title: 'Burn more calories',
          description: 'Increase your activity levels to burn more calories.',
          icon: Icons.local_fire_department,
        ));
      }
    } else {
      recommendations.add(RecommendationModel(
        id: '3',
        title: 'Get moving!',
        description: 'Start logging some activities to see recommendations.',
        icon: Icons.directions_run,
      ));
    }

    return recommendations;
  }
}
