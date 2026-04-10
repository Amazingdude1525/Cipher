import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Overlay toast notification.
void showCipherToast(BuildContext context, String message, {bool isError = false}) {
  final overlay = OverlayEntry(
    builder: (ctx) => _CipherToast(message: message, isError: isError),
  );
  Overlay.of(context).insert(overlay);
  Future.delayed(const Duration(seconds: 3), overlay.remove);
}

class _CipherToast extends StatefulWidget {
  const _CipherToast({required this.message, required this.isError});
  final String message;
  final bool isError;

  @override
  State<_CipherToast> createState() => _CipherToastState();
}

class _CipherToastState extends State<_CipherToast> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..forward();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 24,
      right: 24,
      child: FadeTransition(
        opacity: _ctrl,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: Offset.zero).animate(
            CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isError ? AppColors.red.withOpacity(0.15) : AppColors.bgElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isError ? AppColors.red.withOpacity(0.3) : AppColors.glassBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                    color: widget.isError ? AppColors.red : AppColors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.message, style: AppTypography.bodySm.copyWith(color: AppColors.textPrimary)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
