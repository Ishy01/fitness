import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('If you have any questions or concerns, feel free to reach out to us:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Email: support@fitnessapp.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone: +23312456789', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Address: Kwame Nkrumah University of Science and Technology, Computer Science Department', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('We are here to help you!', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
