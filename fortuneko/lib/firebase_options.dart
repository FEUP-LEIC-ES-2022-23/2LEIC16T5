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
    apiKey: 'AIzaSyAwt2hU8anwBaftd_cD_fun9JDG0J9LOqI',
    appId: '1:236988136407:web:c969c11eedc70659b82992',
    messagingSenderId: '236988136407',
    projectId: 'fortuneko-65ee1',
    authDomain: 'fortuneko-65ee1.firebaseapp.com',
    storageBucket: 'fortuneko-65ee1.appspot.com',
    measurementId: 'G-F69EPLPPLV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwfwnUTU033TVy8GJIKg9PXoTlR0avi_8',
    appId: '1:236988136407:android:4b8b49dbbebe60c1b82992',
    messagingSenderId: '236988136407',
    projectId: 'fortuneko-65ee1',
    storageBucket: 'fortuneko-65ee1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApkjvAQ_EQkIL1xc19SQiOwI340ijtULQ',
    appId: '1:236988136407:ios:8354d3f9fb89bfcdb82992',
    messagingSenderId: '236988136407',
    projectId: 'fortuneko-65ee1',
    storageBucket: 'fortuneko-65ee1.appspot.com',
    iosClientId: '236988136407-omcled2k8ipdhh2kt3if5qvvj43m78oa.apps.googleusercontent.com',
    iosBundleId: 'com.example.fortuneko',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyApkjvAQ_EQkIL1xc19SQiOwI340ijtULQ',
    appId: '1:236988136407:ios:8354d3f9fb89bfcdb82992',
    messagingSenderId: '236988136407',
    projectId: 'fortuneko-65ee1',
    storageBucket: 'fortuneko-65ee1.appspot.com',
    iosClientId: '236988136407-omcled2k8ipdhh2kt3if5qvvj43m78oa.apps.googleusercontent.com',
    iosBundleId: 'com.example.fortuneko',
  );
}
