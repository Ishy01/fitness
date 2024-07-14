import 'package:fitness/common/color_extension.dart';
import 'package:fitness/common_widgets/combined_gradient.dart';
import 'package:fitness/screens/activity/activity_screen.dart';
import 'package:fitness/screens/goal/goal_screen.dart';
import 'package:fitness/screens/home/home_screen.dart';
import 'package:fitness/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    ActivitiesScreen(),
    GoalsScreen(),
    ProfileScreen(),
  ];

  final Gradient secondaryGradient = LinearGradient(
    colors: [TextColor.secondaryColor2, TextColor.secondaryColor1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColor.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            backgroundColor: TextColor.white,
            icon: Icon(Icons.home),
            label: 'Home',
            activeIcon: GradientIconWithText(
              icon: Icons.home,
              label: 'Home',
              gradient: secondaryGradient,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: TextColor.white,
            icon: Icon(Icons.directions_run),
            label: 'Activity',
            activeIcon: GradientIconWithText(
              icon: Icons.directions_run,
              label: 'Activity',
              gradient: secondaryGradient,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: TextColor.white,
            icon: Icon(Icons.flag),
            label: 'Goals',
            activeIcon: GradientIconWithText(
              icon: Icons.flag,
              label: 'Goals',
              gradient: secondaryGradient,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: TextColor.white,
            icon: Icon(Icons.person),
            label: 'Profile',
            activeIcon: GradientIconWithText(
              icon: Icons.person,
              label: 'Profile',
              gradient: secondaryGradient,
            ),
          ),
        ],
        unselectedItemColor: TextColor.gray,
        backgroundColor: TextColor.white,
      ),
    );
  }
}
