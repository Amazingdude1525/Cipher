import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/quotes.dart';
import '../../core/services/initialization_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  bool _initialized = false;
  late final AnimationController _orbCtrl;

  @override
  void initState() {
    super.initState();
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _initApp();
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    super.dispose();
  }

  Future<void> _initApp() async {
    final initFuture = ref.read(initializationProvider.future);
    await Future.delayed(3200.ms);
    try {
      await initFuture.timeout(const Duration(seconds: 3), onTimeout: () => null);
    } catch (e) {
      // Continue even if Firebase fails
    }
    if (!mounted) return;
    _navigate();
  }

  void _navigate() {
    if (_initialized) return;
    _initialized = true;
    final box = Hive.box(AppConstants.hiveSettingsBox);
    final onboarded =
        box.get(AppConstants.hiveKeyOnboarded, defaultValue: false) as bool;
    context.go(onboarded ? '/' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final randomQuote = cipherQuotes[Random().nextInt(cipherQuotes.length)];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── Ambient orb 1 (top-right, purple)
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) => Positioned(
              top: size.height * 0.12 + (_orbCtrl.value * 30),
              right: -60 + (_orbCtrl.value * 20),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.glitchPurple.withOpacity(0.12),
                      AppColors.glitchPurple.withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Ambient orb 2 (bottom-left, cyan)
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) => Positioned(
              bottom: size.height * 0.15 - (_orbCtrl.value * 25),
              left: -80 + (_orbCtrl.value * 15),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withOpacity(0.08),
                      AppColors.cyan.withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Ambient orb 3 (center-left, indigo)
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) => Positioned(
              top: size.height * 0.4 + (_orbCtrl.value * 15),
              left: size.width * 0.1,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.electricIndigo.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cipher logo mark — glassmorphic QR icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.glitchPurple.withOpacity(0.15),
                            AppColors.cyan.withOpacity(0.08),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.glitchPurple.withOpacity(0.2),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: AppColors.cyan.withOpacity(0.1),
                            blurRadius: 60,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Localized Scanning Laser
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 70,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.cyan,
                          boxShadow: [
                            BoxShadow(color: AppColors.cyan, blurRadius: 10, spreadRadius: 2),
                          ],
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveY(begin: 10, end: 78, duration: 1500.ms, curve: Curves.easeInOutSine),
                    ),
                  ]
                )
                    .animate()
                    .scale(
                      duration: 1000.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.0, 1.0),
                    )
                    .fadeIn(duration: 600.ms),

                const SizedBox(height: 40),

                // CIPHER wordmark
                Text(
                  'CIPHER',
                  style: GoogleFonts.syne(
                    fontSize: 38,
                    color: Colors.white,
                    letterSpacing: 12,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    )
                    .then()
                    .shimmer(
                      duration: 2500.ms,
                      color: AppColors.glitchPurple.withOpacity(0.6),
                    ),

                const SizedBox(height: 8),

                // Gradient line
                Container(
                  width: 100,
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.cyan.withOpacity(0.7),
                        AppColors.glitchPurple.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    .animate(delay: 800.ms)
                    .scaleX(duration: 1000.ms, curve: Curves.easeInOutExpo),

                const SizedBox(height: 20),

                // Tagline or Quote
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    '"$randomQuote"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 800.ms)
                      .slideY(begin: 0.2, end: 0),
                ),
                const SizedBox(height: 32),
                
                // Loading / Initializing UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 14, height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.glitchPurple),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'INITIALIZING SYSTEMS...',
                      style: GoogleFonts.syne(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ).animate().fadeIn(delay: 2000.ms, duration: 800.ms),
              ],
            ),
          ),

          // ── Version at bottom
          Positioned(
            bottom: 48,
            child: Text(
              'v${AppConstants.appVersion}',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: AppColors.textMuted.withOpacity(0.4),
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 1500.ms, duration: 600.ms),
          ),
        ],
      ),
    );
  }
}
