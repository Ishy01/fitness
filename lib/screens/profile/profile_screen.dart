import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:fitness/screens/profile/profile_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:fitness/services/database.dart';
import 'profile_header.dart';
import 'profile_section_header.dart';
import 'profile_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _popUpNotification = true;
  String? firstName;
  String? lastName;
  String? height;
  String? weight;
  String? age;
  String? dateOfBirth;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseService dbService = DatabaseService(userId: user.uid);
      var userData = await dbService.getUser(user.uid);
      if (userData != null) {
        setState(() {
          firstName = userData.firstName ?? 'First Name';
          lastName = userData.lastName ?? 'Last Name';
          height = userData.height != null ? '${userData.height}m' : 'Unknown';
          weight = userData.weight != null ? '${userData.weight}kg' : 'Unknown';
          dateOfBirth = userData.dateOfBirth ?? 'Unknown';
          isLoading = false;
        });
      }
    }
  }

  int _calculateAge(String dateOfBirth) {
    DateTime dob = DateTime.parse(dateOfBirth);
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  void _onListTileTap(String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title pressed')));
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Stay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColor.white,
      appBar: AppBar(
        backgroundColor: TextColor.white,
        title: Text('Profile'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(
                      firstName: firstName ?? 'First Name',
                      lastName: lastName ?? 'Last Name',
                      onEdit: () {
                        // Handle edit button tap
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileStatCard(title: 'Height', value: height ?? 'Unknown'),
                        ProfileStatCard(title: 'Weight', value: weight ?? 'Unknown'),
                        ProfileStatCard(
                          title: 'Age',
                          value: dateOfBirth != null && dateOfBirth != 'Unknown'
                              ? '${_calculateAge(dateOfBirth!)}yo'
                              : 'Unknown',
                        ),
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
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Set the button color to red
                        ),
                        onPressed: _showLogoutDialog,
                        child: Text('Log Out'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
