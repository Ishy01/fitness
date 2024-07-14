import 'package:fitness/common/color_extension.dart';
import 'package:fitness/screens/profile/profile_stat_card';
import 'package:flutter/material.dart';
import 'profile_header.dart';
import 'profile_section_header.dart';
import 'profile_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _popUpNotification = true;

  void _onListTileTap(String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title pressed')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColor.white,
      appBar: AppBar(
        backgroundColor: TextColor.white,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                onEdit: () {
                  // Handle edit button tap
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProfileStatCard(title: 'Height', value: '180cm'),
                  ProfileStatCard(title: 'Weight', value: '65kg'),
                  ProfileStatCard(title: 'Age', value: '22yo'),
                ],
              ),
              SizedBox(height: 20),
              ProfileSectionHeader(title: 'Account'),
              ProfileListTile(
                title: 'Personal Data',
                icon: Icons.person,
                onTap: () => _onListTileTap('Personal Data'),
              ),
              ProfileListTile(
                title: 'Achievement',
                icon: Icons.star,
                onTap: () => _onListTileTap('Achievement'),
              ),
              ProfileListTile(
                title: 'Activity History',
                icon: Icons.history,
                onTap: () => _onListTileTap('Activity History'),
              ),
              ProfileListTile(
                title: 'Workout Progress',
                icon: Icons.fitness_center,
                onTap: () => _onListTileTap('Workout Progress'),
              ),
              SizedBox(height: 20),
              ProfileSectionHeader(title: 'Notification'),
              SwitchListTile(
                title: Text('Pop-up Notification'),
                value: _popUpNotification,
                onChanged: (bool value) {
                  setState(() {
                    _popUpNotification = value;
                  });
                },
                secondary: Icon(Icons.notifications),
              ),
              SizedBox(height: 20),
              ProfileSectionHeader(title: 'Other'),
              ProfileListTile(
                title: 'Contact Us',
                icon: Icons.mail,
                onTap: () => _onListTileTap('Contact Us'),
              ),
              ProfileListTile(
                title: 'Privacy Policy',
                icon: Icons.privacy_tip,
                onTap: () => _onListTileTap('Privacy Policy'),
              ),
              ProfileListTile(
                title: 'Settings',
                icon: Icons.settings,
                onTap: () => _onListTileTap('Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
