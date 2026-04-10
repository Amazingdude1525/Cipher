import 'package:cipher/features/generator/widgets/qr_canvas.dart';
import 'package:flutter/material.dart';

class QrPreviewScreen extends StatelessWidget {
  const QrPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: QrCanvas(data: 'Preview')),
    );
  }
}
