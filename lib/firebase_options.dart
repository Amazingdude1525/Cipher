import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC34tBU_hgPY83bOyVPJrk4NK2mn8HRlvk',
    appId: '1:737835112810:android:0217d32b29deb4d8daed13',
    messagingSenderId: '737835112810',
    projectId: 'cipher-e2cd2',
    storageBucket: 'cipher-e2cd2.firebasestorage.app',
  );
}
