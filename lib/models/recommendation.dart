import 'package:flutter/material.dart';

class RecommendationModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  RecommendationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  factory RecommendationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return RecommendationModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: IconData(int.parse(data['icon'] ?? '0xe3af'), fontFamily: 'MaterialIcons'),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'icon': icon.codePoint.toString(),
    };
  }
}
