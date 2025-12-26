import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/chat_service.dart';
import '../../data/models/conversation_model.dart';
import 'screens.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _searchController = TextEditingController();

  List<ConversationModel> _conversations = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  RealtimeChannel? _conversationChannel; // 👈 Thêm realtime channel

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _setupRealtime(); // 👈 Thêm phần này
  }

  @override
  void dispose() {
    _conversationChannel?.unsubscribe(); // 👈 huỷ khi thoát màn
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    try {
      final data = await _chatService.getUserConversations();
      setState(() {
        _conversations = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading conversations: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    await _loadConversations();
    setState(() => _isRefreshing = false);
  }

  /// 🔥 Lắng nghe thay đổi từ bảng messages (realtime)
  void _setupRealtime() {
    final currentUserId = _chatService.currentUserId;
    if (currentUserId == null) return;

    _conversationChannel = _chatService.listenForConversationUpdates(
      currentUserId: currentUserId,
      onMessageUpdate: (msg) async {
        final conversationId = msg['conversation_id'];
        if (conversationId == null) return;

        // 🔎 Tìm hội thoại có sẵn
        final index = _conversations.indexWhere((c) => c.id == conversationId);

        if (index != -1) {
          // 🔄 Cập nhật last message ngay
          final updatedConv = _conversations[index].copyWithLastMessage(msg);
          setState(() {
            _conversations.removeAt(index);
            _conversations.insert(0, updatedConv);
          });
        } else {
          // 🆕 Nếu là hội thoại mới, reload toàn bộ danh sách
          await _loadConversations();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'chat.messages'.tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.3,
        surfaceTintColor: Colors.white,
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 🔍 Search bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: TextField(
                  controller: _searchController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'chat.search_conversation'.tr(),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 💬 Conversation list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  color: primary,
                  child: _conversations.isEmpty
                      ? Center(
                          child: Text(
                            'chat.no_conversations'.tr(),
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          itemCount: _conversations.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            indent: 70,
                            endIndent: 10,
                            color: Colors.grey,
                          ),
                          itemBuilder: (context, index) {
                            final c = _conversations[index];
                            final currentId = _chatService.currentUserId;
                            final partner = currentId == c.user1?.id
                                ? c.user2
                                : c.user1;

                            final displayName =
                                partner?.name ??
                                partner?.email ??
                                'chat.user'.tr();

                            final avatarUrl = partner?.avatarUrl ?? '';
                            final lastMessage =
                                c.lastMessage?.content ??
                                'chat.no_conversations'.tr();

                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomChatScreen(conversationId: c.id),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 6,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundImage:
                                          const AssetImage(
                                                'assets/icons/avatar.jpg',
                                              )
                                              as ImageProvider,
                                    ),

                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            lastMessage,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (c.lastMessage != null)
                                      Text(
                                        _formatTime(c.lastMessage!.createdAt),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),

          // 🔄 Overlay loading khi vào màn hình lần đầu
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.white70,
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'chat.time.just_now'.tr();
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${'chat.time.minute'.tr()}';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours} ${'chat.time.hour'.tr()}';
    }

    return '${time.day}/${time.month}';
  }
}
