import 'package:flutter/material.dart';

abstract final class AppSpacing {
  // ── 8pt Grid ──
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double xxxl = 24;
  static const double huge = 32;
  static const double massive = 40;
  static const double colossal = 48;

  // ── Border Radius ──
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radius2xl = 24;
  static const double radiusFull = 9999;

  // ── Common EdgeInsets ──
  static const screenH = EdgeInsets.symmetric(horizontal: 24);
  static const cardPadding = EdgeInsets.all(16);
  static const cardPaddingLg = EdgeInsets.all(24);
}
