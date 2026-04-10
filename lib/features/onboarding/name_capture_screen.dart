import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/cipher_button.dart';

class NameCaptureScreen extends StatefulWidget {
  const NameCaptureScreen({super.key});
  @override
  State<NameCaptureScreen> createState() => _NameCaptureScreenState();
}

class _NameCaptureScreenState extends State<NameCaptureScreen> {
  final _ctrl = TextEditingController();
  bool _acceptedTerms = false;

  void _submit() {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    if (!_acceptedTerms) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the Terms & Conditions to continue')));
      return;
    }
    final box = Hive.box(AppConstants.hiveSettingsBox);
    box.put(AppConstants.hiveKeyOnboarded, true);
    box.put(AppConstants.hiveKeyName, name);
    context.go('/');
  }

  void _skip() {
    final box = Hive.box(AppConstants.hiveSettingsBox);
    box.put(AppConstants.hiveKeyOnboarded, true);
    context.go('/');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient orbs
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.15,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.cyan.withOpacity(0.06)),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              right: MediaQuery.of(context).size.width * 0.15,
              child: Container(
                width: 220, height: 220,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.violet.withOpacity(0.05)),
              ),
            ),

            // Main card
            Center(
              child: Padding(
                padding: AppSpacing.screenH,
                child: GlassCard(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome to Cipher.', style: AppTypography.displayLg.copyWith(fontSize: 28)),
                      const SizedBox(height: 12),
                      Text('What should we call you?', style: AppTypography.displaySm.copyWith(color: AppColors.textMuted, fontSize: 16)),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _ctrl,
                        autofocus: true,
                        style: AppTypography.bodyMd,
                        onSubmitted: (_) => _submit(),
                        decoration: const InputDecoration(hintText: 'Enter your name'),
                      ),
                      const SizedBox(height: 8),
                      Text('* You can always edit this later in settings.', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          SizedBox(
                            width: 24, height: 24,
                            child: Checkbox(
                              value: _acceptedTerms,
                              onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                              activeColor: AppColors.glitchPurple,
                              side: BorderSide(color: AppColors.textMuted.withOpacity(0.5)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text('I agree to the Terms & Conditions and Privacy Policy.', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ListenableBuilder(
                        listenable: _ctrl,
                        builder: (_, __) => CipherButton(
                          label: "Let's Go →",
                          onPressed: _ctrl.text.trim().isNotEmpty && _acceptedTerms ? _submit : null,
                          fullWidth: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: _skip,
                          child: Text('Skip for now', style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
