import 'package:cipher/core/widgets/glass_card.dart';
import 'package:cipher/core/widgets/type_badge.dart';
import 'package:flutter/material.dart';

class GenericResultCard extends StatelessWidget {
  const GenericResultCard({super.key, required this.raw});
  final String raw;

  @override
  Widget build(BuildContext context) => GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const TypeBadge(type: 'Text'), const SizedBox(height: 8), Text(raw)]));
}
