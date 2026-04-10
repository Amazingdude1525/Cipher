import 'package:flutter/material.dart';

class BatchItemTile extends StatelessWidget {
  const BatchItemTile({super.key, required this.content, required this.type});

  final String content;
  final String type;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(content), subtitle: Text(type));
  }
}
