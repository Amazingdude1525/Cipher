import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Progress bar for usage metering (e.g. QR generations used).
class UsageMeter extends StatelessWidget {
  const UsageMeter({
    super.key,
    required this.label,
    required this.current,
    required this.max,
    this.accentColor = AppColors.cyan,
  });

  final String label;
  final int current;
  final int max;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final pct = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySm),
            Text(
              '$current / $max',
              style: AppTypography.displaySm.copyWith(color: accentColor, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.glassFill,
              valueColor: AlwaysStoppedAnimation(accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
