import 'package:flutter/material.dart';
import '../theme/glass_decoration.dart';
import '../theme/app_spacing.dart';

/// Glassmorphic card matching the web prototype's GlassCard component.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = AppSpacing.radiusXl,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: radius,
      borderColor: borderColor,
      padding: padding ?? AppSpacing.cardPadding,
      onTap: onTap,
      child: child,
    );
  }
}
