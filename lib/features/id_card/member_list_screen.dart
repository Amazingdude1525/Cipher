import 'package:cipher/features/id_card/widgets/member_tile.dart';
import 'package:flutter/material.dart';

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({super.key, required this.orgId});
  final String orgId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Members • $orgId')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, i) => MemberTile(name: 'Member ${i + 1}', role: 'Role ${i + 1}'),
      ),
    );
  }
}
