import 'user_model.dart';
import 'message_model.dart';

class ConversationModel {
  final String id;
  final UserModel? user1;
  final UserModel? user2;
  final DateTime? createdAt;
  final MessageModel? lastMessage;

  ConversationModel({
    required this.id,
    this.user1,
    this.user2,
    this.createdAt,
    this.lastMessage,
  });

  /// 🧩 Dùng khi có user hiện tại, để biết “người còn lại” trong hội thoại là ai
  UserModel? otherUser(String currentUserId) {
    if (user1 != null && user1!.id != currentUserId) return user1;
    if (user2 != null && user2!.id != currentUserId) return user2;
    return null;
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      // ✅ key thật trong function Supabase
      id: json['conversation_id'] as String? ?? json['id'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      user1: json['user1'] != null ? UserModel.fromJson(json['user1']) : null,
      user2: json['user2'] != null ? UserModel.fromJson(json['user2']) : null,
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': id,
      'created_at': createdAt?.toIso8601String(),
      'user1': user1?.toJson(),
      'user2': user2?.toJson(),
      'last_message': lastMessage?.toJson(),
    };
  }

  ConversationModel copyWithLastMessage(Map<String, dynamic> msg) {
    return ConversationModel(
      id: id,
      user1: user1,
      user2: user2,
      lastMessage: MessageModel.fromJson(msg),
      createdAt: createdAt,
    );
  }
}
