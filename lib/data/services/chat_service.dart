import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:chatview/chatview.dart';
import 'package:coach_workout/data/models/conversation_model.dart';
import 'package:coach_workout/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<List<Message>> getMessagesBetweenUsers(String conversationId) async {
    try {
      final response = await _client.rpc(
        'get_messages_between_users',
        params: {'p_conversation_id': conversationId},
      );

      if (response == null) return [];

      final List<dynamic> data = response is String
          ? jsonDecode(response)
          : response as List;

      final List<Message> messages = [];

      for (final json in data) {
        final messageId = json['message_id'] ?? '';
        final senderId = json['sender_id'] ?? '';
        final content = json['content'] ?? '';
        final createdAt =
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now();
        final replyToId = json['reply_to_id'];
        final replyContent = json['reply_content'];

        // ✅ Tự nhận diện loại tin nhắn dựa vào URL / extension
        final messageType = _detectMessageType(content);

        if (replyToId != null && replyContent != null) {
          // 🟢 Tin nhắn có reply
          messages.add(
            Message(
              id: messageId,
              message: content,
              createdAt: createdAt,
              sentBy: senderId,
              messageType: messageType,
              replyMessage: ReplyMessage(
                messageId: replyToId,
                message: replyContent,
                replyBy: senderId,
                replyTo: replyToId,
              ),
            ),
          );
        } else {
          // 🔵 Tin nhắn thường
          messages.add(
            Message(
              id: messageId,
              message: content,
              createdAt: createdAt,
              sentBy: senderId,
              messageType: messageType,
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

  /// 🔍 Hàm nhận diện loại message
  MessageType _detectMessageType(String content) {
    if (content.startsWith('http')) {
      final lower = content.toLowerCase();

      if (lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.png') ||
          lower.endsWith('.gif') ||
          lower.contains('/images/')) {
        return MessageType.image;
      }

      if (lower.endsWith('.mp3') ||
          lower.endsWith('.m4a') ||
          lower.endsWith('.wav') ||
          lower.contains('/voice/')) {
        return MessageType.voice;
      }
    }

    return MessageType.text;
  }

  /// ✉️ Gửi tin nhắn mới
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String type = 'text',
    String? replyToId,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('Chưa đăng nhập');

      await _client.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': user.id,
        'content': content,
        'reply_to_id': replyToId,
        'type': type,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (error, stack) {
      print('❌ Error sendMessage: $error');
      print(stack);
      rethrow;
    }
  }

  /// ✅ ID người dùng hiện tại
  String? get currentUserId => _client.auth.currentUser?.id;

  /// 👥 Lấy thông tin cả 2 user trong hội thoại (current + other)
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

      final currentUserModel = UserModel.fromJson(currentUserResponse);
      final otherUserModel = UserModel.fromJson(otherUserResponse);

      // 🔹 Chuyển sang ChatUserPair cho ChatView
      final chatUsers = ChatUserPair(
        currentUser: ChatUser(
          id: currentUserModel.id,
          name: 'You',
          profilePhoto: currentUserModel.avatarUrl?.isNotEmpty == true
              ? currentUserModel.avatarUrl!
              : "https://github.com/SimformSolutionsPvtLtd/chatview/blob/main/example/assets/images/simform.png?raw=true",
        ),
        otherUser: ChatUser(
          id: otherUserModel.id,
          name: (otherUserModel.name?.isNotEmpty ?? false)
              ? otherUserModel.name!
              : otherUserModel.email,
          profilePhoto: otherUserModel.avatarUrl?.isNotEmpty == true
              ? otherUserModel.avatarUrl!
              : "https://github.com/SimformSolutionsPvtLtd/chatview/blob/main/example/assets/images/simform.png?raw=true",
        ),
      );

      return chatUsers;
    } catch (error, stack) {
      print('❌ Error getChatUsers: $error');
      print(stack);
      rethrow;
    }
  }

  /// 📤 Upload media (image / voice) lên Supabase Storage
  Future<String> uploadMedia(String filePath, String bucket) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('❌ File không tồn tại: $filePath');
      }

      // 🔹 Lấy tên file và phần mở rộng
      final fileName = path.basename(file.path);
      final extension = path.extension(file.path).toLowerCase();

      // 🔹 Xác định MIME type chính xác
      String mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      // ✅ Ép kiểu MIME cho file âm thanh (voice)
      if (extension == '.m4a') mimeType = 'audio/mp4';
      if (extension == '.aac') mimeType = 'audio/aac';
      if (extension == '.mp3') mimeType = 'audio/mpeg';
      if (extension == '.wav') mimeType = 'audio/wav';

      // ✅ MIME cho ảnh (nếu cần đảm bảo)
      if (extension == '.jpg' || extension == '.jpeg') mimeType = 'image/jpeg';
      if (extension == '.png') mimeType = 'image/png';
      if (extension == '.gif') mimeType = 'image/gif';

      // 🔹 Tạo tên file duy nhất trong bucket
      final storagePath = '${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // 🧩 Upload file lên bucket tương ứng
      final res = await _client.storage
          .from(bucket)
          .upload(
            storagePath,
            file,
            fileOptions: FileOptions(contentType: mimeType, upsert: false),
          );

      if (res.isEmpty) {
        throw Exception('⚠️ Upload thất bại');
      }

      // ✅ Lấy public URL của file
      final publicUrl = _client.storage.from(bucket).getPublicUrl(storagePath);

      print('✅ Upload thành công: $publicUrl ($mimeType)');
      return publicUrl;
    } catch (e, st) {
      print('❌ Lỗi uploadMedia: $e\n$st');
      rethrow;
    }
  }
}

class ChatUserPair {
  final ChatUser currentUser;
  final ChatUser otherUser;

  ChatUserPair({required this.currentUser, required this.otherUser});
}
