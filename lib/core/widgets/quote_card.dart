import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_colors.dart';
import '../constants/quotes.dart';
import 'glass_card.dart';

/// Rotating quote card matching the home screen prototype.
class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  int _idx = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      setState(() => _idx = (_idx + 1) % cipherQuotes.length);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Opacity(opacity: 0.3, child: Text('🔐', style: TextStyle(fontSize: 24))),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Column(
                key: ValueKey(_idx),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${cipherQuotes[_idx]}"',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('— Cipher', style: AppTypography.labelSm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
