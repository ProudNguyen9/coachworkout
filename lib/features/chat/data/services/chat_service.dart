import 'dart:convert';
import 'dart:io';
import 'package:coach_workout/features/chat/data/models/model_for_chatscreen.dart';
import 'package:coach_workout/features/chat/data/models/conversation_model.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart' as p;

class ChatService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _bucketName = 'images';



 /// 🔥 Lắng nghe tin nhắn mới trong 1 conversation cụ thể (realtime)
RealtimeChannel listenForMessages({
  required String conversationId,
  required void Function(MessageModel_chatscreen message) onNewMessage,
}) {
  final channel = _client.channel('messages-realtime-$conversationId');

  channel.onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'messages',
    // 👇 Dùng PostgresChangeFilter thay vì Map
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'conversation_id',
      value: conversationId,
    ),
    callback: (payload) {
      final data = payload.newRecord;
      if (data == null) return;

      try {
        final msg = MessageModel_chatscreen.fromMap(data);
        onNewMessage(msg);
      } catch (e) {
        print('❌ Lỗi parse message realtime: $e');
      }
    },
  ).subscribe();

  return channel;
}


/// 📨 Gửi tin nhắn lên Supabase (gọn – không cần type)
Future<void> sendMessage({
  required MessageModel_chatscreen msg,
  required String conversationId,
}) async {
  try {
    String? mediaUrl;

    // =============================
    // 🗂️ 1️⃣ Nếu có media thì upload
    // =============================
    if (msg.mediaPath != null && msg.mediaPath!.isNotEmpty) {
      final file = File(msg.mediaPath!);
      final ext = p.extension(msg.mediaPath!).toLowerCase();
      final fileName =
          '${msg.sentBy}_${DateTime.now().millisecondsSinceEpoch}$ext';

      // Upload lên Supabase Storage
      await _client.storage.from(_bucketName).upload('messages/$fileName', file);

      // Lấy public URL sau upload
      mediaUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl('messages/$fileName');
    }

    // =============================
    // 💾 2️⃣ Chuẩn bị dữ liệu insert
    // =============================
    final payload = {
      'id': msg.id,
      'conversation_id': conversationId,
      'sender_id': msg.sentBy,
      // chỉ lưu text thôi, media có field riêng
      'content': msg.text ?? '',
      'created_at': msg.createdAt.toIso8601String(),
      'reply_to_id': msg.replyToId,
      'media_url': mediaUrl, // ảnh/video nếu có
    };

    // =============================
    // 🚀 3️⃣ Insert lên Supabase
    // =============================
    await _client.from('messages').insert(payload);

    print('✅ Gửi tin nhắn thành công: ${msg.text ?? msg.mediaPath}');
  } catch (e, st) {
    print('❌ Lỗi khi gửi tin nhắn: $e\n$st');
    rethrow;
  }
}


  /// 🧩 Lấy danh sách hội thoại của người dùng hiện tại
  Future<List<ConversationModel>> getUserConversations() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('Chưa đăng nhập');
      final response = await _client.rpc(
        'get_user_conversations',
        params: {'p_user_id': user.id},
      );
      if (response == null) return [];
      final List<ConversationModel> conversations = (response as List)
          .map((data) => ConversationModel.fromJson(data))
          .toList();
      return conversations;
    } catch (error) {
      rethrow;
    }
  }
