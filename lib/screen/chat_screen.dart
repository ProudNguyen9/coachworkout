import 'dart:io';
import 'dart:typed_data';
import 'package:coach_workout/data/models/model_for_chatscreen.dart';
import 'package:coach_workout/data/services/chat_service.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

//////////////////////////////////////////////////////////
// 💬 MÀN HÌNH CHAT
//////////////////////////////////////////////////////////
class CustomChatScreen extends StatefulWidget {
  final String conversationId;
  const CustomChatScreen({super.key, required this.conversationId});

  @override
  State<CustomChatScreen> createState() => _CustomChatScreenState();
}

class _CustomChatScreenState extends State<CustomChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  UserModel_chatscreen? me;
  UserModel_chatscreen? other;
  final ChatService _chatService = ChatService();
  List<MessageModel_chatscreen> _messages = [];
  bool _loadingMessages = true;
  bool _loadingUsers = true;

  @override
  void initState() {
    super.initState();
    _initChatUsers();
    _loadMessages();
  }

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

      // ✅ Sau khi load xong cuộn xuống cuối
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      print('❌ Error load messages: $e');
      setState(() => _loadingMessages = false);
    }
  }

  final Color primaryColor = const Color(0xFF00B5D8);

  File? _pendingMedia;
  MessageType? _pendingType;

  // 🆕 reply logic
  MessageModel_chatscreen? _replyingTo;

  //////////////////////////////////////////////////////////
  // GỬI TIN NHẮN
  //////////////////////////////////////////////////////////
  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty && _pendingMedia == null) return;

    final msg = MessageModel_chatscreen(
      id: DateTime.now().toIso8601String(),
      sentBy: me!.id,
      text: text.isNotEmpty ? text : null,
      mediaPath: _pendingMedia?.path,
      mediaType: _pendingType,
      createdAt: DateTime.now(),
      replyTo: _replyingTo,
    );

    setState(() {
      _messages.add(msg);
      _textController.clear();
      _pendingMedia = null;
      _pendingType = null;
      _replyingTo = null;
    });

    _scrollToBottom();
  }

  //////////////////////////////////////////////////////////
  // CUỘN XUỐNG CUỐI
  //////////////////////////////////////////////////////////
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  //////////////////////////////////////////////////////////
  // CHỌN ẢNH / VIDEO / CAMERA
  //////////////////////////////////////////////////////////
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
                        _pendingType = type;
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
                        _pendingType = MessageType.image;
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

  //////////////////////////////////////////////////////////
  // HIỂN THỊ TIN NHẮN
  //////////////////////////////////////////////////////////
  Widget _buildMessage(MessageModel_chatscreen msg) {
    final isMine = msg.sentBy == me!.id;
    final bgColor = isMine ? primaryColor : Colors.grey.shade200;
    final textColor = isMine ? Colors.white : Colors.black87;
    final hasMedia = msg.mediaPath != null;
    final hasText = msg.text != null && msg.text!.isNotEmpty;

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

              // 📦 Bong bóng tin nhắn + nút reply bên phải
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 🆕 Nút reply bên phải bong bóng
                    IconButton(
                      icon: const Icon(
                        Icons.reply,
                        size: 18,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() => _replyingTo = msg);
                      },
                    ),
                    // Bong bóng
                    Flexible(
                      child: Column(
                        crossAxisAlignment: isMine
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // 🔁 Nếu là tin nhắn reply
                          if (msg.replyTo != null)
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
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      msg.replyTo!.text ??
                                          (msg.replyTo!.mediaType ==
                                                  MessageType.image
                                              ? "[Image]"
                                              : "[Video]"),
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

                          // 🖼 MEDIA
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
                                  child: msg.mediaType == MessageType.image
                                      ? Image.file(
                                          File(msg.mediaPath!),
                                          fit: BoxFit.cover,
                                        )
                                      : _VideoPlayerBubble(
                                          videoPath: msg.mediaPath!,
                                        ),
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

  //////////////////////////////////////////////////////////
  // THANH NHẬP TIN NHẮN
  //////////////////////////////////////////////////////////
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
            // 🆕 PREVIEW REPLY
            if (_replyingTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: null),
                child: Row(
                  children: [
                    Icon(
                      Icons.reply,
                      size: 18,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _replyingTo!.text ??
                            (_replyingTo!.mediaType == MessageType.image
                                ? "[Image]"
                                : "[Video]"),
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _replyingTo = null),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            // PREVIEW MEDIA
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
                    if (_pendingType == MessageType.image)
                      Image.file(
                        _pendingMedia!,
                        height: 140,
                        width: 90,
                        fit: BoxFit.cover,
                      )
                    else if (_pendingType == MessageType.video)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 140, // khung cố định
                          height: 180, // auto fit như ảnh
                          child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: 140,
                              height: 180,
                              child: _VideoPlayerBubble(
                                videoPath: _pendingMedia!.path,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _pendingMedia = null;
                          _pendingType = null;
                        }),
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

            // INPUT BAR
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: primaryColor, size: 28),
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
                        hintText: "Enter your message...",
                        border: InputBorder.none,
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
                    _sendMessage(); // Gửi tin nhắn

                    // 👇 Đóng bàn phím
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

  //////////////////////////////////////////////////////////
  // BUILD
  //////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    if (_loadingUsers) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (me == null || other == null) {
      return const Scaffold(
        body: Center(child: Text('Không tải được thông tin người dùng')),
      );
    }
    if (_loadingMessages) {
      return const Center(child: CircularProgressIndicator());
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
  final String videoPath; // Có thể là local path hoặc URL
  const _VideoPlayerBubble({required this.videoPath});

  @override
  State<_VideoPlayerBubble> createState() => _VideoPlayerBubbleState();
}

class _VideoPlayerBubbleState extends State<_VideoPlayerBubble> {
  VideoPlayerController? _controller;
  bool _isInit = false;
  bool _isDownloading = false;
  bool _needDownload = false;
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _checkAndPrepareVideo();
  }

  // =====================================================
  // 🧩 Kiểm tra đường dẫn video
  // =====================================================
  Future<void> _checkAndPrepareVideo() async {
    final isUrl =
        widget.videoPath.startsWith('http://') ||
        widget.videoPath.startsWith('https://');

    if (!isUrl) {
      // 👉 Là path local → phát luôn
      _localPath = widget.videoPath;
      await _initPlayer(_localPath!);
      return;
    }

    // 👉 Nếu là URL → kiểm tra file trong thư mục app
    final dir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(widget.videoPath);
    final localFile = File('${dir.path}/$fileName');
    _localPath = localFile.path;

    if (localFile.existsSync()) {
      // Đã tải → phát luôn
      await _initPlayer(_localPath!);
    } else {
      // Chưa có → yêu cầu tải về
      setState(() => _needDownload = true);
    }
  }

  // =====================================================
  // ⬇️ Tải video về local
  // =====================================================
  Future<void> _downloadVideo() async {
    try {
      setState(() => _isDownloading = true);
      final response = await http.get(Uri.parse(widget.videoPath));
      if (response.statusCode == 200) {
        final file = File(_localPath!);
        await file.writeAsBytes(response.bodyBytes);
        setState(() => _needDownload = false);
        await _initPlayer(_localPath!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tải video thất bại (${response.statusCode})'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi tải video: $e')));
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  // =====================================================
  // 🎬 Khởi tạo VideoPlayerController
  // =====================================================
  Future<void> _initPlayer(String path) async {
    _controller = VideoPlayerController.file(File(path));
    await _controller!.initialize();
    // ❌ KHÔNG tự động play
    setState(() => _isInit = true);
  }

  // =====================================================
  // 🧱 Giao diện
  // =====================================================
  @override
  Widget build(BuildContext context) {
    // Nếu chưa tải video (chưa có file local)
    if (_needDownload) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🩶 Nền xám giả video
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00C9FF), // xanh năng lượng
                    Color.fromARGB(255, 71, 245, 233), // xanh lá nhạt tươi
                    Color(0xFF8E2DE2), // tím mạnh
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // Hiện nút tải
            _isDownloading
                ? const CircularProgressIndicator(color: Colors.white)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 39,
                        ),
                        onPressed: _downloadVideo,
                      ),
                    ],
                  ),
          ],
        ),
      );
    }

    // Nếu video đang khởi tạo
    if (!_isInit) {
      return const SizedBox(
        width: 180,
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ Khi video đã sẵn sàng
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller!),
          IconButton(
            icon: Icon(
              _controller!.value.isPlaying
                  ? Icons.pause_circle
                  : Icons.play_circle,
              color: Colors.white,
              size: 42,
            ),
            onPressed: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
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
    _controller?.dispose();
    super.dispose();
  }
}
