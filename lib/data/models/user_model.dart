class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? role;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool? isOnline; // 🟢 trạng thái online
  final DateTime? lastSeen; // ⏰ thời gian hoạt động cuối

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.role,
    this.avatarUrl,
    this.createdAt,
    this.isOnline,
    this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      role: json['role'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      isOnline: json['is_online'] as bool?, // 👈 thêm
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'])
          : null, // 👈 thêm
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}
