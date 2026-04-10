import 'package:cipher/features/auth/login_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate {
  const AuthGate._();

  static bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  static Future<void> requireLogin(BuildContext context, VoidCallback onAuthorized) async {
    if (isLoggedIn) {
      onAuthorized();
      return;
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LoginBottomSheet(),
    );
  }
}
