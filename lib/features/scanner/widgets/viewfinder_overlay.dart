import 'package:cipher/features/scanner/widgets/scan_line_painter.dart';
import 'package:flutter/material.dart';

class ViewfinderOverlay extends StatefulWidget {
  const ViewfinderOverlay({super.key});

  @override
  State<ViewfinderOverlay> createState() => _ViewfinderOverlayState();
}

class _ViewfinderOverlayState extends State<ViewfinderOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => CustomPaint(
            painter: ScanLinePainter(progress: _controller.value),
            child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.cyan, width: 2))),
          ),
        ),
      ),
    );
  }
}
