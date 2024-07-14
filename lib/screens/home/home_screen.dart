import 'package:fitness/common/color_extension.dart';
import 'package:fitness/screens/home/gym_screen.dart';
import 'package:fitness/screens/home/notification_screen.dart';
import 'package:fitness/screens/home/recipe_scree.dart';
import 'package:flutter/material.dart';
import 'progress_chart.dart';
import 'summary_card.dart';
import 'recommendation_card.dart';
import '../../common_widgets/discover_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColor.white,
      appBar: AppBar(
        backgroundColor: TextColor.white,
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Your Progress',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Handle chart tap, navigate to detailed progress view
              },
              child: ProgressChart(),
            ),
            SizedBox(height: 32),
            Text(
              'Summary Stats',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(
                    title: 'Steps',
                    value: '7,540',
                    icon: Icons.directions_walk),
                SummaryCard(
                    title: 'Calories',
                    value: '1,230',
                    icon: Icons.local_fire_department),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(
                    title: 'Distance',
                    value: '5.2 km',
                    icon: Icons.directions_run),
                SummaryCard(
                    title: 'Workouts', value: '3', icon: Icons.fitness_center),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Recommendations',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            RecommendationCard(
                title: 'Morning Run',
                description: 'A 30-minute run to start your day with energy.',
                icon: Icons.directions_run),
            SizedBox(height: 16),
            RecommendationCard(
                title: 'Strength Training',
                description:
                    'Focus on upper body strength with these exercises.',
                icon: Icons.fitness_center),
            SizedBox(height: 32),
            Text(
              'Discover',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            DiscoverCard(
              imagePath: 'assets/images/what_3.png',
              title: 'Gym Workouts',
              description: 'Explore various gym workouts.',
              icon: Icons.fitness_center,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GymWorkoutScreen()),
                );
              },
            ),
            SizedBox(height: 16),
            DiscoverCard(
              imagePath: 'assets/images/honey_pan.png',
              title: 'Healthy Recipes',
              description: 'Discover healthy recipes.',
              icon: Icons.restaurant_menu,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
