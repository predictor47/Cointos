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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBt59j79rP222NOe9Qph4JjFnfrtUY1Rrk',
    appId: '1:513615609284:web:3b69c1538310d03984b891',
    messagingSenderId: '513615609284',
    projectId: 'coinverse-f947a',
    authDomain: 'coinverse-f947a.firebaseapp.com',
    storageBucket: 'coinverse-f947a.appspot.com',
    measurementId: 'G-BNZ2V9T676',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUH_hAL469gIuvrgKSy8gR-vYDekIH3Yc',
    appId: '1:513615609284:android:4cf45a2f86af7ff684b891',
    messagingSenderId: '513615609284',
    projectId: 'coinverse-f947a',
    storageBucket: 'coinverse-f947a.appspot.com',
  );
}
