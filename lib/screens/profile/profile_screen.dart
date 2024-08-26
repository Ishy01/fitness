import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:fitness/screens/profile/other/contact_us.dart';
import 'package:fitness/screens/profile/other/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:fitness/services/database.dart';
import 'profile_pic/profile_header.dart';
import 'profile_section_header.dart';
import 'profile_list_tile.dart';
import 'profile_stat_card.dart';
import 'account/personal_data_screen.dart';
import 'account/achievements_screen.dart';
import 'account/activity_history_screen.dart';


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
  String? profilePictureUrl;
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
          profilePictureUrl = userData.profilePictureUrl ?? 'assets/default_profile_picture.png';
          isLoading = false;
        });
      }
    } else {
      // Handle the case when the user is null (logged out)
      setState(() {
        firstName = null;
        lastName = null;
        height = null;
        weight = null;
        dateOfBirth = null;
        profilePictureUrl = null;
        isLoading = false;
      });
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

  void _onListTileTap(String title) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    switch (title) {
      case 'Personal Data':
      final updatedUser = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PersonalDataScreen()),
      );
      // If updatedUser is not null, update the UI
      if (updatedUser != null) {
        setState(() {
          firstName = updatedUser.firstName;
          lastName = updatedUser.lastName;
          height = '${updatedUser.height}m';
          weight = '${updatedUser.weight}kg';
          dateOfBirth = updatedUser.dateOfBirth;

          // Calculate and update the age
          age = _calculateAge(dateOfBirth ?? 'Unknown').toString();
        });
      }
      break;
      case 'Achievements':
        Navigator.push(context, MaterialPageRoute(builder: (context) => AchievementsScreen()));
        break;
      case 'Activity History':
        Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityHistoryScreen()));
        break;
      case 'Contact Us':
      Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
      break;
    case 'Privacy Policy':
      Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
      break;
    }
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Align the column to the left
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ProfileHeader(
                        firstName: firstName ?? 'First Name',
                        lastName: lastName ?? 'Last Name',
                        profilePictureUrl: profilePictureUrl,
                      ),
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
                      title: 'Achievements',
                      icon: Icons.star,
                      onTap: () => _onListTileTap('Achievements'),
                    ),
                    ProfileListTile(
                      title: 'Activity History',
                      icon: Icons.history,
                      onTap: () => _onListTileTap('Activity History'),
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
                      title: 'Log Out',
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: _showLogoutDialog,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}