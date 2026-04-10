class BatchItem {
  const BatchItem({
    required this.id,
    required this.raw,
    required this.type,
    required this.timestamp,
  });

  final String id;
  final String raw;
  final String type;
  final DateTime timestamp;

  BatchItem copyWith({String? id, String? raw, String? type, DateTime? timestamp}) =>
      BatchItem(
        id: id ?? this.id,
        raw: raw ?? this.raw,
        type: type ?? this.type,
        timestamp: timestamp ?? this.timestamp,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'raw': raw,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
      };

  factory BatchItem.fromJson(Map<String, dynamic> json) => BatchItem(
        id: json['id'] as String,
        raw: json['raw'] as String,
        type: json['type'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
