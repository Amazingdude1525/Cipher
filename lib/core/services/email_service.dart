import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/foundation.dart';

class EmailService {
  /// Extract a readable name from an email address for a personalized UX.
  /// Example: prateekdas5255@gmail.com -> Prateek Das
  static String extractNameFromEmail(String email) {
    if (!email.contains('@')) return 'User';
    
    // Get the part before @
    String part = email.split('@').first;
    
    // Remove numbers and special characters
    part = part.replaceAll(RegExp(r'[0-9._-]'), ' ');
    
    // Capitalize words
    return part.trim().split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Sends a professional event pass or ID card to the specified email.
  static Future<bool> sendEmailWithAttachment({
    required String recipientEmail,
    required String subject,
    required String body,
    required File attachment,
    String? attachmentName,
  }) async {
    // NOTE: In a real production environment, these should be securely 
    // fetched from environment variables or a secure vault.
    // The user mentioned they will 'assign a admin mail'.
    const String username = 'admin@cipher.app'; // Placeholder
    const String password = 'password';          // Placeholder
    
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = const Address(username, 'Cipher Smart Platform')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body
      ..attachments.add(
        FileAttachment(attachment)
          ..location = Location.attachment
          ..fileName = attachmentName ?? 'Pass.pdf',
      );

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
      return true;
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}
