import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/qr_type_detector.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/type_badge.dart';
import '../../core/theme/glass_decoration.dart';
import '../../core/services/history_service.dart';
import 'dart:convert';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with TickerProviderStateMixin {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    torchEnabled: false,
    useNewCameraSelector: true,
  );
  bool _scanned = false;
  String? _lastResult;
  bool _isTorchOn = false;

  late final AnimationController _scanLineCtrl;
  late final Animation<double> _scanLinePosition;

  @override
  void initState() {
    super.initState();
    _scanLineCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _scanLinePosition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw == _lastResult) return;

    setState(() {
      _scanned = true;
      _lastResult = raw;
    });
    HapticFeedback.heavyImpact();
    _scanLineCtrl.stop();

    // Save to history
    final type = detectQRType(raw);
    HistoryService.save(data: raw, type: qrTypeName(type));

    _showResult(raw);
  }

  void _showResult(String raw) {
    final type = detectQRType(raw);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ResultSheet(raw: raw, type: type),
    ).then((_) {
      setState(() {
        _scanned = false;
        _lastResult = null;
      });
      _scanLineCtrl.repeat(reverse: true);
    });
  }

  void _toggleTorch() async {
    await _controller.toggleTorch();
    setState(() => _isTorchOn = !_isTorchOn);
  }

  void _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      final result = await _controller.analyzeImage(image.path);
      if (result != null && result.barcodes.isNotEmpty) {
        final raw = result.barcodes.first.rawValue;
        if (raw != null && raw.isNotEmpty) {
          HapticFeedback.heavyImpact();
          final type = detectQRType(raw);
          HistoryService.save(data: raw, type: qrTypeName(type));
          if (mounted) _showResult(raw);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No QR code found in image'),
              backgroundColor: AppColors.bgElevated,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final vfWidth = size.width * 0.75;
    final vfHeight = vfWidth;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            fit: BoxFit.cover,
          ),

          // Dark overlay with cutout
          CustomPaint(
            size: size,
            painter: _ViewfinderPainter(vfWidth: vfWidth, vfHeight: vfHeight),
          ),

          // Animated Sweeping Line
          AnimatedBuilder(
            animation: _scanLinePosition,
            builder: (_, __) {
              final topPadding = (size.height - vfHeight) / 2;
              final maxTravel = vfHeight - 20;
              final currentY = topPadding + 10 + (maxTravel * _scanLinePosition.value);

              return Positioned(
                top: currentY,
                left: (size.width - vfWidth) / 2,
                child: Container(
                  width: vfWidth,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF00F5FF),
                        const Color(0xFF00F5FF).withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.2, 1.0],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 3,
                      width: vfWidth,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00F5FF),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F5FF).withOpacity(0.8),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: GlassContainer(
                      radius: AppSpacing.radiusFull,
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GlassContainer(
                    radius: AppSpacing.radiusFull,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text('Scan QR', style: AppTypography.displaySm.copyWith(color: Colors.white, fontSize: 18)),
                  ),
                  const Spacer(),
                  // Gallery button
                  GestureDetector(
                    onTap: _pickFromGallery,
                    child: GlassContainer(
                      radius: AppSpacing.radiusFull,
                      padding: const EdgeInsets.all(14),
                      child: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Torch button
                  GestureDetector(
                    onTap: _toggleTorch,
                    child: GlassContainer(
                      radius: AppSpacing.radiusFull,
                      padding: const EdgeInsets.all(14),
                      borderColor: _isTorchOn ? AppColors.amber : null,
                      child: Icon(
                        _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                        color: _isTorchOn ? AppColors.amber : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hint at bottom
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 0,
            right: 0,
            child: Center(
              child: GlassContainer(
                radius: AppSpacing.radiusFull,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.qr_code_scanner_rounded, color: AppColors.cyan, size: 18),
                    const SizedBox(width: 8),
                    Text('Point at a QR to scan', style: AppTypography.bodySm.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  final double vfWidth;
  final double vfHeight;
  _ViewfinderPainter({required this.vfWidth, required this.vfHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: vfWidth, height: vfHeight);

    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.65);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24))),
      ),
      overlayPaint,
    );

    const len = 32.0;
    const thick = 4.0;

    final bracketPaint = Paint()
      ..color = const Color(0xFF00F5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thick * 3
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final corners = [
      (rect.topLeft, 1.0, 1.0),
      (rect.topRight, -1.0, 1.0),
      (rect.bottomLeft, 1.0, -1.0),
      (rect.bottomRight, -1.0, -1.0),
    ];

    for (final (pos, dx, dy) in corners) {
      final p1 = pos + Offset(len * dx, 0);
      final p2 = pos + Offset(0, len * dy);
      canvas.drawLine(pos, p1, glowPaint);
      canvas.drawLine(pos, p2, glowPaint);
      canvas.drawLine(pos, p1, bracketPaint);
      canvas.drawLine(pos, p2, bracketPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ResultSheet extends StatelessWidget {
  const _ResultSheet({required this.raw, required this.type});
  final String raw;
  final QRType type;

  @override
  Widget build(BuildContext context) {
    bool isVerification = false;
    String vName = '';
    String vId = '';
    String vOrg = '';
    
    try {
      final data = jsonDecode(raw);
      if (data != null && data is Map<String, dynamic>) {
        final t = data['cipher_type'];
        if (t == 'event_pass' || t == 'id_card') {
          isVerification = true;
          vName = data['name'] ?? 'User';
          vId = data['userId'] ?? 'Unknown ID';
          vOrg = data['org'] ?? (t == 'event_pass' ? 'Event Pass' : 'ID Card');
        }
      }
    } catch (_) {}

    return DraggableScrollableSheet(
      initialChildSize: isVerification ? 0.6 : 0.45,
      minChildSize: isVerification ? 0.6 : 0.3,
      maxChildSize: isVerification ? 0.75 : 0.75,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: const Border(top: BorderSide(color: AppColors.glassBorder)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 24),
                const SizedBox(width: 12),
                Text('Scan Complete', style: AppTypography.displaySm.copyWith(color: AppColors.green)),
                const Spacer(),
                TypeBadge(type: qrTypeName(type)),
              ],
            ),
            if (isVerification) ...[
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonMint.withOpacity(0.1),
                    border: Border.all(color: AppColors.neonMint.withOpacity(0.3), width: 2),
                    boxShadow: [BoxShadow(color: AppColors.neonMint.withOpacity(0.2), blurRadius: 40)],
                  ),
                  child: const Center(child: Icon(Icons.check_rounded, color: AppColors.neonMint, size: 48)),
                ),
              ),
              const SizedBox(height: 24),
              Center(child: Text('PERSON VERIFIED', style: AppTypography.displaySm.copyWith(color: AppColors.neonMint, letterSpacing: 2, fontSize: 16))),
              const SizedBox(height: 32),
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(vName, style: AppTypography.displayLg.copyWith(fontSize: 26, color: Colors.white), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('ID: $vId', style: AppTypography.monoMd.copyWith(color: AppColors.textMuted, fontSize: 14)),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.glassBorder),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.security_rounded, size: 14, color: AppColors.glitchPurple),
                        const SizedBox(width: 6),
                        Text('Powered by Cipher • $vOrg', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Data Payload', style: AppTypography.labelSm),
                    const SizedBox(height: 12),
                    SelectableText(raw, style: AppTypography.monoMd.copyWith(fontSize: 15)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ActionBtn(Icons.copy_rounded, 'Copy', () {
                    Clipboard.setData(ClipboardData(text: raw));
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Copied to clipboard'),
                        backgroundColor: AppColors.bgElevated,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionBtn(Icons.share_rounded, 'Share', () async {
                    await Share.share(raw, subject: 'Scanned QR Data');
                  }),
                ),
                if (type == QRType.url) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionBtn(Icons.open_in_browser_rounded, 'Open', () async {
                      final uri = Uri.tryParse(raw);
                      if (uri != null) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    }),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.cyan),
            const SizedBox(height: 6),
            Text(label, style: AppTypography.labelSm.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
