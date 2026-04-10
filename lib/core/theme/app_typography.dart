import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  // ── Display (Syne) ──
  static TextStyle displayXl = GoogleFonts.syne(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, color: AppColors.textPrimary,
  );
  static TextStyle displayLg = GoogleFonts.syne(
    fontSize: 26, fontWeight: FontWeight.w700, height: 1.3, color: AppColors.textPrimary,
  );
  static TextStyle displayMd = GoogleFonts.syne(
    fontSize: 22, fontWeight: FontWeight.w600, height: 1.3, color: AppColors.textPrimary,
  );
  static TextStyle displaySm = GoogleFonts.syne(
    fontSize: 18, fontWeight: FontWeight.w600, height: 1.4, color: AppColors.textPrimary,
  );

  // ── Body (DM Sans) ──
  static TextStyle bodyLg = GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.textPrimary,
  );
  static TextStyle bodyMd = GoogleFonts.dmSans(
    fontSize: 15, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textPrimary,
  );
  static TextStyle bodySm = GoogleFonts.dmSans(
    fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary,
  );

  // ── Label (DM Sans) ──
  static TextStyle labelLg = GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w600, height: 1.4, color: AppColors.textSecondary,
  );
  static TextStyle labelSm = GoogleFonts.dmSans(
    fontSize: 12, fontWeight: FontWeight.w500, height: 1.4, color: AppColors.textMuted,
  );

  // ── Mono (JetBrains Mono) ──
  static TextStyle monoMd = GoogleFonts.jetBrainsMono(
    fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textPrimary,
  );
}
