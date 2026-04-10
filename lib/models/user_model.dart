class UserModel {
  const UserModel({
    required this.uid,
    required this.name,
    this.email,
    this.phone,
    this.photoUrl = '',
    this.plan = 'free',
    this.qrGenerationsUsed = 0,
    this.createdAt,
    this.lastSeen,
    this.locationOnSignup = const {},
  });

  final String uid;
  final String name;
  final String? email;
  final String? phone;
  final String photoUrl;
  final String plan;
  final int qrGenerationsUsed;
  final DateTime? createdAt;
  final DateTime? lastSeen;
  final Map<String, String> locationOnSignup;

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? plan,
    int? qrGenerationsUsed,
    DateTime? createdAt,
    DateTime? lastSeen,
    Map<String, String>? locationOnSignup,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      plan: plan ?? this.plan,
      qrGenerationsUsed: qrGenerationsUsed ?? this.qrGenerationsUsed,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      locationOnSignup: locationOnSignup ?? this.locationOnSignup,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'plan': plan,
        'qrGenerationsUsed': qrGenerationsUsed,
        'createdAt': createdAt?.toIso8601String(),
        'lastSeen': lastSeen?.toIso8601String(),
        'locationOnSignup': locationOnSignup,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'] as String,
        name: (json['name'] ?? '') as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        photoUrl: (json['photoUrl'] ?? '') as String,
        plan: (json['plan'] ?? 'free') as String,
        qrGenerationsUsed: (json['qrGenerationsUsed'] ?? 0) as int,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
        lastSeen: json['lastSeen'] == null ? null : DateTime.parse(json['lastSeen'] as String),
        locationOnSignup: (json['locationOnSignup'] as Map?)
                ?.map((key, value) => MapEntry(key.toString(), value.toString())) ??
            {},
      );
}
