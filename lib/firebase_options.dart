// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDxoGxziyu0iDQJNMk1HBjVsU8Jm0cr_dc',
    appId: '1:16041174039:web:ea589f43dd1493962a6852',
    messagingSenderId: '16041174039',
    projectId: 'fitness-backend-c4d78',
    authDomain: 'fitness-backend-c4d78.firebaseapp.com',
    storageBucket: 'fitness-backend-c4d78.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBH7zTUISHpgZPy2ZjpcsxZySDYkyLJkx0',
    appId: '1:16041174039:android:85dfc24ca589244e2a6852',
    messagingSenderId: '16041174039',
    projectId: 'fitness-backend-c4d78',
    storageBucket: 'fitness-backend-c4d78.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqGk-4YaHimxuAiXS-7qBIofPHfQE7_Fk',
    appId: '1:16041174039:ios:0c67878b226bed1a2a6852',
    messagingSenderId: '16041174039',
    projectId: 'fitness-backend-c4d78',
    storageBucket: 'fitness-backend-c4d78.appspot.com',
    iosBundleId: 'com.example.fitness',
  );
}
