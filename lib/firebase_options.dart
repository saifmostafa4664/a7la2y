import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAuS5yfLrDkPapgwXF06Y__wKHW8arYbTQ',
    appId: '1:360631440530:web:0d285b18201ecafcddc24b',
    messagingSenderId: '360631440530',
    projectId: 'a7la2y-app',
    authDomain: 'a7la2y-app.firebaseapp.com',
    storageBucket: 'a7la2y-app.firebasestorage.app',
    measurementId: 'G-KLYYJB99BX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2Fj8AQw4x_h293Yxjc6L-nLK5ALVL4c0',
    appId: '1:360631440530:android:2953bfba61d17239ddc24b',
    messagingSenderId: '360631440530',
    projectId: 'a7la2y-app',
    storageBucket: 'a7la2y-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTZ-hngDP_FIrZo6kNyaZlQtlD0xJyuTU',
    appId: '1:360631440530:ios:33400cc93cd37bd1ddc24b',
    messagingSenderId: '360631440530',
    projectId: 'a7la2y-app',
    storageBucket: 'a7la2y-app.firebasestorage.app',
    androidClientId:
        '360631440530-duq3a0206785m8rle31ts4jajdrsa3jn.apps.googleusercontent.com',
    iosClientId:
        '360631440530-scmusv52d70s75deookh6qjbppbh5qdl.apps.googleusercontent.com',
    iosBundleId: 'com.saifmo.a7la2y',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTZ-hngDP_FIrZo6kNyaZlQtlD0xJyuTU',
    appId: '1:360631440530:ios:33400cc93cd37bd1ddc24b',
    messagingSenderId: '360631440530',
    projectId: 'a7la2y-app',
    storageBucket: 'a7la2y-app.firebasestorage.app',
    androidClientId:
        '360631440530-duq3a0206785m8rle31ts4jajdrsa3jn.apps.googleusercontent.com',
    iosClientId:
        '360631440530-scmusv52d70s75deookh6qjbppbh5qdl.apps.googleusercontent.com',
    iosBundleId: 'com.saifmo.a7la2y',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAuS5yfLrDkPapgwXF06Y__wKHW8arYbTQ',
    appId: '1:360631440530:web:d2534438f71f7974ddc24b',
    messagingSenderId: '360631440530',
    projectId: 'a7la2y-app',
    authDomain: 'a7la2y-app.firebaseapp.com',
    storageBucket: 'a7la2y-app.firebasestorage.app',
    measurementId: 'G-RRQ4JH375B',
  );
}
