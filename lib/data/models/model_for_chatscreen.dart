enum MessageType { text, image, video }

// ignore: camel_case_types
class UserModel_chatscreen {
  final String id;
  final String name;
  final String? avatarUrl;

  const UserModel_chatscreen({required this.id, required this.name, this.avatarUrl});
}

// ignore: camel_case_types
class MessageModel_chatscreen {
  final String id;
  final String sentBy;
  final String? text;
  final String? mediaPath;
  final MessageType? mediaType;
  final DateTime createdAt;
  final MessageModel_chatscreen? replyTo; // 🆕 tin nhắn được reply

  const MessageModel_chatscreen({
    required this.id,
    required this.sentBy,
    this.text,
    this.mediaPath,
    this.mediaType,
    required this.createdAt,
    this.replyTo,
  });
}