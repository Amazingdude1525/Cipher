import 'package:cipher/models/member_model.dart';

class OrganizationModel {
  const OrganizationModel({
    required this.orgId,
    required this.ownerId,
    required this.name,
    this.logoUrl = '',
    this.brandColor = '#7B61FF',
    this.cardTemplate = 1,
    this.createdAt,
    this.members = const [],
  });

  final String orgId;
  final String ownerId;
  final String name;
  final String logoUrl;
  final String brandColor;
  final int cardTemplate;
  final DateTime? createdAt;
  final List<MemberModel> members;

  OrganizationModel copyWith({
    String? orgId,
    String? ownerId,
    String? name,
    String? logoUrl,
    String? brandColor,
    int? cardTemplate,
    DateTime? createdAt,
    List<MemberModel>? members,
  }) {
    return OrganizationModel(
      orgId: orgId ?? this.orgId,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      brandColor: brandColor ?? this.brandColor,
      cardTemplate: cardTemplate ?? this.cardTemplate,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toJson() => {
        'orgId': orgId,
        'ownerId': ownerId,
        'name': name,
        'logoUrl': logoUrl,
        'brandColor': brandColor,
        'cardTemplate': cardTemplate,
        'createdAt': createdAt?.toIso8601String(),
        'members': members.map((e) => e.toJson()).toList(),
      };

  factory OrganizationModel.fromJson(Map<String, dynamic> json) => OrganizationModel(
        orgId: json['orgId'] as String,
        ownerId: (json['ownerId'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        logoUrl: (json['logoUrl'] ?? '') as String,
        brandColor: (json['brandColor'] ?? '#7B61FF') as String,
        cardTemplate: (json['cardTemplate'] ?? 1) as int,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
        members: (json['members'] as List?)
                ?.map((e) => MemberModel.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );
}