Future<List<MessageModel_chatscreen>> getMessagesBetweenUsers(
  String conversationId,
) async {
  try {
    final response = await _client.rpc(
      'get_messages_between_users',
      params: {'p_conversation_id': conversationId},
    );

    if (response == null) return [];

    final List<dynamic> data =
        response is String ? jsonDecode(response) : response as List;

    final messages = data.map((json) {
      final messageId = json['message_id']?.toString() ?? '';
      final senderId = json['sender_id']?.toString() ?? '';
      final content = json['content'];
      final mediaUrl = json['media_url'];
      final createdAt =
          DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now();

      final replyToId = json['reply_to_id']?.toString();

      return MessageModel_chatscreen(
        id: messageId,
        sentBy: senderId,
        text: content,
        mediaPath: mediaUrl,
        createdAt: createdAt,
        replyToId: replyToId,
      );
    }).toList();

    // 🔹 Sắp xếp theo thời gian
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return messages;
  } catch (error, stack) {
    print('❌ Error getMessagesBetweenUsers: $error');
    print(stack);
    rethrow;
  }
}




  
  /// ✅ ID người dùng hiện tại
  String? get currentUserId => _client.auth.currentUser?.id;

  /// 👥 Lấy thông tin cả 2 user trong hội thoại (UI model)
  Future<ChatUserPair?> getChatUsers(String conversationId) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('Chưa đăng nhập');

      // 🔹 Lấy user1_id và user2_id từ bảng conversations
      final conversationData = await _client
          .from('conversations')
          .select('user1_id, user2_id')
          .eq('id', conversationId)
          .maybeSingle();

      if (conversationData == null) {
        print('⚠️ Không tìm thấy hội thoại $conversationId');
        return null;
      }

      final user1Id = conversationData['user1_id'] as String?;
      final user2Id = conversationData['user2_id'] as String?;
      final otherUserId = user1Id == currentUser.id ? user2Id : user1Id;

      if (otherUserId == null) {
        print('⚠️ Không có user còn lại trong hội thoại');
        return null;
      }

      // 🔹 Lấy thông tin current user
      final currentUserResponse = await _client
          .from('users')
          .select('id, name, email, avatar_url')
          .eq('id', currentUser.id)
          .maybeSingle();

      // 🔹 Lấy thông tin người còn lại
      final otherUserResponse = await _client
          .from('users')
          .select('id, name, email, avatar_url')
          .eq('id', otherUserId)
          .maybeSingle();

      if (currentUserResponse == null || otherUserResponse == null) {
        print('⚠️ Không tìm thấy thông tin user trong hội thoại');
        return null;
      }

      // ✅ Avatar mặc định
      const defaultAvatar = "https://i.pravatar.cc/150?img=9";

      // ✅ Xử lý user hiện tại
      final currentUserModel = UserModel_chatscreen(
        id: currentUserResponse['id'] ?? '',
        name:
            (currentUserResponse['name'] != null &&
                currentUserResponse['name'].toString().trim().isNotEmpty)
            ? currentUserResponse['name']
            : currentUserResponse['email'] ?? 'Bạn',
        avatarUrl:
            (currentUserResponse['avatar_url'] != null &&
                currentUserResponse['avatar_url'].toString().isNotEmpty)
            ? currentUserResponse['avatar_url']
            : defaultAvatar,
      );

      // ✅ Xử lý user còn lại
      final otherUserModel = UserModel_chatscreen(
        id: otherUserResponse['id'] ?? '',
        name:
            (otherUserResponse['name'] != null &&
                otherUserResponse['name'].toString().trim().isNotEmpty)
            ? otherUserResponse['name']
            : otherUserResponse['email'] ?? 'Người kia',
        avatarUrl:
            (otherUserResponse['avatar_url'] != null &&
                otherUserResponse['avatar_url'].toString().isNotEmpty)
            ? otherUserResponse['avatar_url']
            : defaultAvatar,
      );

      // ✅ Gói thành cặp user cho UI
      final chatUsers = ChatUserPair(
        currentUser: currentUserModel,
        otherUser: otherUserModel,
      );

      return chatUsers;
    } catch (error, stack) {
      print('❌ Error getChatUsers: $error');
      print(stack);
      rethrow;
    }
  }




  /// 🔥 Lắng nghe mọi thay đổi tin nhắn (để update danh sách hội thoại)
RealtimeChannel listenForConversationUpdates({
  required String currentUserId,
  required void Function(Map<String, dynamic> newMessage) onMessageUpdate,
}) {
  final channel = _client.channel('messages-realtime-conversations');

  channel.onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'messages',
    callback: (payload) {
      final data = payload.newRecord;
      if (data == null) return;

      // ⚡ Chỉ quan tâm đến hội thoại có liên quan tới user hiện tại
      if (data['sender_id'] == currentUserId || data['receiver_id'] == currentUserId) {
        onMessageUpdate(data);
      }
    },
  ).subscribe();

  return channel;
}

}

class ChatUserPair {
  final UserModel_chatscreen currentUser;
  final UserModel_chatscreen otherUser;

  ChatUserPair({required this.currentUser, required this.otherUser});
}


