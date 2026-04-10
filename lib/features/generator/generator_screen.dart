import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/cipher_button.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});
  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _inputCtrl = TextEditingController();
  final _qrKey = GlobalKey();

  // Customisation state
  Color _qrColor = const Color(0xFF080810);
  QrEyeShape _eyeShape = QrEyeShape.square;
  QrDataModuleShape _dataShape = QrDataModuleShape.square;

  static const _types = [
    (Icons.description_outlined, 'Text'),
    (Icons.link_rounded, 'URL'),
    (Icons.wifi_rounded, 'WiFi'),
    (Icons.currency_rupee_rounded, 'UPI'),
    (Icons.person_outline_rounded, 'Contact'),
  ];

  final _ssidCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _encryption = 'WPA';
  final _upiIdCtrl = TextEditingController();
  final _upiNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _types.length, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _inputCtrl.dispose();
    _ssidCtrl.dispose();
    _passwordCtrl.dispose();
    _upiIdCtrl.dispose();
    _upiNameCtrl.dispose();
    super.dispose();
  }

  String get _currentQrData {
    final text = switch (_tabCtrl.index) {
      0 => _inputCtrl.text,
      1 => _inputCtrl.text.isEmpty ? '' : (_inputCtrl.text.startsWith('http') ? _inputCtrl.text : 'https://${_inputCtrl.text}'),
      2 => _ssidCtrl.text.isEmpty ? '' : 'WIFI:T:$_encryption;S:${_ssidCtrl.text};P:${_passwordCtrl.text};;',
      3 => _upiIdCtrl.text.isEmpty ? '' : 'upi://pay?pa=${_upiIdCtrl.text}&pn=${_upiNameCtrl.text}',
      4 => _inputCtrl.text.isEmpty ? '' : 'BEGIN:VCARD\nVERSION:3.0\nFN:${_inputCtrl.text}\nEND:VCARD',
      _ => _inputCtrl.text,
    };
    return text.trim();
  }

  Future<void> _shareQr() async {
    try {
      final file = await _generatePng();
      if (file == null) return;
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: 'Generated with Cipher',
        subject: 'QR Code',
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Share failed: $e')));
    }
  }

  Future<void> _saveQr() async {
    try {
      final file = await _generatePng();
      if (file == null) return;
      
      // Save directly to raw Download path for Android
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (await downloadsDir.exists()) {
        final newFile = File('${downloadsDir.path}/cipher_qr_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.copy(newFile.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to Downloads!'), backgroundColor: AppColors.green));
          HapticFeedback.lightImpact();
        }
      } else {
        // Fallback to sharing if directory doesn't exist
        await Share.shareXFiles([XFile(file.path)], text: 'Save this QR code');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }

  Future<File?> _generatePng() async {
      final painter = QrPainter(
        data: _currentQrData.isEmpty ? 'https://cipher.app' : _currentQrData,
        version: QrVersions.auto,
        eyeStyle: QrEyeStyle(eyeShape: _eyeShape, color: _qrColor),
        dataModuleStyle: QrDataModuleStyle(dataModuleShape: _dataShape, color: _qrColor),
      );

      final imageData = await painter.toImageData(512, format: ui.ImageByteFormat.png);
      if (imageData == null) return null;

      final bytes = imageData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/cipher_qr_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Generate QR', style: AppTypography.displayLg),
                    IconButton(
                      icon: const Icon(Icons.help_outline_rounded, color: AppColors.textMuted),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Enter content and share your custom QR code'),
                            backgroundColor: AppColors.bgElevated,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Horizontal Type Selector
              SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: _types.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final isSelected = _tabCtrl.index == i;
                    return GestureDetector(
                      onTap: () => _tabCtrl.animateTo(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.glassStrong : AppColors.glassFill,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                          border: Border.all(
                            color: isSelected ? AppColors.cyan : AppColors.glassBorder,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected ? [BoxShadow(color: AppColors.cyan.withOpacity(0.2), blurRadius: 10)] : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_types[i].$1, size: 18, color: isSelected ? Colors.white : AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(
                              _types[i].$2,
                              style: AppTypography.labelSm.copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Preview Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -20, right: -20,
                            child: Container(
                              width: 120, height: 120,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.glitchPurple.withOpacity(0.35), boxShadow: [BoxShadow(color: AppColors.glitchPurple.withOpacity(0.4), blurRadius: 40)]),
                            ),
                          ),
                          Positioned(
                            bottom: -20, left: -20,
                            child: Container(
                              width: 120, height: 120,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.cyan.withOpacity(0.35), boxShadow: [BoxShadow(color: AppColors.cyan.withOpacity(0.4), blurRadius: 40)]),
                            ),
                          ),
                          Center(
                            child: RepaintBoundary(
                              key: _qrKey,
                              child: Container(
                                width: 220,
                                height: 220,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, offset: const Offset(0, 10)),
                                  ],
                                ),
                                child: QrImageView(
                                  data: _currentQrData.isEmpty ? 'https://cipher.app' : _currentQrData,
                                  size: 190,
                                  backgroundColor: Colors.white,
                                  eyeStyle: QrEyeStyle(eyeShape: _eyeShape, color: _qrColor),
                                  dataModuleStyle: QrDataModuleStyle(dataModuleShape: _dataShape, color: _qrColor),
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _currentQrData.isEmpty ? 'Enter details to start' : 'Real-time Preview ✨',
                        style: AppTypography.labelSm.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: _GlassAction(
                              icon: Icons.auto_awesome_rounded,
                              label: 'Style',
                              onTap: _showCustomizer,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: _GlassAction(
                              icon: Icons.save_alt_rounded,
                              label: 'Save',
                              onTap: _currentQrData.isNotEmpty ? _saveQr : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 4,
                            child: _GlassAction(
                              icon: Icons.share_rounded,
                              label: 'Share',
                              onTap: _currentQrData.isNotEmpty ? _shareQr : null,
                              isPrimary: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Input fields Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('CONSTRUCTION', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, letterSpacing: 1.5)),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(child: _buildInputFields()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomizer() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: const Border(top: BorderSide(color: AppColors.glassBorder)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Text('Customize Pro', style: AppTypography.displaySm),
              const SizedBox(height: 32),

              Text('Brand Color', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Color(0xFF080810),
                  const Color(0xFF2E3192),
                  const Color(0xFFC1272D),
                  const Color(0xFF009245),
                  const Color(0xFFFBB03B),
                ].map((c) => GestureDetector(
                  onTap: () {
                    setModalState(() => _qrColor = c);
                    setState(() => _qrColor = c);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(color: _qrColor == c ? Colors.white : Colors.transparent, width: 2),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 32),

              Text('Module Style', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _ModalPill('Square', _dataShape == QrDataModuleShape.square, () {
                    setModalState(() => _dataShape = QrDataModuleShape.square);
                    setState(() => _dataShape = QrDataModuleShape.square);
                  }),
                  _ModalPill('Rounded', _dataShape == QrDataModuleShape.circle, () {
                    setModalState(() => _dataShape = QrDataModuleShape.circle);
                    setState(() => _dataShape = QrDataModuleShape.circle);
                  }),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return switch (_tabCtrl.index) {
      0 || 1 || 4 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            switch (_tabCtrl.index) {
              1 => 'Enter Website Link',
              4 => 'V-Card Name',
              _ => 'Message Content',
            },
            style: AppTypography.labelSm,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _inputCtrl,
            onChanged: (_) => setState(() {}),
            maxLines: _tabCtrl.index == 0 ? 5 : 1,
            style: AppTypography.bodyMd,
            decoration: InputDecoration(
              hintText: switch (_tabCtrl.index) {
                1 => 'https://example.com',
                4 => 'Full Name',
                _ => 'Scan to read this message...',
              },
            ),
          ),
        ],
      ),
      2 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WiFi Auto-Connect', style: AppTypography.labelSm),
          const SizedBox(height: 16),
          TextField(
            controller: _ssidCtrl,
            onChanged: (_) => setState(() {}),
            style: AppTypography.bodyMd,
            decoration: const InputDecoration(hintText: 'SSID', prefixIcon: Icon(Icons.wifi, size: 22)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordCtrl,
            onChanged: (_) => setState(() {}),
            obscureText: true,
            style: AppTypography.bodyMd,
            decoration: const InputDecoration(hintText: 'Password', prefixIcon: Icon(Icons.lock_person_outlined, size: 22)),
          ),
          const SizedBox(height: 16),
          Row(
            children: ['WPA', 'WEP', 'None'].map((e) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(e, style: AppTypography.labelSm.copyWith(color: _encryption == e ? Colors.white : AppColors.textSecondary)),
                selected: _encryption == e,
                selectedColor: AppColors.cyan.withOpacity(0.4),
                backgroundColor: AppColors.glassFill,
                onSelected: (_) => setState(() => _encryption = e),
              ),
            )).toList(),
          ),
        ],
      ),
      3 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insta-Pay UPI', style: AppTypography.labelSm),
          const SizedBox(height: 12),
          TextField(
            controller: _upiIdCtrl,
            onChanged: (_) => setState(() {}),
            style: AppTypography.bodyMd,
            decoration: const InputDecoration(hintText: 'UPI ID (e.g. prateek@okaxis)', prefixIcon: Icon(Icons.wallet, size: 22)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _upiNameCtrl,
            onChanged: (_) => setState(() {}),
            style: AppTypography.bodyMd,
            decoration: const InputDecoration(hintText: 'Receiver Name', prefixIcon: Icon(Icons.badge_outlined, size: 22)),
          ),
        ],
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ModalPill extends StatelessWidget {
  const _ModalPill(this.label, this.isSelected, this.onTap);
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyan : AppColors.glassFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: AppTypography.labelSm.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

class _GlassAction extends StatelessWidget {
  const _GlassAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // Stadium/Pill shaped
            color: isPrimary ? AppColors.glitchPurple.withOpacity(0.4) : AppColors.glassFill,
            border: Border.all(
              color: isPrimary ? AppColors.glitchPurple : AppColors.glassBorder,
              width: isPrimary ? 1.5 : 1.0,
            ),
            boxShadow: isPrimary
                ? [BoxShadow(color: AppColors.glitchPurple.withOpacity(0.3), blurRadius: 15)]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: AppTypography.labelSm.copyWith(
                      color: Colors.white,
                      fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
