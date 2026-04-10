import 'package:flutter/material.dart';

class ScanLinePainter extends CustomPainter {
  ScanLinePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final y = 8 + (size.height - 16) * progress;
    final rect = Rect.fromLTWH(0, y, size.width, 2);
    final paint = Paint()
      ..shader = const LinearGradient(colors: [Colors.transparent, Colors.cyan, Colors.transparent])
          .createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant ScanLinePainter oldDelegate) => oldDelegate.progress != progress;
}
