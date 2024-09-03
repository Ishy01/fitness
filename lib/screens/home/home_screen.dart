import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:fitness/main.dart';
import 'package:fitness/models/daily_progress.dart';
import 'package:fitness/screens/home/notification_screen.dart';
import 'package:fitness/screens/home/recipe_scree.dart';
import 'package:fitness/screens/workout/home_workout_screen.dart';
import 'package:flutter/material.dart';
import 'progress_chart.dart';
import 'summary_card.dart';
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
  bool _hasUnreadNotifications = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    MyApp.analytics.logEvent(
      name: 'home_screen_viewed',
      parameters: null,
    );
    _initializeCurrentUser();
    //_initializeStepCount();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
    //_fetchProgressData();
    _fetchAndSetProgressData();
    _fetchUnreadNotificationStatus();
    //_fetchRecommendations();
  }

  Future<void> _initializeCurrentUser() async {
    _currentUser = _auth.currentUser;
    setState(() {});
  }

  Future<void> _fetchAndSetProgressData() async {
    if (_currentUser == null) return;

    final progress = await getDailyProgress(DateTime.now());

    if (progress != null) {
      setState(() {
        _stepCountValue = progress.steps.toString();
        _caloriesBurned = progress.calories;
        _workoutsCompleted = progress.workouts;
        _distanceCovered = progress.distance;
        _initialSteps = progress.steps;
      });
    } else {
      // Set to default values if no data found for the current day
      setState(() {
        _stepCountValue = '0';
        _caloriesBurned = 0.0;
        _workoutsCompleted = 0;
        _distanceCovered = 0.0;
        _initialSteps = 0;
      });
    }
  }

  void _onStepCount(StepCount event) async {
   // Initialize _initialSteps to 0 when the app is started
  if (_initialSteps == 0) {
    _initialSteps = event.steps;
  }

    DateTime now = DateTime.now();
    int currentDay = now.day;

    if (_lastResetDay != currentDay) {
      // Save previous day data before resetting
      _saveAndResetDailyProgress();

      // Reset baseline for a new day
      _initialSteps = event.steps;
      _lastResetDay = currentDay;
    }

    int dailySteps = event.steps - _initialSteps;

    if (dailySteps < 0) {
      // Handle case where step count is reset
      dailySteps = 0;
    }

    setState(() {
      _stepCountValue = dailySteps.toString();
      _caloriesBurned = calculateCalories(dailySteps);
      _distanceCovered = calculateDistance(dailySteps);
    });

    _updateDailyProgress(
        dailySteps, _caloriesBurned, _workoutsCompleted, _distanceCovered);
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

  void _saveAndResetDailyProgress() async {
    await _updateDailyProgress(int.parse(_stepCountValue), _caloriesBurned,
        _workoutsCompleted, _distanceCovered);

    // Reset local data
    setState(() {
      _stepCountValue = '0';
      _caloriesBurned = 0.0;
      _workoutsCompleted = 0;
      _distanceCovered = 0.0;
    });
  }

  Future<void> _updateDailyProgress(
      int steps, double calories, int workouts, double distance) async {
    if (_currentUser == null) return;

    final dailyProgressData = DailyProgressData(
      date: DateTime.now(),
      steps: steps,
      calories: calories,
      workouts: workouts,
      distance: distance,
    );

    await saveDailyProgress(dailyProgressData);
  }

  Future<void> _fetchUnreadNotificationStatus() async {
    if (_currentUser != null) {
      final unreadNotifications = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('recommendations')
          .where('read', isEqualTo: false)
          .get();

      if (unreadNotifications.docs.isNotEmpty) {
        setState(() {
          _hasUnreadNotifications = true;
        });
      }
    }
  }

  // Future<void> initNotifications() async {
  //   final _firebaseMessaging = FirebaseMessaging.instance;

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     setState(() {
  //       _hasUnreadNotifications = true;
  //     });
  //     print("Notification received: ${message.notification?.title}");
  //   });

  //   await _firebaseMessaging.requestPermission();
  // }

  Future<DailyProgressData?> getDailyProgress(DateTime date) async {
    if (_currentUser == null) return null;

    final progressRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('daily_progress')
        .doc(date.toIso8601String().substring(0, 10));

    final progressSnapshot = await progressRef.get();

    if (progressSnapshot.exists) {
      return DailyProgressData.fromJson(progressSnapshot.data()!);
    }
    return null;
  }

  Future<void> saveDailyProgress(DailyProgressData progress) async {
    if (_currentUser == null) return;

    final progressRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('daily_progress')
        .doc(progress.date.toIso8601String().substring(0, 10));

    await progressRef.set(progress.toJson());
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
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_none_outlined,
                  size: 30,
                ),
                if (_hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _hasUnreadNotifications =
                    false; // Reset when the bell is tapped
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              ).then((_) {
                _fetchUnreadNotificationStatus();
              });
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
              'Todays Summary',
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
                    value: '$_workoutsCompleted',
                    icon: Icons.fitness_center),
              ],
            ),
            //SizedBox(height: 32),
            // Text(
            //   'Recommendations',
            //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            // ),
            // SizedBox(height: 16),
            // if (_recommendations.isNotEmpty)
            //   Column(
            //     children: _recommendations.map((recommendation) {
            //       return RecommendationCard(
            //         title: 'Recommendation',
            //         description: recommendation,
            //         icon: Icons.thumb_up,
            //       );
            //     }).toList(),
            //   )
            // else
            //   Text(
            //     'No recommendations yet.',
            //     style: TextStyle(fontSize: 18, color: Colors.grey),
            //   ),

            SizedBox(height: 32),
            Text(
              'Discover',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            DiscoverCard(
              imagePath: 'assets/images/what_3.png',
              title: 'Home Workouts',
              description: 'Explore various home workouts.',
              icon: Icons.fitness_center,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeWorkoutScreen()),
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

  void _onPageChanged(int index) {
    setState(() {
      _activeIndex = index;
    });
  }
}
