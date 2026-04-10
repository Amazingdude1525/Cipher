class ScanResultModel {
  const ScanResultModel({
    required this.id,
    required this.raw,
    required this.type,
    required this.timestamp,
    this.note = '',
  });

  final String id;
  final String raw;
  final String type;
  final DateTime timestamp;
  final String note;

  ScanResultModel copyWith({
    String? id,
    String? raw,
    String? type,
    DateTime? timestamp,
    String? note,
  }) {
    return ScanResultModel(
      id: id ?? this.id,
      raw: raw ?? this.raw,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'raw': raw,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
        'note': note,
      };

  factory ScanResultModel.fromJson(Map<String, dynamic> json) => ScanResultModel(
        id: json['id'] as String,
        raw: json['raw'] as String,
        type: json['type'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        note: (json['note'] ?? '') as String,
      );
}
