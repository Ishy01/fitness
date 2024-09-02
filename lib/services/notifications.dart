import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitness/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class Notifications {
  Notifications() {
    tz.initializeTimeZones();
  }

  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notification',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    //await saveTokenToFirestore(fCMToken ?? '');
    initPushNotifications();
    initLocalNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    final data = message.data;

    if (data['type'] == 'recommendation') {
      // Handle recommendation notification by navigating to Activity Screen
      navigatorKey.currentState?.pushNamed('/activities');
      
      // Clear recommendation from Firestore
      if (data.containsKey('userId') && data.containsKey('recommendationId')) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(data['userId'])
            .collection('recommendations')
            .doc(data['recommendationId'])
            .delete();
      }
    } else {
      // Handle other notifications
      navigatorKey.currentState?.pushNamed('/notifications', arguments: message);
    }
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      if (payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(payload));
        handleMessage(message);
      }
    });

    final platform =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      handleMessage(message); // Add this line to handle the message in the foreground
    });
  }

  void scheduleDailyNotifications() async {
    final now = DateTime.now();

    // Schedule morning notification
    await _scheduleNotification(
      id: 1,
      title: "Good Morning!",
      body: "It's a great time for a morning walk!",
      scheduledTime: tz.TZDateTime.from(
          DateTime(now.year, now.month, now.day, 8, 0), tz.local), // 8:00 AM
    );

    // Schedule afternoon notification
    await _scheduleNotification(
      id: 2,
      title: "Keep Moving!",
      body: "How about a quick run this afternoon?",
      scheduledTime: tz.TZDateTime.from(
          DateTime(now.year, now.month, now.day, 12, 0), tz.local), // 12:00 PM
    );

    // Schedule evening notification
    await _scheduleNotification(
      id: 3,
      title: "Evening Reminder",
      body: "Don't forget to stay active this evening!",
      scheduledTime: tz.TZDateTime.from(
          DateTime(now.year, now.month, now.day, 18, 0), tz.local), // 6:00 PM
    );
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.high,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
