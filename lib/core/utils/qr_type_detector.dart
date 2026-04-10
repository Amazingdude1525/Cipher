import 'dart:convert';

enum QRType { url, upi, wifi, event, contact, text }

QRType detectQRType(String raw) {
  final s = raw.trim();
  if (s.startsWith('http') || s.startsWith('www')) return QRType.url;
  if (s.startsWith('upi://') || s.contains('pa=')) return QRType.upi;
  if (s.startsWith('WIFI:')) return QRType.wifi;
  if (s.startsWith('BEGIN:VCARD')) return QRType.contact;
  try {
    final json = jsonDecode(s);
    if (json is Map && json['cipher_type'] == 'event_pass') return QRType.event;
  } catch (_) {}
  return QRType.text;
}

String qrTypeName(QRType t) => switch (t) {
  QRType.url => 'URL',
  QRType.upi => 'UPI',
  QRType.wifi => 'WiFi',
  QRType.event => 'Event',
  QRType.contact => 'Contact',
  QRType.text => 'Text',
};
