import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/cipher_button.dart';

class BugReportScreen extends StatelessWidget {
  const BugReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const email = 'prateekdas5255@gmail.com';

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: Text('Report a Bug', style: AppTypography.displaySm),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Found a glitch?', style: AppTypography.displayMd),
              const SizedBox(height: 8),
              Text(
                'Help us eliminate bugs to keep Cipher running at peak performance. Reach out directly to the lead developer.',
                style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 32),
              
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.glitchPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bug_report_rounded, color: AppColors.glitchPurple, size: 28),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Direct Support Channel',
                      style: AppTypography.labelLg.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: email));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email copied to clipboard!')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.bgDeep,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.alternate_email_rounded, size: 16, color: AppColors.glitchPurple),
                            const SizedBox(width: 12),
                            Text(email, style: AppTypography.monoMd.copyWith(color: AppColors.glitchPurple, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              CipherButton(
                label: 'Send Direct Message',
                icon: Icons.send_rounded,
                fullWidth: true,
                onPressed: () async {
                  final Uri params = Uri(
                    scheme: 'mailto',
                    path: email,
                    query: 'subject=CIPHER Bug Report&body=Device Details:\n- Version: 1.0.0\n\nBug Description:',
                  );
                  if (await canLaunchUrl(params)) {
                    await launchUrl(params);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
