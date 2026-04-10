import 'package:flutter/material.dart';

class MemberTile extends StatelessWidget {
  const MemberTile({super.key, required this.name, required this.role});

  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(name), subtitle: Text(role));
  }
}
