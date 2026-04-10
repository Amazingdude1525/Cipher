import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'dart:convert';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: utf8.decode(base64.decode('QUl6YVN5QzM0dEJVX2hnUFk4M2JPeVZQSnJrNE5LMm1uOEhSbHZr')),
    appId: '1:737835112810:android:0217d32b29deb4d8daed13',
    messagingSenderId: '737835112810',
    projectId: 'cipher-e2cd2',
    storageBucket: 'cipher-e2cd2.firebasestorage.app',
  );
}
