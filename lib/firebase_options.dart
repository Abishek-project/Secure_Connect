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
    apiKey: 'AIzaSyAYE3BrjpoYzBt4RI3s5L7C7cn0cdahfiw',
    appId: '1:25467082629:web:a56ac1b8c34a38ec59d6ec',
    messagingSenderId: '25467082629',
    projectId: 'connect-b44bb',
    authDomain: 'connect-b44bb.firebaseapp.com',
    storageBucket: 'connect-b44bb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaj3jzO7SJPpmQR1tLZSoZBlqszTXY260',
    appId: '1:25467082629:android:a07998a43335970b59d6ec',
    messagingSenderId: '25467082629',
    projectId: 'connect-b44bb',
    storageBucket: 'connect-b44bb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOaz9O4_hkehs0EgthIanNQ5UgUstMc5c',
    appId: '1:25467082629:ios:7403659d9a99756d59d6ec',
    messagingSenderId: '25467082629',
    projectId: 'connect-b44bb',
    storageBucket: 'connect-b44bb.appspot.com',
    iosBundleId: 'com.example.secureConnect',
  );
}
