import 'package:cipher/features/id_card/widgets/id_card_widget.dart';
import 'package:flutter/material.dart';

class IdCardPreviewScreen extends StatelessWidget {
  const IdCardPreviewScreen({super.key, required this.memberId});
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ID Card Preview')),
      body: Center(child: IdCardWidget(memberName: memberId, role: 'Member')),
    );
  }
}
