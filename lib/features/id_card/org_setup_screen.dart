import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/cipher_button.dart';
import '../../core/services/email_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as dart_ui;

class OrgSetupScreen extends StatefulWidget {
  const OrgSetupScreen({super.key});
  @override
  State<OrgSetupScreen> createState() => _OrgSetupScreenState();
}

class _OrgSetupScreenState extends State<OrgSetupScreen> {
  final _orgNameCtrl = TextEditingController();
  final _memberEmailCtrl = TextEditingController();
  final List<Map<String, String>> _members = [];

  @override
  void dispose() {
    _orgNameCtrl.dispose();
    _memberEmailCtrl.dispose();
    super.dispose();
  }

  void _addMember() {
    final email = _memberEmailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) return;

    final name = EmailService.extractNameFromEmail(email);
    final userId = const Uuid().v4().substring(0, 8).toUpperCase();

    setState(() {
      _members.add({'name': name, 'email': email, 'userId': 'CIPH-$userId'});
      _memberEmailCtrl.clear();
    });
  }

  void _sendPass(Map<String, String> member) async {
    final org = _orgNameCtrl.text.trim();
    final subject = '$org — Digital Identity Pass';
    final body = 'Hello ${member['name']},\n\n'
      'You have been issued a verified Digital Identity Pass.\n\n'
      'Organization: $org\n'
      'Name: ${member['name']}\n'
      'User ID: ${member['userId']}\n\n'
      'Attached is your QR Pass. Please present this pass when required.\n\n'
      '— Cipher Smart Platform';
      
    try {
      final painter = QrPainter(
        data: jsonEncode({
          'cipher_type': 'id_card',
          'org': org,
          'name': member['name'],
          'userId': member['userId'],
        }),
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
      );

      final imageData = await painter.toImageData(512, format: dart_ui.ImageByteFormat.png);
      if (imageData != null) {
        final bytes = imageData.buffer.asUint8List();
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${member['userId']}.png');
        await file.writeAsBytes(bytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: body,
          subject: subject,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating pass: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        surfaceTintColor: Colors.transparent,
        title: Text('Digital Identity', style: AppTypography.displaySm.copyWith(fontSize: 18)),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Organization Portal', style: AppTypography.displayMd.copyWith(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text(
                      'Issue verified identity passes to your team',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              // Org Name + ID Card Preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1A1A2E)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _orgNameCtrl,
                        onChanged: (_) => setState(() {}),
                        style: AppTypography.bodyMd.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Organization Name',
                          hintStyle: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                          prefixIcon: const Icon(Icons.business_center_rounded, size: 20, color: AppColors.textMuted),
                          filled: true,
                          fillColor: const Color(0xFF050508),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A1A2E))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A1A2E))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.glitchPurple)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _IdCardPreview(
                        orgName: _orgNameCtrl.text,
                        memberName: _members.isEmpty ? 'Prateek Das' : _members.last['name']!,
                        userId: _members.isEmpty ? 'CIPH-D9F2E1' : _members.last['userId']!,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Member List Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MEMBERS', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, letterSpacing: 2, fontSize: 11)),
                    if (_members.isNotEmpty) Text('${_members.length} active', style: AppTypography.labelSm.copyWith(color: AppColors.neonMint, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Add Member Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1A1A2E)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      const Icon(Icons.alternate_email_rounded, size: 18, color: AppColors.textMuted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _memberEmailCtrl,
                          style: AppTypography.bodyMd.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Member email',
                            hintStyle: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (_) => _addMember(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: _addMember,
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Add', style: TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neonMint,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Members List
              if (_members.isNotEmpty) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1A1A2E)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _members.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFF1A1A2E), indent: 56),
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.glitchPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(child: Text(_members[i]['name']![0], style: TextStyle(color: AppColors.glitchPurple, fontWeight: FontWeight.bold, fontSize: 14))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_members[i]['name']!, style: AppTypography.bodyMd.copyWith(fontSize: 14)),
                                  Text(_members[i]['userId']!, style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _sendPass(_members[i]),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.glitchPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.send_rounded, size: 16, color: AppColors.glitchPurple),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Bulk issue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CipherButton(
                  label: 'Issue All Passes',
                  icon: Icons.send_rounded,
                  onPressed: _members.isNotEmpty && _orgNameCtrl.text.isNotEmpty ? () {
                    for (final m in _members) {
                      _sendPass(m);
                    }
                  } : null,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdCardPreview extends StatelessWidget {
  const _IdCardPreview({required this.orgName, required this.memberName, required this.userId});
  final String orgName;
  final String memberName;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF050508),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A1A2E), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Stack(
        children: [
          // Subtle glow
          Positioned(
            top: -30, right: -30,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.glitchPurple.withOpacity(0.08), Colors.transparent]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        orgName.isEmpty ? 'CIPHER' : orgName.toUpperCase(),
                        style: AppTypography.labelSm.copyWith(color: AppColors.glitchPurple, letterSpacing: 2.5, fontWeight: FontWeight.bold, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.verified_user_rounded, color: AppColors.neonMint, size: 18),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(memberName, style: AppTypography.displaySm.copyWith(fontSize: 20, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(userId, style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 12, letterSpacing: 1.2)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: QrImageView(
                        data: jsonEncode({
                          'cipher_type': 'id_card',
                          'org': orgName.isEmpty ? 'Cipher' : orgName,
                          'name': memberName,
                          'userId': userId,
                        }),
                        size: 52,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
