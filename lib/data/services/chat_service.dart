import 'dart:convert';
import 'package:coach_workout/data/models/model_for_chatscreen.dart';
import 'package:coach_workout/data/models/conversation_model.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class ChatService {
  final SupabaseClient _client = Supabase.instance.client;

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

      final List<dynamic> data = response is String
          ? jsonDecode(response)
          : response as List;

      final List<MessageModel_chatscreen> messages = [];

      for (final json in data) {
        final messageId = json['message_id'] ?? '';
        final senderId = json['sender_id'] ?? '';
        final content = json['content'] ?? '';
        final createdAt =
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now();
        final replyToId = json['reply_to_id'];
        final replyContent = json['reply_content'];

        // ✅ Nhận diện loại tin nhắn
        final messageType = _detectMessageType(content);

        if (replyToId != null && replyContent != null) {
          // 🟢 Tin nhắn có reply
          messages.add(
            MessageModel_chatscreen(
              id: messageId,
              sentBy: senderId,
              text: (messageType == MessageType.text) ? content : null,
              mediaPath:
                  (messageType == MessageType.image ||
                      messageType == MessageType.video)
                  ? content
                  : null,
              mediaType: messageType,
              createdAt: createdAt,
              replyTo: MessageModel_chatscreen(
                id: replyToId,
                sentBy: senderId,
                text: replyContent,
                createdAt: createdAt,
                mediaPath: null,
                mediaType: MessageType.text,
              ),
            ),
          );
        } else {
          // 🔵 Tin nhắn thường
          messages.add(
            MessageModel_chatscreen(
              id: messageId,
              sentBy: senderId,
              text: (messageType == MessageType.text) ? content : null,
              mediaPath:
                  (messageType == MessageType.image ||
                      messageType == MessageType.video)
                  ? content
                  : null,
              mediaType: messageType,
              createdAt: createdAt,
            ),
          );
        }
      }

      // 🔹 Sắp xếp theo thời gian tăng dần
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      return messages;
    } catch (error, stack) {
      print('❌ Error getMessagesBetweenUsers: $error');
      print(stack);
      rethrow;
    }
  }

  /// 🔍 Hàm nhận diện loại message (image / video / text)
  MessageType _detectMessageType(String content) {
    try {
      final lower = content.toLowerCase();

      // 1) Nếu server trả về mimeType cho URL -> dùng nó
      final mimeType = lookupMimeType(content) ?? '';

      if (mimeType.isNotEmpty) {
        if (mimeType.startsWith('image/')) return MessageType.image;
        if (mimeType.startsWith('video/')) return MessageType.video;
        // nếu là audio thì fallback về text (enum hiện tại không có audio)
        if (mimeType.startsWith('audio/')) return MessageType.text;
      }

      // 2) Nếu không có mime, kiểm tra extension như fallback
      final ext = path.extension(content).toLowerCase();
      const imageExt = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
      const videoExt = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.3gp'];

      if (imageExt.contains(ext) ||
          lower.contains('/images/') ||
          lower.contains('/image/')) {
        return MessageType.image;
      }

      if (videoExt.contains(ext) ||
          lower.contains('/videos/') ||
          lower.contains('/video/')) {
        return MessageType.video;
      }
    } catch (e) {
      // nếu có lỗi, trả về text làm mặc định
      print('⚠️ _detectMessageType error: $e');
    }

    return MessageType.text;
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
}

class ChatUserPair {
  final UserModel_chatscreen currentUser;
  final UserModel_chatscreen otherUser;

  ChatUserPair({required this.currentUser, required this.otherUser});
}
