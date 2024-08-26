import 'package:fitness/models/activity_session.dart';
import 'package:fitness/models/recommendation.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/services/recommendation_service.dart';
import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  final UserModel user;
  final List<ActivitySession> activities;

  RecommendationScreen({required this.user, required this.activities});

  @override
  Widget build(BuildContext context) {
    final RecommendationService recommendationService = RecommendationService(userId: user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Personalized Recommendations'),
      ),
      body: FutureBuilder<List<RecommendationModel>>(
        future: recommendationService.getRecommendations(user, activities),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching recommendations'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recommendations available'));
          } else {
            List<RecommendationModel> recommendations = snapshot.data!;

            return ListView.builder(
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                RecommendationModel recommendation = recommendations[index];

                return ListTile(
                  leading: Icon(recommendation.icon),
                  title: Text(recommendation.title),
                  subtitle: Text(recommendation.description),
                );
              },
            );
          }
        },
      ),
    );
  }
}
