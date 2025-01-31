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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: '',
    appId: '1:1032934177749:web:a27f0202ca237bf86f1b5c',
    messagingSenderId: '1032934177749',
    projectId: 'fir-chatapp-10b8b',
    authDomain: 'fir-chatapp-10b8b.firebaseapp.com',
    storageBucket: 'fir-chatapp-10b8b.appspot.com',
    measurementId: 'G-CLFX42D9JF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '1:1032934177749:android:b62743eef7b9f5b86f1b5c',
    messagingSenderId: '1032934177749',
    projectId: 'fir-chatapp-10b8b',
    storageBucket: 'fir-chatapp-10b8b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '1:1032934177749:ios:02d2b7a75e7003b36f1b5c',
    messagingSenderId: '1032934177749',
    projectId: 'fir-chatapp-10b8b',
    storageBucket: 'fir-chatapp-10b8b.appspot.com',
    iosBundleId: 'com.example.chattapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtSjfj6olbQLK5_f7Gjszitz18mHj3rSo',
    appId: '1:1032934177749:ios:02d2b7a75e7003b36f1b5c',
    messagingSenderId: '1032934177749',
    projectId: 'fir-chatapp-10b8b',
    storageBucket: 'fir-chatapp-10b8b.appspot.com',
    iosBundleId: 'com.example.chattapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHwkUSmX24BCzepFI9P7pwnjKK3OtIbd8',
    appId: '1:1032934177749:web:29a5111ec7348f086f1b5c',
    messagingSenderId: '1032934177749',
    projectId: 'fir-chatapp-10b8b',
    authDomain: 'fir-chatapp-10b8b.firebaseapp.com',
    storageBucket: 'fir-chatapp-10b8b.appspot.com',
    measurementId: 'G-88S1CXY7LX',
  );
}
