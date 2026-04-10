import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Returns a glassmorphic [BoxDecoration].
BoxDecoration glassDecoration({
  Color? borderColor,
  double radius = AppSpacing.radiusXl,
  List<BoxShadow>? shadows,
}) {
  return BoxDecoration(
    color: AppColors.glassFill,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: borderColor ?? AppColors.glassBorder),
    boxShadow: shadows ?? AppColors.shadowCard,
  );
}

/// A glass container widget with backdrop blur.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderColor,
    this.radius = AppSpacing.radiusXl,
    this.shadows,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final Color? borderColor;
  final double radius;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: glassDecoration(
            borderColor: borderColor,
            radius: radius,
            shadows: shadows,
          ),
          padding: padding ?? AppSpacing.cardPadding,
          child: child,
        ),
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
