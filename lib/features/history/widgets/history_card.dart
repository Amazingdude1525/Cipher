import 'package:cipher/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.raw});

  final String raw;

  @override
  Widget build(BuildContext context) {
    return GlassCard(child: Text(raw));
  }
}
