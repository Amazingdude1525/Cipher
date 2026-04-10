import 'package:cipher/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class IdCardWidget extends StatelessWidget {
  const IdCardWidget({super.key, required this.memberName, required this.role});

  final String memberName;
  final String role;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 200,
      child: GlassCard(
        radius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cipher ID'),
            const Spacer(),
            Text(memberName),
            Text(role),
          ],
        ),
      ),
    );
  }
}
