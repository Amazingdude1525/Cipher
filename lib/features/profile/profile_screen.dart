import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/usage_meter.dart';
import '../../core/widgets/cipher_button.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/history_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    final box = Hive.box(AppConstants.hiveSettingsBox);
    final localName = box.get(AppConstants.hiveKeyName, defaultValue: 'Guest') as String;
    final autoSave = box.get('auto_save', defaultValue: true) as bool;
    final haptic = box.get('haptic_feedback', defaultValue: true) as bool;
    final autoFlash = box.get('auto_flashlight', defaultValue: false) as bool;

    final name = user?.displayName ?? localName;
    final photoUrl = user?.photoURL;
    final email = user?.email;
    final historyCount = HistoryService.count;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Text('Settings', style: AppTypography.displayLg.copyWith(fontSize: 32)),
              ),

              // Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () => _showNameEditor(context),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glitchPurple.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(color: AppColors.glitchPurple.withOpacity(0.05), blurRadius: 20, spreadRadius: 2)
                      ]
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: photoUrl == null ? AppColors.gradientScan : null,
                            image: photoUrl != null
                                ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                                : null,
                            boxShadow: [
                              BoxShadow(color: AppColors.glitchPurple.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: photoUrl == null
                              ? Center(
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                                    style: AppTypography.displayMd.copyWith(color: Colors.white, fontSize: 24),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(child: Text(name, style: AppTypography.displaySm.copyWith(fontSize: 18))),
                                  const SizedBox(width: 8),
                                  Icon(Icons.edit_rounded, size: 14, color: AppColors.textMuted),
                                ],
                              ),
                              if (email != null) ...[
                                const SizedBox(height: 2),
                                Text(email, style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 12)),
                              ],
                              if (email == null) ...[
                                const SizedBox(height: 2),
                                Text('Tap to edit name', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 12)),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                          ),
                          child: Text(user != null ? 'Pro' : 'Free',
                              style: AppTypography.labelSm.copyWith(color: AppColors.cyan, fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sign In / Sign Out
              if (user == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.glitchPurple.withOpacity(0.3), blurRadius: 15, spreadRadius: -2)],
                    ),
                    child: CipherButton(
                      label: 'Sign in with Google',
                      icon: Icons.login_rounded,
                      fullWidth: true,
                      onPressed: () async {
                        try {
                          await ref.read(authServiceProvider).signInWithGoogle();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                          }
                        }
                      },
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CipherButton(
                    label: 'Sign Out',
                    icon: Icons.logout_rounded,
                    variant: CipherButtonVariant.secondary,
                    fullWidth: true,
                    onPressed: () => ref.read(authServiceProvider).signOut(),
                  ),
                ),

              const SizedBox(height: 28),

              // ── APPEARANCE ──
              _SectionTitle('APPEARANCE'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1A1A2E)),
                  ),
                  child: Row(
                    children: [
                      _ThemeOption('Light', false, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Light Mode Coming Soon!')));
                      }),
                      _ThemeOption('Dark', true, () {}),
                      _ThemeOption('Auto', false, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auto Mode Coming Soon!')));
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── PREFERENCES ──
              _SectionTitle('PREFERENCES'),
              _ToggleTile(
                icon: Icons.auto_awesome_rounded,
                iconColor: AppColors.cyan,
                label: 'Auto-save Scans',
                value: autoSave,
                onChanged: (v) {
                  box.put('auto_save', v);
                  (context as Element).markNeedsBuild();
                },
              ),
              const SizedBox(height: 8),
              _ToggleTile(
                icon: Icons.vibration_rounded,
                iconColor: AppColors.amber,
                label: 'Haptic Feedback',
                value: haptic,
                onChanged: (v) {
                  box.put('haptic_feedback', v);
                  (context as Element).markNeedsBuild();
                },
              ),
              const SizedBox(height: 8),
              _ToggleTile(
                icon: Icons.flashlight_on_rounded,
                iconColor: AppColors.lavaOrange,
                label: 'Automatic Flashlight',
                value: autoFlash,
                onChanged: (v) {
                  box.put('auto_flashlight', v);
                  (context as Element).markNeedsBuild();
                },
              ),
              const SizedBox(height: 20),

              // ── DATA MANAGEMENT ──
              _SectionTitle('DATA MANAGEMENT'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1A1A2E)),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.violet.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.history_rounded, size: 18, color: AppColors.violet),
                    ),
                    title: Text('Clear History', style: AppTypography.bodyMd.copyWith(fontSize: 14)),
                    subtitle: Text('$historyCount items stored', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    trailing: GestureDetector(
                      onTap: historyCount > 0
                          ? () {
                              HistoryService.clearAll();
                              (context as Element).markNeedsBuild();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('History cleared'),
                                  backgroundColor: AppColors.bgElevated,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            }
                          : null,
                      child: Icon(Icons.delete_outline_rounded, size: 20, color: historyCount > 0 ? AppColors.red : AppColors.textMuted),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── ABOUT ──
              _SectionTitle('ABOUT'),
              _SettingsGroup(items: [
                _SettingsItem(Icons.info_outline_rounded, 'Software Version', 'v${AppConstants.appVersion} Premium', null),
                _SettingsItem(Icons.star_outline_rounded, 'Rate Cipher', 'Leave a review', () {}),
                _SettingsItem(Icons.mail_outline_rounded, 'Support & Feedback', 'prateekdas5255@gmail.com', () {
                  launchUrl(Uri.parse('mailto:prateekdas5255@gmail.com?subject=Cipher Feedback'));
                }),
              ]),
              const SizedBox(height: 16),

              // Developer Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () => _showDeveloperSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.glitchPurple.withOpacity(0.08),
                          AppColors.electricIndigo.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glitchPurple.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientScan,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(child: Text('P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Developed by Prateek Das', style: AppTypography.bodyMd.copyWith(fontSize: 13)),
                              Text('GitHub · LinkedIn · Email', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showNameEditor(BuildContext context) {
    final box = Hive.box(AppConstants.hiveSettingsBox);
    final currentName = box.get(AppConstants.hiveKeyName, defaultValue: '') as String;
    final ctrl = TextEditingController(text: currentName);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0A14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Edit Name', style: AppTypography.displaySm),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              autofocus: true,
              style: AppTypography.bodyMd,
              decoration: const InputDecoration(hintText: 'Your name'),
              onSubmitted: (v) {
                if (v.trim().isNotEmpty) {
                  box.put(AppConstants.hiveKeyName, v.trim());
                  if (!box.get(AppConstants.hiveKeyOnboarded, defaultValue: false)) {
                    box.put(AppConstants.hiveKeyOnboarded, true);
                  }
                }
                Navigator.pop(ctx);
                (context as Element).markNeedsBuild();
              },
            ),
            const SizedBox(height: 16),
            CipherButton(
              label: 'Save',
              icon: Icons.check_rounded,
              fullWidth: true,
              onPressed: () {
                if (ctrl.text.trim().isNotEmpty) {
                  box.put(AppConstants.hiveKeyName, ctrl.text.trim());
                  if (!box.get(AppConstants.hiveKeyOnboarded, defaultValue: false)) {
                    box.put(AppConstants.hiveKeyOnboarded, true);
                  }
                }
                Navigator.pop(ctx);
                (context as Element).markNeedsBuild();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeveloperSheet(BuildContext context) {
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
              width: 56,
              height: 56,
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

// ── Reusable Widgets ──

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Text(title, style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, letterSpacing: 2, fontSize: 11)),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption(this.label, this.isSelected, this.onTap);
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.cyan : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.cyan.withOpacity(0.3), blurRadius: 12)] : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.bodyMd.copyWith(
                color: isSelected ? Colors.black : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({required this.icon, required this.iconColor, required this.label, required this.value, required this.onChanged});
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1A1A2E)),
          boxShadow: [
            if (value) BoxShadow(color: iconColor.withOpacity(0.05), blurRadius: 10, spreadRadius: -2)
          ]
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.bodyMd.copyWith(fontSize: 14))),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.cyan,
              activeTrackColor: AppColors.cyan.withOpacity(0.2),
              inactiveThumbColor: AppColors.textMuted,
              inactiveTrackColor: const Color(0xFF1A1A2E),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.items});
  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1A1A2E)),
        ),
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              items[i],
              if (i < items.length - 1) Divider(height: 1, color: const Color(0xFF1A1A2E), indent: 54),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem(this.icon, this.label, this.subtitle, this.onTap);
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.bodyMd.copyWith(fontSize: 14)),
                  Text(subtitle, style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
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
            width: 48,
            height: 48,
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
