import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCanvas extends StatelessWidget {
  const QrCanvas({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: QrImageView(
        data: data,
        size: 220,
        eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square),
      ),
    );
  }
}
