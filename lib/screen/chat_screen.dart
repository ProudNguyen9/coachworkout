import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'package:coach_workout/data/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  ChatController? _chatController;

  ChatUser? _currentUser;
  ChatUser? _otherUser;

  bool _isLoadingMessages = true;
  bool _isLoadingUsers = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadMessages();
  }

  /// 🧩 Load thông tin user
  Future<void> _loadUsers() async {
    try {
      final chatUsers = await _chatService.getChatUsers(widget.conversationId);
      if (chatUsers != null) {
        setState(() {
          _currentUser = chatUsers.currentUser;
          _otherUser = chatUsers.otherUser;
          _isLoadingUsers = false;
        });
      }
    } catch (error) {
      debugPrint('❌ Lỗi load user: $error');
    }
  }

  /// 💬 Load tin nhắn
  Future<void> _loadMessages() async {
    try {
      final messages = await _chatService.getMessagesBetweenUsers(
        widget.conversationId,
      );

      if (_currentUser == null) {
        // tránh null khi messages load nhanh hơn users
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return _isLoadingUsers;
        });
      }

      setState(() {
        _chatController = ChatController(
          currentUser:
              _currentUser ??
              const ChatUser(id: 'temp', name: 'You', profilePhoto: ''),
          otherUsers: _otherUser != null ? [_otherUser!] : [],
          initialMessageList: messages,
          scrollController: ScrollController(),
        );
        _isLoadingMessages = false;
      });
    } catch (error) {
      debugPrint('❌ Lỗi load message: $error');
    }
  }

  /// 📤 Gửi tin nhắn
  Future<void> _onSendTap(
    String message,
    ReplyMessage reply,
    MessageType type,
  ) async {
    if (_chatController == null || _currentUser == null) return;

    try {
      String content = message;
      String msgType = 'text';

      // 🔹 Nếu là ảnh hoặc voice thì upload file trước
      if (type == MessageType.image || type == MessageType.voice) {
        String folder = type == MessageType.image ? 'images' : 'voice';

        // Upload lên server (VD: Supabase) và lấy public URL
        final publicUrl = await _chatService.uploadMedia(message, folder);

        // Dùng URL thay cho path cục bộ
        content = Uri.encodeFull(publicUrl);
        msgType = type.name;
      }

      // 🔹 Tạo tin nhắn hiển thị ngay trên UI
      final newMessage = Message(
        id: DateTime.now().toIso8601String(),
        createdAt: DateTime.now(),
        message: content,
        sentBy: _currentUser!.id,
        messageType: type,
        replyMessage: reply,
      );

      _chatController!.addMessage(newMessage);

      // 🔹 Gửi thật lên Supabase / server
      await _chatService.sendMessage(
        conversationId: widget.conversationId,
        content: content,
        replyToId: reply.messageId.isNotEmpty ? reply.messageId : null,
        type: msgType,
      );
    } catch (e, st) {
      debugPrint('❌ Lỗi khi gửi tin nhắn: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ChatViewAppBar(
            profilePicture:
                _otherUser?.profilePhoto ?? 'assets/default_user.png',
            chatTitle: _otherUser?.name ?? '',
            userStatus: 'Online',
            backGroundColor: primaryColor,
            chatTitleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            userStatusTextStyle: const TextStyle(color: Colors.white70),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          // 🔹 ChatView luôn hiển thị (khi đang load thì rỗng)
          Expanded(
            child: ChatView(
              chatController:
                  _chatController ??
                  ChatController(
                    currentUser: const ChatUser(
                      id: 'temp',
                      name: 'You',
                      profilePhoto: '',
                    ),
                    otherUsers: const [],
                    initialMessageList: const [],
                    scrollController: ScrollController(),
                  ),
              onSendTap: _isLoadingMessages ? null : _onSendTap,
              chatViewState: _isLoadingMessages
                  ? ChatViewState.loading
                  : ChatViewState.hasMessages,
              featureActiveConfig: const FeatureActiveConfig(
                enableSwipeToReply: true,
              ),
              sendMessageConfig: const SendMessageConfiguration(
                allowRecordingVoice: false,
                enableCameraImagePicker: true,
                textFieldConfig: TextFieldConfiguration(
                  hintText: 'Write something...',
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              chatBackgroundConfig: const ChatBackgroundConfiguration(
                backgroundColor: Colors.white,
              ),
              chatBubbleConfig: ChatBubbleConfiguration(
                outgoingChatBubbleConfig: ChatBubble(
                  color: primaryColor,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                inComingChatBubbleConfig: const ChatBubble(
                  color: Color(0xfff0f0f0),
                  textStyle: TextStyle(color: Colors.black87, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
