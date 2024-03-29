// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAEubBTUVWInoe0FVoUUXCyMr9hLDD-n8g',
    appId: '1:749157065262:web:da9636c852ea3fc57775bf',
    messagingSenderId: '749157065262',
    projectId: 'fir-cdba5',
    authDomain: 'fir-cdba5.firebaseapp.com',
    storageBucket: 'fir-cdba5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcrairSv8Odb-Rxr6MEFn359FUg4qY9NU',
    appId: '1:749157065262:android:9ecc6ae851a367187775bf',
    messagingSenderId: '749157065262',
    projectId: 'fir-cdba5',
    storageBucket: 'fir-cdba5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9VyQqmvaHswppEqFyX6oRw_jpUk1aov4',
    appId: '1:749157065262:ios:53aad75d880d341a7775bf',
    messagingSenderId: '749157065262',
    projectId: 'fir-cdba5',
    storageBucket: 'fir-cdba5.appspot.com',
    iosClientId: '749157065262-6nhbqfpcb0drcat4j6te5r0i7n4jc93u.apps.googleusercontent.com',
    iosBundleId: 'com.example.thebookstoreapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9VyQqmvaHswppEqFyX6oRw_jpUk1aov4',
    appId: '1:749157065262:ios:ef2f1825299944347775bf',
    messagingSenderId: '749157065262',
    projectId: 'fir-cdba5',
    storageBucket: 'fir-cdba5.appspot.com',
    iosClientId: '749157065262-m1i0ojgnh6ja52bsbk764klem90k111v.apps.googleusercontent.com',
    iosBundleId: 'com.example.thebookstoreapp.RunnerTests',
  );
}
