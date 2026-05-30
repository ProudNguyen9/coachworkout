class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  final DateTime? createdAt;
  final String? replyToId;
  final String? type;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    this.createdAt,
    this.replyToId,
    this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'],
        conversationId: json['conversation_id'],
        senderId: json['sender_id'],
        content: json['content'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        replyToId: json['reply_to_id'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'content': content,
        'created_at': createdAt?.toIso8601String(),
        'reply_to_id': replyToId,
        'type': type,
      };
}


