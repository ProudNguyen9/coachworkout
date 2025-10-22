import 'dart:io';
import 'dart:typed_data';
import 'package:coach_workout/data/models/model_for_chatscreen.dart';
import 'package:coach_workout/data/services/chat_service.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

// 💬 MÀN HÌNH CHAT

class CustomChatScreen extends StatefulWidget {
  final String conversationId;
  const CustomChatScreen({super.key, required this.conversationId});

  @override
  State<CustomChatScreen> createState() => _CustomChatScreenState();
}

class _CustomChatScreenState extends State<CustomChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late RealtimeChannel _messageChannel;
  UserModel_chatscreen? me;
  UserModel_chatscreen? other;
  final ChatService _chatService = ChatService();
  List<MessageModel_chatscreen> _messages = [];
  bool _loadingMessages = true;
  bool _loadingUsers = true;
  final uuid = Uuid();
  final Color primaryColor = const Color(0xFF00B5D8);
  File? _pendingMedia;
  // 🆕 reply logic
  MessageModel_chatscreen? _replyingTo;

  @override
  void initState() {
    super.initState();
    _initChatUsers();
    _loadMessages();
    _messageChannel = _chatService.listenForMessages(
      conversationId: widget.conversationId,
      onNewMessage: (msg) {
        if (!mounted) return;

        // 🛑 Tránh trùng tin nhắn đã có (ví dụ text đã add local)
        final exists = _messages.any((m) => m.id == msg.id);
        if (exists) return;

        setState(() {
          _messages.add(msg);
        });
        _scrollToBottom();
      },
    );
  }
  // ✅ Dọn dẹp channel khi rời màn hình

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _messageChannel.unsubscribe();
    super.dispose();
  }

  // init user
  Future<void> _initChatUsers() async {
    try {
      final chatUsers = await _chatService.getChatUsers(widget.conversationId);
      if (chatUsers == null) {
        setState(() => _loadingUsers = false);
        return;
      }

      setState(() {
        me = UserModel_chatscreen(
          id: chatUsers.currentUser.id,
          name: chatUsers.currentUser.name,

          avatarUrl: chatUsers.currentUser.avatarUrl,
        );

        other = UserModel_chatscreen(
          id: chatUsers.otherUser.id,
          name: chatUsers.otherUser.name,

          avatarUrl: chatUsers.otherUser.avatarUrl,
        );
        _loadingUsers = false;
      });
    } catch (e) {
      debugPrint('❌ Lỗi khi load user: $e');
      setState(() => _loadingUsers = false);
    }
  }

  // load ban dau
  Future<void> _loadMessages() async {
    try {
      setState(() => _loadingMessages = true);

      final conversationId = widget.conversationId; // 🔹 truyền ID thật vào

      final messages = await _chatService.getMessagesBetweenUsers(
        conversationId,
      );

      setState(() {
        _messages = messages;
        _loadingMessages = false;
      });

      // 👇 Cuộn sau khi frame vẽ xong (khi list đã render đủ chiều cao)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom(instant: true);
        });
      });
    } catch (e) {
      print('❌ Error load messages: $e');
      setState(() => _loadingMessages = false);
    }
  }

  // 📨 GỬI TIN NHẮN
  void _sendMessage() async {
    final text = _textController.text.trim();

    // 🚫 Nếu cả text và media đều trống
    if (text.isEmpty && _pendingMedia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tin nhắn hoặc chọn media'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 🧩 Tạo tin nhắn tạm (local)
    final msg = MessageModel_chatscreen(
      id: uuid.v4(),
      sentBy: me!.id,
      text: text.isNotEmpty ? text : null,
      mediaPath: _pendingMedia?.path,
      createdAt: DateTime.now(),
      replyToId: _replyingTo?.id,
    );

    // 🧠 Kiểm tra loại tin nhắn
    final bool isTextOnly = text.isNotEmpty && _pendingMedia == null;
    final bool isReplyTextOnly = _replyingTo != null && _pendingMedia == null;

    // ⚡ Dọn UI NGAY (reset input)
    setState(() {
      _textController.clear();
      _pendingMedia = null;
      _replyingTo = null;
    });

    // 🌀 Cuộn xuống cuối
    _scrollToBottom();

    // 🟢 Nếu chỉ text hoặc reply text thôi → add vào list luôn (không chờ server)
    if (isTextOnly || isReplyTextOnly) {
      setState(() {
        _messages.add(msg);
      });
    }

    // 🚀 Gửi tin nhắn lên server (vẫn gửi ngầm)
    try {
      await _chatService.sendMessage(
        msg: msg,
        conversationId: widget.conversationId,
      );
      print('✅ Tin nhắn đã gửi lên server');
    } catch (e) {
      print('❌ Gửi tin nhắn thất bại: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không gửi được tin nhắn')));
    }
  }

  // CUỘN XUỐNG CUỐI

  void _scrollToBottom({bool instant = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_scrollController.hasClients) return;

      // 🔁 Thử tối đa 3 lần để chắc chắn cuộn tới đáy
      for (int i = 0; i < 3; i++) {
        await Future.delayed(Duration(milliseconds: i * 150));
        final maxScroll = _scrollController.position.maxScrollExtent;

        if (instant) {
          _scrollController.jumpTo(maxScroll);
        } else {
          await _scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
          );
        }

        // nếu đã gần cuối thì break
        if ((_scrollController.position.pixels - maxScroll).abs() < 10) break;
      }
    });
  }

  void _scrollToMessage(String messageId) async {
    if (_messages.isEmpty || !_scrollController.hasClients) return;

    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index == -1) return;

    // 🧠 Đợi 1 frame để list build xong (giúp cuộn mượt, không delay tay)
    await Future.delayed(const Duration(milliseconds: 50));

    // Ước lượng chiều cao mỗi item (tuỳ bạn)
    const estimatedItemHeight = 80.0;
    final targetOffset = (index * estimatedItemHeight).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    // 🌀 Cuộn mượt tới vị trí
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // CHỌN ẢNH / VIDEO / CAMERA

  Future<void> _pickMedia() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text("Choose from Library"),
                  onTap: () async {
                    Navigator.pop(context);
                    final media = await picker.pickMedia();
                    if (media != null) {
                      final type = media.path.endsWith(".mp4")
                          ? MessageType.video
                          : MessageType.image;
                      setState(() {
                        _pendingMedia = File(media.path);
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text("Take a Photo"),
                  onTap: () async {
                    Navigator.pop(context);
                    final media = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (media != null) {
                      setState(() {
                        _pendingMedia = File(media.path);
                      });
                    }
                  },
                ),
                const Divider(height: 10, thickness: 1),
                ListTile(
                  leading: const Icon(Icons.close_rounded, color: Colors.red),
                  title: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // HIỂN THỊ TIN NHẮN

  Widget _buildMessage(MessageModel_chatscreen msg) {
    final isMine = msg.sentBy == me!.id;
    final bgColor = isMine ? primaryColor : Colors.grey.shade200;
    final textColor = isMine ? Colors.white : Colors.black87;

    final hasMedia = msg.mediaPath != null && msg.mediaPath!.isNotEmpty;
    final hasText = msg.text != null && msg.text!.isNotEmpty;

    // 🔍 Lookup tin nhắn được reply dựa vào replyToId
    final MessageModel_chatscreen? repliedMsg = (msg.replyToId != null)
        ? (_messages.where((m) => m.id == msg.replyToId).isNotEmpty
              ? _messages.firstWhere((m) => m.id == msg.replyToId)
              : null)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isMine)
                CircleAvatar(
                  backgroundImage: NetworkImage(other?.avatarUrl ?? ''),
                  radius: 14,
                ),
              if (!isMine) const SizedBox(width: 6),

              // 📦 Bong bóng tin nhắn
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 🆕 Nút reply
                    IconButton(
                      icon: const Icon(
                        Icons.reply,
                        size: 18,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _replyingTo = msg),
                    ),

                    Flexible(
                      child: Column(
                        crossAxisAlignment: isMine
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // 🔁 Reply preview (tap để scroll)
                          if (repliedMsg != null)
                            GestureDetector(
                              onTap: () => _scrollToMessage(repliedMsg.id),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6F9FC),
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 6),

                                    // 📸 Thumbnail nếu reply là media
                                    if (repliedMsg.mediaPath != null &&
                                        repliedMsg.mediaPath!.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child:
                                              repliedMsg.mediaPath!.endsWith(
                                                '.mp4',
                                              )
                                              ? const Icon(
                                                  FontAwesomeIcons.video,
                                                  size: 20,
                                                  color: Color(0xFFFFA726),
                                                )
                                              : (repliedMsg.mediaPath!
                                                        .startsWith('http')
                                                    ? Image.network(
                                                        repliedMsg.mediaPath!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(
                                                          repliedMsg.mediaPath!,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )),
                                        ),
                                      ),

                                    const SizedBox(width: 8),

                                    // 📝 Nội dung reply (text hoặc fallback)
                                    Flexible(
                                      child: Text(
                                        (repliedMsg.text != null &&
                                                repliedMsg.text!
                                                    .trim()
                                                    .isNotEmpty)
                                            ? repliedMsg.text!
                                            : (repliedMsg.mediaPath != null
                                                  ? "[Media]"
                                                  : "[Tin nhắn rỗng]"),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (msg.replyToId != null)
                            // Nếu chưa có trong _messages (ví dụ message cũ chưa load)
                            Container(
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.reply,
                                    size: 16,
                                    color: context.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Đang trả lời (id: ${msg.replyToId})",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // 🖼 MEDIA (ảnh/video)
                          if (hasMedia)
                            Padding(
                              padding: EdgeInsets.only(bottom: hasText ? 4 : 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 240,
                                    maxHeight: 320,
                                  ),
                                  child: msg.mediaPath!.endsWith('.mp4')
                                      ? _VideoPlayerBubble(
                                          videoPath: msg.mediaPath!,
                                        )
                                      : (msg.mediaPath!.startsWith('http')
                                            ? Image.network(
                                                msg.mediaPath!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(msg.mediaPath!),
                                                fit: BoxFit.cover,
                                              )),
                                ),
                              ),
                            ),

                          // 💬 TEXT
                          if (hasText)
                            Container(
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                msg.text!,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (isMine) const SizedBox(width: 6),
              if (isMine)
                CircleAvatar(
                  backgroundImage: NetworkImage(me?.avatarUrl ?? ''),
                  radius: 14,
                ),
            ],
          ),

          const SizedBox(height: 2),
          Text(
            "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // THANH NHẬP TIN NHẮN

  // 🧠 Helper nhận diện loại file
  bool _isImageFile(String path) {
    final ext = p.extension(path).toLowerCase();
    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.heic',
      '.webp',
    ].contains(ext);
  }

  bool _isVideoFile(String path) {
    final ext = p.extension(path).toLowerCase();
    return ['.mp4', '.mov', '.avi', '.mkv', '.webm'].contains(ext);
  }

  bool _isAudioFile(String path) {
    final ext = p.extension(path).toLowerCase();
    return ['.mp3', '.wav', '.aac', '.m4a', '.flac'].contains(ext);
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🧩 PREVIEW REPLY
            if (_replyingTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9FC), // nền xanh nhạt hiện đại
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade100, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.reply_rounded,
                      size: 18,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),

                    // Nếu reply có media thì hiển thị thumbnail
                    if (_replyingTo!.mediaPath != null &&
                        _replyingTo!.mediaPath!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: _isVideoFile(_replyingTo!.mediaPath!)
                              ? Container(
                                  color: Colors.blueGrey.shade100,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.videocam_rounded,
                                    size: 22,
                                    color: Colors.deepOrange,
                                  ),
                                )
                              : (_replyingTo!.mediaPath!.startsWith('http')
                                    ? Image.network(
                                        _replyingTo!.mediaPath!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_replyingTo!.mediaPath!),
                                        fit: BoxFit.cover,
                                      )),
                        ),
                      ),

                    const SizedBox(width: 8),

                    // 📝 Nội dung hoặc mô tả media
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Replying to ${_replyingTo!.sentBy == me!.id ? "your message" : (other?.name ?? "someone")}",

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            (_replyingTo!.text != null &&
                                    _replyingTo!.text!.trim().isNotEmpty)
                                ? _replyingTo!.text!
                                : (_isImageFile(_replyingTo!.mediaPath ?? '')
                                      ? "Ảnh"
                                      : _isVideoFile(
                                          _replyingTo!.mediaPath ?? '',
                                        )
                                      ? "Video"
                                      : "[Tin nhắn không có nội dung]"),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () => setState(() => _replyingTo = null),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            // 📷 PREVIEW MEDIA (local đang chọn)
            if (_pendingMedia != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    if (_isVideoFile(_pendingMedia!.path))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 140,
                          height: 180,
                          child: _VideoPlayerBubble(
                            videoPath: _pendingMedia!.path,
                          ),
                        ),
                      )
                    else if (_isImageFile(_pendingMedia!.path))
                      Image.file(
                        _pendingMedia!,
                        height: 140,
                        width: 90,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        height: 100,
                        width: 120,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Text(
                          "[Unsupported file]",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => setState(() => _pendingMedia = null),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 💬 INPUT BAR
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: context.colorScheme.primary,
                    size: 28,
                  ),
                  onPressed: _pickMedia,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        hintText: "Nhập tin nhắn...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: context.colorScheme.primary,
                  ),
                  onPressed: () {
                    _sendMessage();
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    if (_loadingUsers) {
      return Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (me == null || other == null) {
      return Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Center(child: Text('......')),
      );
    }
    if (_loadingMessages) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_loadingMessages && _messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(instant: true);
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            // Nút quay lại
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),

            // Avatar & tên
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(other?.avatarUrl ?? ''),
              ),
            ),
            const SizedBox(width: 10),

            // Tên và trạng thái
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  other!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Các nút hành động bên phải
        actions: [
          IconButton(
            icon: const Icon(Icons.call_rounded, color: Colors.white),
            onPressed: () {
              // TODO: thêm chức năng gọi thoại
            },
          ),

          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: () {
              // TODO: mở menu tùy chọn
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildMessage(_messages[i]),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }
}

class _VideoPlayerBubble extends StatefulWidget {
  final String videoPath; // URL video (http/https)
  const _VideoPlayerBubble({required this.videoPath});

  @override
  State<_VideoPlayerBubble> createState() => _VideoPlayerBubbleState();
}

class _VideoPlayerBubbleState extends State<_VideoPlayerBubble> {
  late VideoPlayerController _controller;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));
    await _controller.initialize();
    setState(() => _isInit = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      return const SizedBox(
        width: 180,
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: VideoPlayer(_controller),
          ),
          IconButton(
            icon: Icon(
              _controller.value.isPlaying
                  ? Icons.pause_circle
                  : Icons.play_circle,
              color: Colors.white,
              size: 42,
            ),
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
