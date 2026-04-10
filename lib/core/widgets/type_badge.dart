import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Colored pill badge for QR type indicators.
class TypeBadge extends StatelessWidget {
  const TypeBadge({super.key, required this.type, this.label});

  final String type;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.accentFor(type);
    final text = label ?? type.toUpperCase();
    final icon = _iconFor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(text, style: AppTypography.labelSm.copyWith(color: color)),
        ],
      ),
    );
  }

  IconData _iconFor(String t) => switch (t.toLowerCase()) {
    'url' => Icons.link_rounded,
    'upi' => Icons.currency_rupee_rounded,
    'wifi' => Icons.wifi_rounded,
    'event' => Icons.event_rounded,
    'contact' => Icons.person_rounded,
    _ => Icons.qr_code_2_rounded,
  };
}
