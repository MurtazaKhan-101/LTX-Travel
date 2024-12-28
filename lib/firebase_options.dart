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
    apiKey: 'AIzaSyC44D45bLqyacuu6zFAjjyhvrnndS-4Xqc',
    appId: '1:255418086875:web:17f432e10216eb54ca63fe',
    messagingSenderId: '255418086875',
    projectId: 'travel-app-dac32',
    authDomain: 'travel-app-dac32.firebaseapp.com',
    storageBucket: 'travel-app-dac32.firebasestorage.app',
    measurementId: 'G-T1RPN9X21C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkxEIwbt1kg-EdfOFbECQatANnblm3u7g',
    appId: '1:255418086875:android:9ccd58ca1a39d8d4ca63fe',
    messagingSenderId: '255418086875',
    projectId: 'travel-app-dac32',
    storageBucket: 'travel-app-dac32.firebasestorage.app',
  );
}