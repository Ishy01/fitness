import 'package:flutter/material.dart';
import 'workout_detail_screen.dart';

class HomeWorkoutScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'Abs', 'image': 'assets/images/abs.jpg'},
    {'name': 'Arms', 'image': 'assets/images/arms.jpg'},
    {'name': 'Chest', 'image': 'assets/images/chest.jpg'},
    {'name': 'Back', 'image': 'assets/images/back.jpg'},
    {'name': 'Legs', 'image': 'assets/images/legs.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Workout')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetailScreen(category: categories[index]['name']!),
                  ),
                );
              },
              child: SizedBox( // Added SizedBox to ensure the widget is laid out
                height: 200, // Set a fixed height for the card
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      // Image background
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: categories[index]['image'] != null
                              ? Image.asset(
                                  categories[index]['image']!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Center(
                                    child: Text(
                                      'No Image',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      // Text overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            categories[index]['name'] ?? 'Category', // Null-safe check
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
