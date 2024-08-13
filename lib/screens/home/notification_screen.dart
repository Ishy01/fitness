import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: message == null
          ? Center(child: Text('No notification details available.'))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text(message.notification?.title ?? 'No title'),
                  subtitle: Text(message.notification?.body ?? 'No body'),
                ),
              ],
            ),
    );
  }
}
