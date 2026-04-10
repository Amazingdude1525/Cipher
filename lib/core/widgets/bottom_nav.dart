import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

/// Premium iOS-style glassmorphic floating dock navigation.
class CipherBottomNav extends StatelessWidget {
  const CipherBottomNav({super.key});

  static const _tabs = [
    _Tab(Icons.home_filled, 'Home', '/'),
    _Tab(Icons.history_rounded, 'History', '/history'),
    _Tab(Icons.qr_code_rounded, 'Generate', '/generate'),
    _Tab(Icons.person_rounded, 'Profile', '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                // iOS-style frosted glass
                color: const Color(0xFF0A0A14).withOpacity(0.65),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: -5,
                    offset: const Offset(0, 8),
                  ),
                  // Subtle inner glow from active tab
                  BoxShadow(
                    color: AppColors.cyan.withOpacity(0.03),
                    blurRadius: 20,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Top edge highlight (subtle glass refraction)
                  Positioned(
                    top: 0,
                    left: 24,
                    right: 24,
                    child: Container(
                      height: 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tab items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _tabs.map((tab) {
                      final active = location == tab.path ||
                          (tab.path != '/' && location.startsWith(tab.path));
                      return Expanded(
                        child: _NavItem(tab: tab, active: active),
                      );
                    }).toList(),
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

class _Tab {
  const _Tab(this.icon, this.label, this.path);
  final IconData icon;
  final String label;
  final String path;
}

class _NavItem extends StatefulWidget {
  const _NavItem({required this.tab, required this.active});
  final _Tab tab;
  final bool active;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        HapticFeedback.selectionClick();
        context.go(widget.tab.path);
      },
      onTapCancel: () => _ctrl.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: widget.active
                ? AppColors.cyan.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with glow when active
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.active)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyan.withOpacity(0.35),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    Icon(
                      widget.tab.icon,
                      size: widget.active ? 26 : 24,
                      color: widget.active
                          ? AppColors.cyan
                          : AppColors.textSecondary.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                widget.tab.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
                  color: widget.active
                      ? AppColors.cyan
                      : AppColors.textSecondary.withOpacity(0.5),
                  letterSpacing: widget.active ? 0.5 : 0,
                ),
              ),
              // Active indicator dot
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.active ? 4 : 0,
                height: widget.active ? 4 : 0,
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  shape: BoxShape.circle,
                  boxShadow: widget.active
                      ? [
                          BoxShadow(
                            color: AppColors.cyan.withOpacity(0.6),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
