class EventModel {
  const EventModel({
    required this.eventId,
    required this.hostId,
    required this.name,
    required this.venue,
    required this.date,
    this.isPublic = false,
    this.createdAt,
  });

  final String eventId;
  final String hostId;
  final String name;
  final String venue;
  final DateTime date;
  final bool isPublic;
  final DateTime? createdAt;

  EventModel copyWith({
    String? eventId,
    String? hostId,
    String? name,
    String? venue,
    DateTime? date,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return EventModel(
      eventId: eventId ?? this.eventId,
      hostId: hostId ?? this.hostId,
      name: name ?? this.name,
      venue: venue ?? this.venue,
      date: date ?? this.date,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'hostId': hostId,
        'name': name,
        'venue': venue,
        'date': date.toIso8601String(),
        'isPublic': isPublic,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        eventId: json['eventId'] as String,
        hostId: (json['hostId'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        venue: (json['venue'] ?? '') as String,
        date: DateTime.parse(json['date'] as String),
        isPublic: (json['isPublic'] ?? false) as bool,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      );
}
