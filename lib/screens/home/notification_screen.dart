import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    final message =
        ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearAllNotifications,
          ),
        ],
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
                  onTap: () {
                    final data = message.data;
                    if (data['type'] == 'recommendation') {
                      // Navigate to Activity Screen
                      Navigator.pushNamed(context, '/activity_screen');

                      // Clear the specific recommendation from Firestore
                      if (data.containsKey('userId') &&
                          data.containsKey('recommendationId')) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(data['userId'])
                            .collection('recommendations')
                            .doc(data['recommendationId'])
                            .delete();
                      }
                    }
                  },
                ),
              ],
            ),
    );
  }

  void _clearAllNotifications() async {
    await localNotificationsPlugin.cancelAll();
    setState(() {}); // Rebuild the screen to reflect cleared notifications
  }
}
