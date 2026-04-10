import 'package:flutter/material.dart';

/// Placeholder — result viewing is handled by the bottom sheet in ScannerScreen.
/// This file is kept as a stub to avoid broken imports elsewhere.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.raw});
  final String raw;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(raw, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
