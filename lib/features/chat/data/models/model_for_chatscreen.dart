enum MessageType { text, image, video }

// ignore: camel_case_types
class UserModel_chatscreen {
  final String id;
  final String name;
  final String? avatarUrl;

  const UserModel_chatscreen({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}

// ignore: camel_case_types
class MessageModel_chatscreen {
  final String id;
  final String sentBy;
  final String? text;
  final String? mediaPath;
  final DateTime createdAt;

  /// ✅ replyTo giờ chỉ lưu ID của tin nhắn được reply
  final String? replyToId;

  const MessageModel_chatscreen({
    required this.id,
    required this.sentBy,
    this.text,
    this.mediaPath,
    required this.createdAt,
    this.replyToId,
  });

  /// 🧩 Parse từ Supabase record
  factory MessageModel_chatscreen.fromMap(Map<String, dynamic> map) {
    return MessageModel_chatscreen(
      id: map['id']?.toString() ?? '',
      sentBy: map['sender_id']?.toString() ?? '',
      text: map['content'],
      mediaPath: map['media_url'],
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      replyToId: map['reply_to_id']?.toString(), // ✅ chỉ parse ID
    );
  }

  /// 🔄 Convert để gửi lên Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': sentBy,
      'content': text,
      'media_url': mediaPath,
      'created_at': createdAt.toIso8601String(),
      'reply_to_id': replyToId, // ✅ gửi ID
    };
  }



  
}


