import 'package:cipher/core/widgets/glass_card.dart';
import 'package:cipher/core/widgets/type_badge.dart';
import 'package:flutter/material.dart';

class UrlResultCard extends StatelessWidget {
  const UrlResultCard({super.key, required this.raw});
  final String raw;

  @override
  Widget build(BuildContext context) => GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const TypeBadge(type: 'URL'), const SizedBox(height: 8), Text(raw)]));
}
