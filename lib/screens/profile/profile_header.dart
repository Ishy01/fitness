import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final VoidCallback onEdit;

  const ProfileHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_picture.png'), // Update the image path
          ),
          SizedBox(height: 10),
          Text(
            '$firstName $lastName',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Lose a Fat Program',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          ElevatedButton(
            onPressed: onEdit,
            child: Text('Edit'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ), backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
