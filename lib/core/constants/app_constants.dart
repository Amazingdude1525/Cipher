abstract final class AppConstants {
  static const appName = 'Cipher';
  static const appTagline = 'Encode the world.';
  static const appVersion = '1.0.0';
  static const creatorName = 'Prateek';
  static const creatorGithub = 'https://github.com/prateek';
  static const supportEmail = 'cipher.app.support@gmail.com';

  // Free tier limits
  static const maxFreeGenerations = 50;

  // Hive boxes
  static const hiveUserBox = 'cipher_user';
  static const hiveHistoryBox = 'cipher_history';
  static const hiveSettingsBox = 'cipher_settings';

  // Hive keys
  static const hiveKeyName = 'user_name';
  static const hiveKeyOnboarded = 'onboarded';
  static const hiveKeyUid = 'uid';

  // FAQs
  static const List<Map<String, String>> faqs = [
    {
      'q': 'Is Cipher free to use?',
      'a': 'Yes! Scanning, generating text/URL QR codes, and local history are completely free. Premium features like Event Mode and ID Cards have a generous free quota of $maxFreeGenerations uses.',
    },
    {
      'q': 'Do I need to create an account?',
      'a': 'No. You can scan and generate QR codes without logging in. An account is only needed for Event Mode, ID Cards, and cloud history sync.',
    },
    {
      'q': 'What data does Cipher collect?',
      'a': 'Cipher stores your scan history locally on your device. If you sign in, your data syncs to Firebase so you can access it across devices. We never sell your data.',
    },
    {
      'q': 'Can I export my scan history?',
      'a': 'Yes! Go to Profile → Export My History to download a PDF report of all your scans.',
    },
    {
      'q': 'How does Event Mode work?',
      'a': 'Create an event, add participants, send them QR passes via email/share, then use the entry scanner to check them in. Real-time attendance tracking included.',
    },
    {
      'q': 'What QR types does Cipher detect?',
      'a': 'Cipher auto-detects URLs, UPI payments, WiFi credentials, contacts (vCard), events, and plain text.',
    },
  ];
}
