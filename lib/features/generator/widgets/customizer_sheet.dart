import 'package:flutter/material.dart';

class CustomizerSheet extends StatelessWidget {
  const CustomizerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF16162A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: const SafeArea(child: Text('Customizer (colors, dot shape, logo, presets)')),
    );
  }
}
