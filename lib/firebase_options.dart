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
    apiKey: 'AIzaSyDZhHoKlVXPiNbtIC8FBMjTt4bn5-Wx-rM',
    appId: '1:478466825426:web:28ea33422ec4e25ffa210b',
    messagingSenderId: '478466825426',
    projectId: 'todo-72b62',
    authDomain: 'todo-72b62.firebaseapp.com',
    storageBucket: 'todo-72b62.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYIPOdN2oEcSv9eMjC3QxFYtBJb8ZCW4o',
    appId: '1:478466825426:android:52a46b2c74465b89fa210b',
    messagingSenderId: '478466825426',
    projectId: 'todo-72b62',
    storageBucket: 'todo-72b62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBF6gre_251VJsxYdbgUbeBE0yAxoTcdvU',
    appId: '1:478466825426:ios:88bfced593ace520fa210b',
    messagingSenderId: '478466825426',
    projectId: 'todo-72b62',
    storageBucket: 'todo-72b62.appspot.com',
    iosClientId: '478466825426-utu6bo51susu99fiotphvrr7bjk3v0hj.apps.googleusercontent.com',
    iosBundleId: 'com.nitesh.todo',
  );
}
