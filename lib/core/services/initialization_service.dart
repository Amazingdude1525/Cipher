import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

final initializationProvider = FutureProvider<void>((ref) async {
  try {
    // 5 second timeout to prevent hanging the splash screen
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    if (kDebugMode) {
      print('Firebase initialization timed out or failed: $e');
    }
  }
  // Hive is already initialized in main.dart
});
