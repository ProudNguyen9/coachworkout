class MessageModel {
  final String messageId;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final String? replyToId;
  final String? replyContent;
  final DateTime createdAt;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    this.replyToId,
    this.replyContent,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderName: json['sender_name'],
      senderAvatar: json['sender_avatar'],
      content: json['content'] ?? '',
      replyToId: json['reply_to_id'],
      replyContent: json['reply_content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'sender_name': senderName,
        'sender_avatar': senderAvatar,
        'content': content,
        'reply_to_id': replyToId,
        'reply_content': replyContent,
        'created_at': createdAt.toIso8601String(),
      };
}
