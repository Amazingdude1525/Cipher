class ParticipantModel {
  const ParticipantModel({
    required this.name,
    required this.email,
    required this.participantId,
    this.checkedIn = false,
    this.checkedInAt,
    this.passSent = false,
    this.qrData = '',
  });

  final String name;
  final String email;
  final String participantId;
  final bool checkedIn;
  final DateTime? checkedInAt;
  final bool passSent;
  final String qrData;

  ParticipantModel copyWith({
    String? name,
    String? email,
    String? participantId,
    bool? checkedIn,
    DateTime? checkedInAt,
    bool? passSent,
    String? qrData,
  }) {
    return ParticipantModel(
      name: name ?? this.name,
      email: email ?? this.email,
      participantId: participantId ?? this.participantId,
      checkedIn: checkedIn ?? this.checkedIn,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      passSent: passSent ?? this.passSent,
      qrData: qrData ?? this.qrData,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'participantId': participantId,
        'checkedIn': checkedIn,
        'checkedInAt': checkedInAt?.toIso8601String(),
        'passSent': passSent,
        'qrData': qrData,
      };

  factory ParticipantModel.fromJson(Map<String, dynamic> json) => ParticipantModel(
        name: (json['name'] ?? '') as String,
        email: (json['email'] ?? '') as String,
        participantId: (json['participantId'] ?? '') as String,
        checkedIn: (json['checkedIn'] ?? false) as bool,
        checkedInAt: json['checkedInAt'] == null ? null : DateTime.parse(json['checkedInAt'] as String),
        passSent: (json['passSent'] ?? false) as bool,
        qrData: (json['qrData'] ?? '') as String,
      );
}
