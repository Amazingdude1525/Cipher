import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/greeting_header.dart';
import '../../core/widgets/quote_card.dart';
import '../../core/widgets/type_badge.dart';
import '../../core/services/history_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(AppConstants.hiveSettingsBox);
    final name = box.get(AppConstants.hiveKeyName, defaultValue: 'there') as String;

    return Scaffold(
      backgroundColor: const Color(0xFF000000), // True AMOLED black
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: GreetingHeader(name: name)),
                    const SizedBox(width: 12),
                    _IconBtn(Icons.notifications_none_rounded, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('All caught up', style: AppTypography.labelSm.copyWith(color: Colors.white)),
                          backgroundColor: const Color(0xFF0A0A14),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    _IconBtn(Icons.menu_rounded, () => _showDrawer(context, name)),
                  ],
                ),
              ),

              // Quote Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const QuoteCard(),
              ),
              const SizedBox(height: 24),

              // Hero Action Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _HeroCard(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan QR',
                        gradient: AppColors.gradientScan,
                        glow: AppColors.glowCyan,
                        onTap: () => context.go('/scan'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _HeroCard(
                        icon: Icons.flash_on_rounded,
                        label: 'Generate',
                        gradient: AppColors.gradientGenerate,
                        glow: AppColors.glowViolet,
                        onTap: () => context.go('/generate'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Modes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('MODES', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, letterSpacing: 2)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _ModePill(Icons.event_rounded, 'Event', AppColors.glitchPurple, () => context.push('/event-mode')),
                    const SizedBox(width: 10),
                    _ModePill(Icons.badge_rounded, 'ID Card', AppColors.neonMint, () => context.push('/id-cards')),
                    const SizedBox(width: 10),
                    _ModePill(Icons.layers_rounded, 'Batch', AppColors.electricIndigo, () => context.push('/batch-scan')),
                    const SizedBox(width: 10),
                    _ModePill(Icons.history_rounded, 'History', AppColors.textSecondary, () => context.go('/history')),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Recent Scans
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent', style: AppTypography.labelLg),
                    GestureDetector(
                      onTap: () => context.go('/history'),
                      child: Text('See all', style: AppTypography.bodySm.copyWith(color: AppColors.cyan)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Builder(
                  builder: (context) {
                    final recentItems = HistoryService.getAll().take(5).toList();
                    if (recentItems.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A14),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF1A1A2E)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.qr_code_2_rounded, size: 40, color: Colors.white.withOpacity(0.08)),
                            const SizedBox(height: 12),
                            Text('No scans yet', style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted)),
                            const SizedBox(height: 4),
                            Text(
                              'Start by scanning your first QR code',
                              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: recentItems.map((item) {
                        final data = item['data'] as String? ?? '';
                        final type = item['type'] as String? ?? 'Text';
                        final ts = item['timestamp'] as String?;
                        String timeLabel = '';
                        if (ts != null) {
                          try {
                            final dt = DateTime.parse(ts);
                            final diff = DateTime.now().difference(dt);
                            if (diff.inMinutes < 1) timeLabel = 'Just now';
                            else if (diff.inMinutes < 60) timeLabel = '${diff.inMinutes}m ago';
                            else if (diff.inHours < 24) timeLabel = '${diff.inHours}h ago';
                            else timeLabel = '${dt.day}/${dt.month}';
                          } catch (_) {}
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GlassCard(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: data));
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Copied'),
                                  backgroundColor: AppColors.bgElevated,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.accentFor(type),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data, style: AppTypography.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                                      if (timeLabel.isNotEmpty)
                                        Text(timeLabel, style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 10)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TypeBadge(type: type),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDrawer(BuildContext context, String name) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Drawer',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => _SideDrawer(name: name),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(-1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }
}

// ── Private Widgets ──

class _IconBtn extends StatelessWidget {
  const _IconBtn(this.icon, this.onTap);
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0A0A14),
          border: Border.all(color: const Color(0xFF1A1A2E), width: 1.5),
        ),
        child: Icon(icon, size: 22, color: AppColors.textSecondary),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.icon, required this.label, required this.gradient, required this.glow, required this.onTap});
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final List<BoxShadow> glow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: glow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 26, color: Colors.white),
            Text(label, style: AppTypography.displaySm.copyWith(color: Colors.white, fontSize: 17, letterSpacing: -0.5)),
          ],
        ),
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill(this.icon, this.label, this.color, this.onTap);
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SideDrawer extends StatelessWidget {
  const _SideDrawer({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: const Color(0xFF050508),
        child: Container(
          width: 280,
          height: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: Color(0xFF1A1A2E))),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Avatar - Clickable
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/profile');
                  },
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.gradientScan,
                      boxShadow: [
                        BoxShadow(color: AppColors.glitchPurple.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: AppTypography.displaySm.copyWith(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(name, style: AppTypography.displaySm.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                  ),
                  child: Text('Free', style: AppTypography.labelSm.copyWith(color: AppColors.cyan, fontSize: 10)),
                ),
                const SizedBox(height: 28),
                _DrawerItem(Icons.qr_code_scanner_rounded, 'Scan QR', () { Navigator.pop(context); context.go('/scan'); }),
                _DrawerItem(Icons.flash_on_rounded, 'Generate QR', () { Navigator.pop(context); context.go('/generate'); }),
                _DrawerItem(Icons.event_rounded, 'Event Mode', () { Navigator.pop(context); context.push('/event-mode'); }),
                _DrawerItem(Icons.badge_rounded, 'ID Cards', () { Navigator.pop(context); context.push('/id-cards'); }),
                const SizedBox(height: 20),
                Divider(height: 1, color: const Color(0xFF1A1A2E)),
                const SizedBox(height: 20),
                
                // Developer — Single Tappable Option
                _DrawerItem(Icons.terminal_rounded, 'Developer', () => _showDeveloperSheet(context)),
                
                const Spacer(),
                Divider(height: 1, color: const Color(0xFF1A1A2E)),
                const SizedBox(height: 12),
                Text('Cipher v${AppConstants.appVersion}', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeveloperSheet(BuildContext context) {
    Navigator.pop(context); // Close drawer first
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0A14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.gradientScan,
              ),
              child: Center(child: Text('P', style: AppTypography.displayMd.copyWith(color: Colors.white, fontSize: 22))),
            ),
            const SizedBox(height: 12),
            Text('Prateek Das', style: AppTypography.displaySm.copyWith(fontSize: 18)),
            const SizedBox(height: 4),
            Text('Lead Developer', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DevLink(Icons.code_rounded, 'GitHub', () => _openUrl('https://github.com/Amazingdude1525')),
                const SizedBox(width: 16),
                _DevLink(Icons.link_rounded, 'LinkedIn', () => _openUrl('https://www.linkedin.com/in/prateek-das-a45215252/')),
                const SizedBox(width: 16),
                _DevLink(Icons.alternate_email_rounded, 'Email', () => _openUrl('mailto:prateekdas5255@gmail.com')),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _DevLink extends StatelessWidget {
  const _DevLink(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1A1A2E)),
            ),
            child: Icon(icon, size: 20, color: AppColors.cyan),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 14),
            Text(label, style: AppTypography.bodyMd.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
