import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/name_capture_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/scanner/scanner_screen.dart';
import '../../features/generator/generator_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/batch_scan/batch_scan_screen.dart';
import '../../features/event_mode/create_event_screen.dart';
import '../../features/id_card/org_setup_screen.dart';
import '../../features/history/history_screen.dart';
import '../widgets/bottom_nav.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const NameCaptureScreen()),
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
          GoRoute(path: '/generate', builder: (_, __) => const GeneratorScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
      // Full-screen routes (no bottom nav)
      GoRoute(path: '/scan', builder: (_, __) => const ScannerScreen()),
      GoRoute(path: '/batch-scan', builder: (_, __) => const BatchScanScreen()),
      GoRoute(path: '/event-mode', builder: (_, __) => const CreateEventScreen()),
      GoRoute(path: '/id-cards', builder: (_, __) => const OrgSetupScreen()),
    ],
  );
});

/// Shell wrapper that shows the floating bottom nav.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: const CipherBottomNav(),
    );
  }
}
