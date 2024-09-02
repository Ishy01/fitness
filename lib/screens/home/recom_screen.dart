import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  final String userId;

  RecommendationScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Recommendations")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('recommendations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final recommendations = snapshot.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['recommendations'].join("\n")),
              onTap: () {
                // Handle tap event
              },
            );
          }).toList();

          return ListView(children: recommendations);
        },
      ),
    );
  }
}
