class MemberModel {
  const MemberModel({
    required this.memberId,
    required this.name,
    required this.role,
    this.photoUrl = '',
    this.email = '',
    this.qrData = '',
  });

  final String memberId;
  final String name;
  final String role;
  final String photoUrl;
  final String email;
  final String qrData;

  MemberModel copyWith({
    String? memberId,
    String? name,
    String? role,
    String? photoUrl,
    String? email,
    String? qrData,
  }) {
    return MemberModel(
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      qrData: qrData ?? this.qrData,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'name': name,
        'role': role,
        'photoUrl': photoUrl,
        'email': email,
        'qrData': qrData,
      };

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        memberId: json['memberId'] as String,
        name: (json['name'] ?? '') as String,
        role: (json['role'] ?? '') as String,
        photoUrl: (json['photoUrl'] ?? '') as String,
        email: (json['email'] ?? '') as String,
        qrData: (json['qrData'] ?? '') as String,
      );
}
