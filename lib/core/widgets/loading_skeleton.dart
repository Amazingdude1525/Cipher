import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shimmer loading skeleton for placeholder states.
class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({super.key, this.width, this.height = 16, this.radius = AppSpacing.radiusMd});

  final double? width;
  final double height;
  final double radius;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(-1 + 2 * _ctrl.value, 0),
            end: Alignment(1 + 2 * _ctrl.value, 0),
            colors: const [
              AppColors.bgCard,
              AppColors.bgElevated,
              AppColors.bgCard,
            ],
          ),
        ),
      ),
    );
  }
}

/// Full card-sized loading skeleton.
class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingSkeleton(width: 120, height: 14),
          SizedBox(height: 12),
          LoadingSkeleton(height: 12),
          SizedBox(height: 8),
          LoadingSkeleton(width: 200, height: 12),
        ],
      ),
    );
  }
}
