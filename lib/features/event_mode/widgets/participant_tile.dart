import 'package:flutter/material.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({super.key, required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(name), subtitle: Text(email));
  }
}
