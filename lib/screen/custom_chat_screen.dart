// =====================================================
// 🧩 COACH AI CHAT SCREEN - FIX GEMINI API STABLE
// =====================================================

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class CustomChatScreenAI extends StatefulWidget {
  const CustomChatScreenAI({super.key});

  @override
  State<CustomChatScreenAI> createState() => _CustomChatScreenAIState();
}

class _CustomChatScreenAIState extends State<CustomChatScreenAI> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final uuid = const Uuid();

  List<Map<String, dynamic>> messages = [];
  File? selectedImage;
  bool isLoading = false;

  // API endpoints
  final String poseUrl = "http://192.168.2.9:8000/analyze_pose";

  // Supabase config
  final String supabaseUrl = "https://zsqeewnrycesouhunxxk.supabase.co";
  final String supabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzcWVld25yeWNlc291aHVueHhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA3Mjc2NDMsImV4cCI6MjA3NjMwMzY0M30.NT9XbVC0astMhOuqxZtqv03Nh4t3c1eV2uo6b0AY5Wg";
  final String supabaseBucket = "AIserver";

  // Gemini API (tự động fallback nếu lỗi)
  final String geminiKey = "AIzaSyD2a9ILxxmHspCw57Wrbl_DbRG5wS471wo";
  final List<String> geminiModels = [
    "gemini-2.0-flash-001",
    "gemini-1.5-flash",
    "gemini-1.5-pro",
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Gửi tin nhắn
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();

    if (text.isEmpty && selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập tin nhắn hoặc chọn ảnh!')),
      );
      return;
    }

    setState(() {
      messages.add({
        "id": uuid.v4(),
        "sender": "me",
        "text": text.isNotEmpty ? text : null,
        "image": selectedImage?.path,
      });
      _textController.clear();
      isLoading = selectedImage != null;
    });
    _scrollToBottom();

    try {
      if (selectedImage == null) {
        // 🧠 Gọi Gemini API khi chỉ có text
        setState(() {
          messages.add({
            "id": uuid.v4(),
            "sender": "ai",
            "text": "⏳ Đang phản hồi...",
          });
        });

        final reply = await _callGeminiAPIWithRetry(text);

        setState(() {
          messages.removeWhere(
            (m) => m["text"]?.toString().contains("Đang phản hồi") ?? false,
          );
          messages.add({"id": uuid.v4(), "sender": "ai", "text": reply});
        });
      } else {
        // 🖼 Nếu có ảnh → gọi pose API
        setState(() {
          messages.add({
            "id": uuid.v4(),
            "sender": "ai",
            "text": "🧠 Đang phân tích...",
          });
        });

        final imageUrl = await _uploadToSupabase(selectedImage!);
        final result = await _callPoseAPI(imageUrl, text);

        final feedback = result['feedback'] ?? "Không có phản hồi.";
        final wrongJoints =
            (result['wrong_joints'] as List?)?.join(", ") ??
            "Không phát hiện lỗi.";
        final aiImage = result['image_url'];

        setState(() {
          messages.removeWhere(
            (m) => m["text"]?.toString().contains("Đang phân tích") ?? false,
          );
          messages.add({
            "id": uuid.v4(),
            "sender": "ai",
            "text": "$feedback\n\n❌ Sai khớp: $wrongJoints",
            "image": aiImage,
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("⚠️ Lỗi AI: $e")));
    } finally {
      setState(() {
        isLoading = false;
        selectedImage = null;
      });
      _scrollToBottom();
    }
  }

  // =====================================================
  // 🔹 Gọi Gemini API với retry + fallback tự động
  // =====================================================
  Future<String> _callGeminiAPIWithRetry(String prompt) async {
    for (final model in geminiModels) {
      try {
        final result = await _callGeminiAPI(prompt, model);
        if (result.isNotEmpty) return result;
      } catch (e) {
        debugPrint("⚠️ Lỗi model $model: $e");
        if (e.toString().contains("429") || e.toString().contains("503")) {
          await Future.delayed(const Duration(seconds: 2));
          continue; // thử model khác
        } else {
          rethrow;
        }
      }
    }
    throw Exception("Tất cả model Gemini đều đang quá tải, thử lại sau!");
  }

  // =====================================================
  // 🔸 Hàm gọi Gemini API trực tiếp
  // =====================================================
  Future<String> _callGeminiAPI(String prompt, String model) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$geminiKey";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
          "Không có phản hồi từ Gemini.";
    } else {
      throw Exception(
        "Gemini API lỗi ${response.statusCode}: ${response.body}",
      );
    }
  }

  // =====================================================
  // 🔹 Upload Supabase
  // =====================================================
  Future<String> _uploadToSupabase(File file) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}";
    final ext = p.extension(file.path).toLowerCase();
    String mimeType = "image/jpeg";
    if (ext == ".png") mimeType = "image/png";
    if (ext == ".heic") mimeType = "image/heic";

    final url = Uri.parse(
      "$supabaseUrl/storage/v1/object/$supabaseBucket/$fileName",
    );

    final res = await http.put(
      url,
      headers: {
        "apikey": supabaseKey,
        "Authorization": "Bearer $supabaseKey",
        "Content-Type": mimeType,
      },
      body: await file.readAsBytes(),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return "$supabaseUrl/storage/v1/object/public/$supabaseBucket/$fileName";
    } else {
      throw Exception("Upload Supabase lỗi: ${res.statusCode} - ${res.body}");
    }
  }

  // =====================================================
  // 🔹 Gọi Pose API
  // =====================================================
  Future<Map<String, dynamic>> _callPoseAPI(
    String imageUrl,
    String prompt,
  ) async {
    final res = await http.post(
      Uri.parse(poseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "image_url": imageUrl,
        "childrequest": prompt.isEmpty ? "Phân tích tư thế." : prompt,
      }),
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Pose API lỗi ${res.statusCode}: ${res.body}");
    }
  }

  // =====================================================
  // 🔹 UI Helpers
  // =====================================================
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => selectedImage = File(img.path));
  }

  void _showFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: imageUrl.startsWith("http")
                      ? Image.network(imageUrl)
                      : Image.file(File(imageUrl)),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isMine = msg["sender"] == "me";
    final bg = isMine ? Colors.blue : Colors.grey.shade200;
    final color = isMine ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (msg["image"] != null)
            GestureDetector(
              onTap: () => _showFullImage(msg["image"]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: msg["image"].toString().startsWith("http")
                    ? Image.network(msg["image"], width: 220)
                    : Image.file(File(msg["image"]), width: 220),
              ),
            ),
          if (msg["text"] != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(msg["text"], style: TextStyle(color: color)),
            ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.image), onPressed: _pickImage),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    hintText: "Type your message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: isLoading ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // 🧠 Build chính
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFEAF3FF),
              backgroundImage: NetworkImage(
                "https://cdn-icons-png.flaticon.com/512/4712/4712109.png",
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Coach AI",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "online • ready to assist",
                  style: TextStyle(color: Colors.green, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (_, i) => _buildMessage(messages[i]),
            ),
          ),
          if (selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(selectedImage!, height: 120),
                  if (isLoading)
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 10),
                        Text(
                          "Đang phân tích...",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  if (!isLoading)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() => selectedImage = null),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          _buildInputBar(),
        ],
      ),
    );
  }
}
