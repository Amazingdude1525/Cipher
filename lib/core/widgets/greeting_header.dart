import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Clean, high-contrast greeting header — AMOLED optimized.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key, required this.name});

  final String name;

  static const List<String> _statements = [
    'Ready to encode',
    'Scan with precision',
    'Time to generate',
    'Secure & smart',
    'Your QR lab awaits',
    'Go digital',
    'Stay sharp',
    'Decode everything',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final index = (now.day + now.hour) % _statements.length;
    final greeting = _statements[index];

    final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][now.weekday - 1];
    final month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.month - 1];
    final dateStr = '$weekday, $month ${now.day}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: AppTypography.displayMd.copyWith(
            fontSize: 28,
            height: 1.15,
            letterSpacing: -0.8,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          name,
          style: AppTypography.displayMd.copyWith(
            fontSize: 36,
            height: 1.1,
            letterSpacing: -1.5,
            color: AppColors.uspPurple,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          dateStr.toUpperCase(),
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
