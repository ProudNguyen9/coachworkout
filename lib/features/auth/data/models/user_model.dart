class UserModel {
  final String id;
  final String? email;
  final String name;
  final String? role;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool? isOnline;
  final DateTime? lastSeen;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.role,
    this.avatarUrl,
    this.createdAt,
    this.isOnline,
    this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        role: json['role'],
        avatarUrl: json['avatar_url'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        isOnline: json['is_online'],
        lastSeen: json['last_seen'] != null
            ? DateTime.parse(json['last_seen'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
        'avatar_url': avatarUrl,
        'created_at': createdAt?.toIso8601String(),
        'is_online': isOnline,
        'last_seen': lastSeen?.toIso8601String(),
      };
}


