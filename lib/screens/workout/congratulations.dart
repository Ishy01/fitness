import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class CongratulationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text('You have completed the workout.',),
            SizedBox(height: 15),
            RoundedButton(
              title: 'Go Back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
