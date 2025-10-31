import 'dart:io';
import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Map<String, dynamic>> posts = [
    {
      'id': 1,
      'user': 'Nguyen Hung',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'content': 'Morning workout done 💪',
      'media':
          'https://images.unsplash.com/photo-1554284126-aa88f22d8b74?w=800',
      'likes': 12,
      'isLiked': false,
      'comments': [
        {'user': 'Minh', 'text': 'Nice!', 'time': '2h ago'},
        {'user': 'Lan', 'text': 'Keep it up 💪', 'time': '1h ago'},
      ],
    },
  ];

  final ImagePicker picker = ImagePicker();

  /// ✅ Helper tránh lỗi null
  String safeUrl(String? url, {bool isAvatar = false}) {
    if (url == null || url.isEmpty) {
      return isAvatar
          ? 'https://i.pravatar.cc/150?img=1'
          : 'https://via.placeholder.com/300x200.png?text=No+Image';
    }
    return url;
  }

  void toggleLike(int index) {
    setState(() {
      posts[index]['isLiked'] = !posts[index]['isLiked'];
      posts[index]['isLiked']
          ? posts[index]['likes']++
          : posts[index]['likes']--;
    });
  }

  Future<void> showCreatePostDialog() async {
    final TextEditingController textController = TextEditingController();
    XFile? pickedFile;
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickImage(bool fromCamera) async {
              final file = await picker.pickImage(
                source: fromCamera ? ImageSource.camera : ImageSource.gallery,
                imageQuality: 75,
              );
              if (file != null) setModalState(() => pickedFile = file);
            }

            Future<void> postNow() async {
              if (textController.text.trim().isEmpty && pickedFile == null)
                return;
              setModalState(() => isLoading = true);
              await Future.delayed(const Duration(milliseconds: 400));
              setState(() {
                posts.insert(0, {
                  'id': DateTime.now().millisecondsSinceEpoch,
                  'user': 'You',
                  'avatar':
                      'https://zsqeewnrycesouhunxxk.supabase.co/storage/v1/object/public/images/10.jpg',
                  'content': textController.text.trim(),
                  'media': pickedFile?.path ?? '',
                  'likes': 0,
                  'isLiked': false,
                  'comments': [],
                });
              });
              Navigator.pop(context);
            }

            return AlertDialog(
              backgroundColor: Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Create a Post",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: textController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (pickedFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(pickedFile!.path),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => pickImage(false),
                          icon: const Icon(FontAwesomeIcons.image, size: 16),
                          label: const Text("Gallery"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => pickImage(true),
                          icon: const Icon(FontAwesomeIcons.camera, size: 16),
                          label: const Text("Camera"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.only(right: 16, bottom: 10),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : postNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Post"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showCommentsSheet(BuildContext context, int index) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        final comments =
            (posts[index]['comments'] as List?)?.cast<Map<String, dynamic>>() ??
            [];
        posts[index]['comments'] = comments;

        return StatefulBuilder(
          builder: (context, setModalState) {
            void sendComment() {
              if (controller.text.trim().isEmpty) return;
              final newCmt = {
                'user': 'You',
                'text': controller.text.trim(),
                'time': 'Just now',
                'avatar':
                    'https://zsqeewnrycesouhunxxk.supabase.co/storage/v1/object/public/images/10.jpg',
              };
              setModalState(() => comments.add(newCmt));
              setState(() {});
              controller.clear();
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: comments.length,
                      itemBuilder: (context, i) {
                        final cmt = comments[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              safeUrl(cmt['avatar'], isAvatar: true),
                            ),
                          ),
                          title: Text(
                            cmt['user'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(cmt['text']),
                          trailing: Text(
                            cmt['time'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                      left: 12,
                      right: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.blueAccent,
                          ),
                          onPressed: sendComment,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        centerTitle: true,
        title: const Text(
          "My Feed",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.3,
          ),
        ),
        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black87,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
            tooltip: "Back",
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Create Post",
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.black87,
              size: 18,
            ),
            onPressed: showCreatePostDialog,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          safeUrl(post['avatar'], isAvatar: true),
                        ),
                        radius: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          post['user'] ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.more_horiz, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post['content'] ?? '',
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  if ((post['media'] ?? '').isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: safeUrl(post['media']).startsWith('http')
                          ? Image.network(
                              safeUrl(post['media']),
                              fit: BoxFit.cover,
                            )
                          : Image.file(File(post['media']), fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => toggleLike(index),
                        child: Row(
                          children: [
                            Icon(
                              post['isLiked']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post['isLiked']
                                  ? Colors.redAccent
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${post['likes']} likes",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => showCommentsSheet(context, index),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${(post['comments'] as List?)?.length ?? 0} comments",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
