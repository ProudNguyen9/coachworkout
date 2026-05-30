// =====================================================
// 🧩 COACH AI CHAT SCREEN - GEMINI 2.5 FLASH FIXED
// =====================================================
// ✅ UI MODERNIZED: Material 3, gradients, smooth animations, modern bubbles, avatars
// ✅ DebugPrint đã tắt ở hàm _callGeminiAPIWithRetry
// ✅ Tắt debug banner (DEBUG đỏ góc trên phải): debugShowCheckedModeBanner: false
// ✅ Đổi màu primary: Color(0xFF26C6DA) - Cyan hiện đại

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart'; // Thêm dependency: lottie: ^3.1.2 cho animation loading

class CustomChatScreenAI extends StatefulWidget {
  const CustomChatScreenAI({super.key});

  @override
  State<CustomChatScreenAI> createState() => _CustomChatScreenAIState();
}

class _CustomChatScreenAIState extends State<CustomChatScreenAI>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final uuid = const Uuid();

  List<Map<String, dynamic>> messages = [];
  File? selectedImage;
  bool isLoading = false;
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;

  // ==============================
  // 🔹 API Config
  // ==============================
  String poseUrl = "http://192.168.2.9:8000/analyze_pose";

  final String supabaseUrl = "https://zsqeewnrycesouhunxxk.supabase.co";
  final String supabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzcWVld25yeWNlc291aHVueHhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA3Mjc2NDMsImV4cCI6MjA3NjMwMzY0M30.NT9XbVC0astMhOuqxZtqv03Nh4t3c1eV2uo6b0AY5Wg";
  final String supabaseBucket = "AIserver";

  // ==============================
  // 🔹 Gemini API Config
  // ==============================
  final String geminiKeyFallback = "AIzaSyD2a9ILxxmHspCw57Wrbl_DbRG5wS471wo";
  String geminiKeyText = ""; // Thêm key mới của bạn ở đây!

  final List<String> geminiModels = ["gemini-2.5-flash", "gemini-2.5-pro"];

  // Modern Color Palette (Cyan-inspired: Light Cyan, Blue, White)
  static const Color primaryColor = Color(0xFF26C6DA); // Cyan mới cho fitness
  static const Color secondaryColor = Color(
    0xFF2196F3,
  ); // Blue accent (giữ nguyên)
  static const Color surfaceColor = Color(0xFFF8F9FA);
  static const Color errorColor = Color(0xFFE57373);

  @override
  void initState() {
    super.initState();
    _loadPoseUrl();
    _typingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );
    _typingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  // ==============================
  // 🔹 Load/Save IP
  // ==============================
  Future<void> _loadPoseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      poseUrl =
          prefs.getString('pose_url') ?? "http://192.168.2.9:8000/analyze_pose";
    });
  }

  Future<void> _savePoseUrl(String newUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pose_url', newUrl);
    setState(() {
      poseUrl = newUrl;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Đã cập nhật địa chỉ IP!'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showSettingsDialog() {
    final controller = TextEditingController(text: poseUrl);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.settings, color: primaryColor),
            SizedBox(width: 10),
            Text('Cài đặt IP', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'http://192.168.1.100:8000/analyze_pose',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: const Icon(Icons.link),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              final newUrl = controller.text.trim();
              if (newUrl.isNotEmpty) {
                _savePoseUrl(newUrl);
              }
              Navigator.pop(context);
            },
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // 🔹 Gửi tin nhắn (giữ nguyên logic)
  // =====================================================
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();

    if (text.isEmpty && selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nhập tin nhắn hoặc chọn ảnh!'),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      messages.add({
        "id": uuid.v4(),
        "sender": "me",
        "text": text.isNotEmpty ? text : null,
        "image": selectedImage?.path,
        "timestamp": DateTime.now(),
      });
      _textController.clear();
      isLoading = selectedImage != null;
    });
    _scrollToBottom();

    try {
      if (selectedImage == null) {
        setState(() {
          messages.add({
            "id": uuid.v4(),
            "sender": "ai",
            "text": "⏳ Đang phản hồi...",
            "timestamp": DateTime.now(),
          });
        });
        final reply = await _callGeminiAPIWithRetry(text);
        setState(() {
          messages.removeWhere(
            (m) => m["text"]?.toString().contains("Đang phản hồi") ?? false,
          );
          messages.add({
            "id": uuid.v4(),
            "sender": "ai",
            "text": reply,
            "timestamp": DateTime.now(),
          });
        });
      } else {
        setState(() {
          messages.add({
            "id": uuid.v4(),
            "sender": "ai",
            "text": "🧠 Đang phân tích ảnh...",
            "timestamp": DateTime.now(),
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
            "timestamp": DateTime.now(),
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Lỗi AI: $e"), backgroundColor: errorColor),
      );
    } finally {
      setState(() {
        isLoading = false;
        selectedImage = null;
      });
      _scrollToBottom();
    }
  }

  // =====================================================
  // 🔹 Gemini API (giữ nguyên, nhưng ràng buộc chặt hơn)
  // =====================================================
  Future<String> _callGeminiAPIWithRetry(String prompt) async {
    final activeKey = geminiKeyText.isNotEmpty
        ? geminiKeyText
        : geminiKeyFallback;

    for (final model in geminiModels) {
      try {
        final result = await _callGeminiAPI(prompt, model, activeKey);
        if (result.isNotEmpty) return result;
      } catch (e) {
        // Đã tắt debugPrint - Không in log lỗi model nữa
        if (e.toString().contains("404") ||
            e.toString().contains("429") ||
            e.toString().contains("503")) {
          await Future.delayed(const Duration(seconds: 1));
          continue;
        } else {
          rethrow;
        }
      }
    }
    throw Exception("🚫 Tất cả model Gemini đều lỗi hoặc quá tải!");
  }

  Future<String> _callGeminiAPI(
    String prompt,
    String model,
    String apiKey,
  ) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey";

    final wrappedPrompt =
        '''
Bạn là một huấn luyện viên cá nhân (Coach AI) CHUYÊN SÂU.

🚫 RÀNG BUỘC NGHIÊM NGẶT: CHỈ trả lời nếu câu hỏi HOÀN TOÀN LIÊN QUAN đến MỘT trong các chủ đề sau:
1. Gym, thể hình, fitness (tập tạ, bài tập cơ bắp cụ thể)
2. Yoga, pilates, giãn cơ, thiền (tư thế, chuỗi bài)
3. Dinh dưỡng, chế độ ăn, meal plan (calo, macro, công thức ăn)
4. Phục hồi chấn thương, đau cơ, phục hồi sau tập (bài tập rehab, nghỉ ngơi)
5. Giảm cân, tăng cơ, cardio, sức bền (kế hoạch tập luyện, theo dõi tiến độ)

Nếu câu hỏi KHÔNG TRỰC TIẾP liên quan ĐẾN BẤT KỲ chủ đề nào ở trên (ví dụ: thời tiết, công nghệ, chuyện cá nhân, y tế chung), HÃY TỪ CHỐI NGAY LẬP TỨC với câu trả lời ĐÚNG NGẮN GỌN:
"Tôi chỉ hỗ trợ chuyên sâu về gym, fitness, yoga, dinh dưỡng và phục hồi. Hãy hỏi về những chủ đề đó nhé! 💪"

Yêu cầu BẮT BUỘC:
- Trả lời SIÊU NGẮN GỌN: Tối đa 150 từ, tập trung vào LỢI ÍCH + HÀNH ĐỘNG CỤ THỂ.
- KHÔNG dùng emoji trừ khi minh họa bài tập (tối đa 1-2).
- KHÔNG lan man, không giới thiệu bản thân, không hỏi ngược.
- Dùng ngôn ngữ đơn giản, dễ hiểu cho người mới.

Câu hỏi người dùng: $prompt
''';

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": wrappedPrompt},
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
  // 🔹 Upload & Pose API (giữ nguyên)
  // =====================================================
  Future<String> _uploadToSupabase(File file) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}";
    final ext = p.extension(file.path).toLowerCase();
    String mimeType = "image/jpeg";
    if (ext == ".png") mimeType = "image/png";

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
  // 🔹 UI Helpers (Cải thiện)
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
                      ? Image.network(imageUrl, fit: BoxFit.contain)
                      : Image.file(File(imageUrl), fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return TimeOfDay.fromDateTime(time).format(context);
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isMine = msg["sender"] == "me";
    final isImage = msg["image"] != null;
    final text = msg["text"];
    final timestamp = msg["timestamp"] as DateTime?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            // AI Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.fitness_center,
                color: primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (isImage)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GestureDetector(
                        onTap: () => _showFullImage(msg["image"]),
                        child: msg["image"].toString().startsWith("http")
                            ? Image.network(
                                msg["image"],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 200,
                                        height: 200,
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                              )
                            : Image.file(
                                File(msg["image"]),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                if (text != null)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMine ? secondaryColor : surfaceColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMine ? 20 : 4),
                        bottomRight: Radius.circular(isMine ? 4 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isMine ? secondaryColor : surfaceColor)
                              .withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isMine ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (timestamp != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatTime(timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isMine) ...[
            const SizedBox(width: 8),
            // User Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: secondaryColor.withOpacity(0.1),
              child: const Icon(Icons.person, color: secondaryColor, size: 24),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor.withOpacity(0.1),
            child: const Icon(
              Icons.fitness_center,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: surfaceColor.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Lottie.asset(
                      'assets/typing.json', // Nếu chưa có, thay bằng CircularProgressIndicator()
                      controller: _typingController,
                      onLoaded: (composition) {
                        _typingController.duration = composition.duration;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Đang suy nghĩ...',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Image Picker with modern icon
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.image_outlined, color: primaryColor),
                onPressed: _pickImage,
                style: IconButton.styleFrom(
                  backgroundColor: surfaceColor,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Text Field with modern style
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _textController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: "Hỏi Coach AI về fitness, yoga, dinh dưỡng...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send Button with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color:
                    _textController.text.trim().isNotEmpty ||
                        selectedImage != null
                    ? primaryColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed:
                    (_textController.text.trim().isNotEmpty ||
                        selectedImage != null)
                    ? _sendMessage
                    : null,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (selectedImage == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.all(8),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.file(
              selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => setState(() => selectedImage = null),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // 🧠 Build UI (Modernized)
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // ✅ Tắt debug banner (DEBUG đỏ góc trên phải)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
      ),
      home: Scaffold(
        backgroundColor: surfaceColor,
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/4712/4712109.png",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Coach AI",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                 
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: _showSettingsDialog,
              tooltip: 'Cài đặt',
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: messages.length,
                itemBuilder: (_, i) {
                  final msg = messages[i];
                  if (msg["sender"] == "ai" &&
                      msg["text"]?.toString().contains("Đang phản hồi") ==
                          true) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessage(msg);
                },
              ),
            ),
            _buildImagePreview(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }
}


