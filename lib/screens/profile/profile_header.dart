import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onEdit;

  const ProfileHeader({required this.onEdit});

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
            'Stefani Wong',
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
