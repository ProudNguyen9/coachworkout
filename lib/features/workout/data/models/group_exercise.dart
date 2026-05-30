import 'package:uuid/uuid.dart';

class GroupExercise {
  final String id;
  final String type; // ví dụ: "beginner", "intermediate", "advanced"
  final DateTime? createdAt;
  final String goal; // ví dụ: "Tăng sức mạnh toàn thân"
  final String urlThumbnail; // đường dẫn ảnh thumbnail
  final String title; // tiêu đề nhóm bài tập
  final String description; // mô tả
  final String level; // beginner / intermediate / advanced

  GroupExercise({
    required this.id,
    required this.type,
    this.createdAt,
    required this.goal,
    required this.urlThumbnail,
    required this.title,
    required this.description,
    required this.level,
  });

  /// Tạo từ JSON Supabase
  factory GroupExercise.fromJson(Map<String, dynamic> json) {
    return GroupExercise(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) // an toàn hơn parse thường
          : null,
      goal: json['goal'] ?? '',
      // 👇 xử lý cả hai khả năng key (đúng & sai chính tả)
      urlThumbnail: json['url_thumbnail'] ?? json['url_thumnail'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? '',
    );
  }

  /// Chuyển sang JSON (để insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'created_at': createdAt?.toIso8601String(),
      'goal': goal,
      // Giữ đúng chuẩn "url_thumbnail"
      'url_thumbnail': urlThumbnail,
      'title': title,
      'description': description,
      'level': level,
    };
  }

  /// Hàm tiện tạo mới (auto tạo UUID & createdAt)
  factory GroupExercise.create({
    required String type,
    required String goal,
    required String urlThumbnail,
    required String title,
    required String description,
    required String level,
  }) {
    return GroupExercise(
      id: const Uuid().v4(),
      type: type,
      goal: goal,
      urlThumbnail: urlThumbnail,
      title: title,
      description: description,
      level: level,
      createdAt: DateTime.now(),
    );
  }
}


