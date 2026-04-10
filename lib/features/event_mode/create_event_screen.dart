import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/cipher_button.dart';
import '../../core/services/email_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as dart_ui;

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _nameCtrl = TextEditingController();
  final _orgCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _sending = false;
  DateTime _date = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _nameCtrl.dispose();
    _orgCtrl.dispose();
    _venueCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _generateAndEmail() async {
    final email = _emailCtrl.text.trim();
    if (_nameCtrl.text.isEmpty || _orgCtrl.text.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and enter an email')),
      );
      return;
    }

    setState(() => _sending = true);

    final userName = EmailService.extractNameFromEmail(email);
    final passId = const Uuid().v4().substring(0, 8).toUpperCase();
    final dateStr = '${_date.day}/${_date.month}/${_date.year}';

    // Build the email body
    final subject = '${_orgCtrl.text} — Event Pass: ${_nameCtrl.text}';
    final body = 'Hello $userName,\n\n'
      'You have been issued an official Entry Pass for the following event:\n\n'
      'Event: ${_nameCtrl.text}\n'
      'Organization: ${_orgCtrl.text}\n'
      'Venue: ${_venueCtrl.text}\n'
      'Date: $dateStr\n'
      'Pass ID: CIPH-$passId\n\n'
      'Attached is your QR Entry pass. Please present this pass at the entry checkpoint.\n\n'
      '— Cipher Smart Platform';

    try {
      final painter = QrPainter(
        data: jsonEncode({
          'cipher_type': 'event_pass',
          'userId': 'CIPH-$passId',
          'name': userName,
          'event': _nameCtrl.text,
          'org': _orgCtrl.text,
          'venue': _venueCtrl.text,
          'date': dateStr,
        }),
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
      );

      final imageData = await painter.toImageData(512, format: dart_ui.ImageByteFormat.png);
      if (imageData != null) {
        final bytes = imageData.buffer.asUint8List();
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/CIPH-$passId.png');
        await file.writeAsBytes(bytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: body,
          subject: subject,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating pass: $e')),
        );
      }
    }

    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        surfaceTintColor: Colors.transparent,
        title: Text('Event Management', style: AppTypography.displaySm.copyWith(fontSize: 18)),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Event', style: AppTypography.displayMd.copyWith(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text(
                      'Issue digital passes for your attendees',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              // Form
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
                      _Field(_orgCtrl, 'Organization Name', Icons.business_rounded, () => setState(() {})),
                      const SizedBox(height: 14),
                      _Field(_nameCtrl, 'Event Title', Icons.event_available_rounded, () => setState(() {})),
                      const SizedBox(height: 14),
                      _Field(_venueCtrl, 'Venue', Icons.map_rounded, () => setState(() {})),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ticket Preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _TicketPreview(
                  org: _orgCtrl.text,
                  title: _nameCtrl.text,
                  venue: _venueCtrl.text,
                  date: '${_date.day}/${_date.month}/${_date.year}',
                ),
              ),
              const SizedBox(height: 24),

              // Email + Send
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1A1A2E)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      const Icon(Icons.alternate_email_rounded, size: 18, color: AppColors.textMuted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _emailCtrl,
                          style: AppTypography.bodyMd.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Attendee email',
                            hintStyle: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (_) => _generateAndEmail(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: _sending ? null : _generateAndEmail,
                          icon: _sending
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.send_rounded, size: 16),
                          label: Text(_sending ? '' : 'Send', style: const TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.glitchPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.ctrl, this.hint, this.icon, this.onChanged);
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      onChanged: (_) => onChanged(),
      style: AppTypography.bodyMd.copyWith(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
        prefixIcon: Icon(icon, size: 20, color: AppColors.textMuted),
        filled: true,
        fillColor: const Color(0xFF050508),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF1A1A2E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF1A1A2E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.glitchPurple),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      ),
    );
  }
}

class _TicketPreview extends StatelessWidget {
  const _TicketPreview({required this.org, required this.title, required this.venue, required this.date});
  final String org;
  final String title;
  final String venue;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF050508),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    org.isEmpty ? 'CIPHER' : org.toUpperCase(),
                    style: AppTypography.labelSm.copyWith(color: AppColors.glitchPurple, letterSpacing: 2, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('ENTRY PASS', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 10)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title.isEmpty ? 'Event Title' : title, style: AppTypography.displaySm.copyWith(fontSize: 16)),
                      const SizedBox(height: 8),
                      _InfoRow(Icons.location_on_rounded, venue.isEmpty ? 'Venue' : venue),
                      const SizedBox(height: 4),
                      _InfoRow(Icons.calendar_today_rounded, date),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QrImageView(
                    data: jsonEncode({
                      'cipher_type': 'event_pass',
                      'userId': 'CIPH-PREVIEW',
                      'name': 'Attendee',
                      'event': title.isEmpty ? 'Event' : title,
                      'org': org.isEmpty ? 'Cipher' : org,
                      'venue': venue,
                      'date': date,
                    }),
                    size: 52,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.neonMint),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 12))),
      ],
    );
  }
}
