import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum CipherButtonVariant { primary, secondary, danger }

/// Gradient or outlined button matching the web prototype's CipherButton.
class CipherButton extends StatelessWidget {
  const CipherButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CipherButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final CipherButtonVariant variant;
  final IconData? icon;
  final bool fullWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 16, height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          if (label.isNotEmpty) const SizedBox(width: AppSpacing.md),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.white),
          if (label.isNotEmpty) const SizedBox(width: AppSpacing.md),
        ],
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTypography.labelLg.copyWith(
              color: variant == CipherButtonVariant.secondary
                  ? AppColors.cyan
                  : Colors.white,
            ),
          ),
      ],
    );

    if (variant == CipherButtonVariant.secondary) {
      return AnimatedOpacity(
        opacity: disabled ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.glassBorder),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: fullWidth ? const Size(double.infinity, 48) : null,
          ),
          child: child,
        ),
      );
    }

    return AnimatedOpacity(
      opacity: disabled ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: variant == CipherButtonVariant.danger
              ? const LinearGradient(colors: [AppColors.red, Color(0xFFCC3344)])
              : AppColors.gradientScan,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: AppColors.glowCyan,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled ? null : onPressed,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
