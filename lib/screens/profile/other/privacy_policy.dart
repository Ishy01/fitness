import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This privacy policy explains how our fitness app collects, uses, and '
                'protects your personal information.\n\n'
                '1. **Data Collection:** We collect personal information such as name, email, '
                'height, weight, and activity data to provide personalized recommendations.\n\n'
                '2. **Data Usage:** We use your data to track your progress, provide '
                'fitness insights, and improve our services. We may share anonymized data for research purposes.\n\n'
                '3. **Data Protection:** We use industry-standard security measures to '
                'protect your data from unauthorized access. However, no method of transmission '
                'over the Internet is 100% secure.\n\n'
                '4. **Third-Party Services:** Our app may integrate with third-party services, '
                'such as Google Fit and Firebase, which have their own privacy policies.\n\n'
                '5. **Your Rights:** You have the right to access, modify, or delete your personal '
                'information at any time. You may contact us at support@fitnessapp.com to exercise your rights.\n\n'
                'By using our app, you agree to this privacy policy. We may update this policy from '
                'time to time, and we will notify you of any changes.'
              ),
            ],
          ),
        ),
      ),
    );
  }
}
