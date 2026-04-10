import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Backgrounds ──
  static const bgDeep = Color(0xFF080810);
  static const bgCard = Color(0xFF0F0F1A);
  static const bgElevated = Color(0xFF16162A);

  // ── Glass ──
  static const glassFill = Color(0x0DFFFFFF);
  static const glassBorder = Color(0x1AFFFFFF);
  static const glassStrong = Color(0x1FFFFFFF);

  // ── Accents (USP Palette) ──
  static const cyan = Color(0xFF00F5FF);
  static const electricIndigo = Color(0xFF6366F1); // More unique than standard violet
  static const glitchPurple = Color(0xFFD437FF);   // Vibrant USP Purple
  static const neonMint = Color(0xFF2DD4BF);       // Fresh accent
  static const lavaOrange = Color(0xFFFF4D00);     // Aggressive Orange
  
  static const violet = Color(0xFF7B61FF);
  static const amber = Color(0xFFFFD166);
  static const green = Color(0xFF00E5A0);
  static const red = Color(0xFFFF5C6A);

  // ── Text ──
  static const textPrimary = Color(0xFFF0F0F8);
  static const textSecondary = Color(0xFFAAAACC);
  static const textMuted = Color(0xFF555577);
  static const uspPurple = Color(0xFFD437FF); // Specifically for requested italic name

  // ── Gradients (Creative USP) ──
  static const gradientScan = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFD437FF)], // Electric Indigo -> Glitch Purple
  );

  static const gradientGenerate = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF4D00), Color(0xFFD437FF)], // Lava Orange -> Glitch Purple
  );

  static const gradientEvent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2DD4BF), Color(0xFF6366F1)], // Neon Mint -> Electric Indigo
  );

  static const gradientId = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD437FF), Color(0xFF6366F1)],
  );

  // ── Shadows ──
  static const shadowCard = [
    BoxShadow(color: Color(0x66000000), blurRadius: 32, offset: Offset(0, 8)),
  ];

  static List<BoxShadow> glowCyan = [
    BoxShadow(color: cyan.withOpacity(0.25), blurRadius: 20),
  ];

  static List<BoxShadow> glowViolet = [
    BoxShadow(color: violet.withOpacity(0.25), blurRadius: 20),
  ];

  static List<BoxShadow> glowAmber = [
    BoxShadow(color: amber.withOpacity(0.25), blurRadius: 20),
  ];

  static List<BoxShadow> glowGreen = [
    BoxShadow(color: green.withOpacity(0.25), blurRadius: 20),
  ];

  /// Returns accent colour for the given QR type name.
  static Color accentFor(String type) => switch (type.toLowerCase()) {
    'url' => cyan,
    'upi' => amber,
    'wifi' => green,
    'event' || 'contact' => violet,
    _ => textMuted,
  };
}
