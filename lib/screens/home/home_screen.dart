import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:fitness/screens/home/gym_screen.dart';
import 'package:fitness/screens/home/notification_screen.dart';
import 'package:fitness/screens/home/recipe_scree.dart';
import 'package:flutter/material.dart';
import 'package:fitness/models/progress.dart';
import 'progress_chart.dart';
import 'summary_card.dart';
import 'recommendation_card.dart';
import 'package:pedometer/pedometer.dart';
import '../../common_widgets/discover_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _stepCountValue = '0';
  double _caloriesBurned = 0.0;
  Stream<StepCount>? _stepCountStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  int _activeIndex = 0;
  int _workoutsCompleted = 0;
  double _distanceCovered = 0.0;
  int _initialSteps = 0;
  int _lastResetDay = -1;
  final _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
  }

  Future<void> _initializeCurrentUser() async {
    _currentUser = _auth.currentUser;
    setState(() {});
  }

  void _onStepCount(StepCount event) {
  DateTime now = DateTime.now();
  int currentDay = now.day;

  if (_lastResetDay != currentDay) {
    // Reset baseline for a new day
    _initialSteps = event.steps;
    _lastResetDay = currentDay;
  }

  // Define dailySteps outside the setState block
  int dailySteps = event.steps - _initialSteps;

  setState(() {
    _stepCountValue = dailySteps.toString();
    _caloriesBurned = calculateCalories(dailySteps);
    _distanceCovered = calculateDistance(dailySteps);
  });

  _updateDailyProgress(dailySteps, _caloriesBurned);
}


  void _onStepCountError(error) {
    print('Error: $error');
    setState(() {
      _stepCountValue = 'Step Count not available';
    });
  }

  double calculateCalories(int steps) {
    // A simple estimation: 0.04 calories per step
    return steps * 0.04;
  }

  double calculateDistance(int steps) {
    return steps * 0.0008; // distance in kilometers
  }

  void _updateDailyProgress(int steps, double calories) async {
    if (_currentUser == null) return;

    final progressRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('progress')
        .doc(DateTime.now().toIso8601String().substring(0, 10));

    final progressData = ProgressData(
      date: DateTime.now(),
      steps: steps,
      calories: calories,
      workouts: 0,
    );

    await progressRef.set(progressData.toMap(), SetOptions(merge: true));
  }

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
            Container(
              height: 300, // Adjusted height to fit all content
              child: Column(
                children: [
                  // Title above the chart
                  Text(
                    _activeIndex == 0
                        ? 'Steps'
                        : _activeIndex == 1
                            ? 'Calories'
                            : 'Workouts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // PageView with ProgressChart
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        ProgressChart(
                          userId: _currentUser!.uid,
                          chartType: 'steps',
                          activeIndex: _activeIndex,
                        ),
                        ProgressChart(
                          userId: _currentUser!.uid,
                          chartType: 'calories',
                          activeIndex: _activeIndex,
                        ),
                        ProgressChart(
                          userId: _currentUser!.uid,
                          chartType: 'workouts',
                          activeIndex: _activeIndex,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  // Dots indicatorSizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _activeIndex == i ? Colors.blue : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
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
                    value: _stepCountValue,
                    icon: Icons.directions_walk),
                SummaryCard(
                    title: 'Calories',
                    value: _caloriesBurned.toStringAsFixed(2),
                    icon: Icons.local_fire_department),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(
                    title: 'Distance',
                    value: '${_distanceCovered.toStringAsFixed(2)} km',
                    icon: Icons.directions_run),
                SummaryCard(
                    title: 'Workouts',
                    value: _workoutsCompleted.toString(),
                    icon: Icons.fitness_center),
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
