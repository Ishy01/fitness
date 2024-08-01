import 'package:flutter/material.dart';

class PersonalDataScreen extends StatelessWidget {
  // Assume user data is passed as arguments or obtained from a provider
  final String firstName = 'John';
  final String lastName = 'Doe';
  final String height = '1.75m';
  final String weight = '70kg';
  final String dateOfBirth = '1990-01-01';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: $firstName'),
            Text('Last Name: $lastName'),
            Text('Height: $height'),
            Text('Weight: $weight'),
            Text('Date of Birth: $dateOfBirth'),
          ],
        ),
      ),
    );
  }
}
