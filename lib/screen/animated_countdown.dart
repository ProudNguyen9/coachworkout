import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedCountdown extends StatefulWidget {
  static AnimatedCountdown builder(BuildContext context, GoRouterState state) =>
      const AnimatedCountdown();
  const AnimatedCountdown({super.key});

  @override
  State<AnimatedCountdown> createState() => _AnimatedCountdownState();
}

class _AnimatedCountdownState extends State<AnimatedCountdown>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _introController;
  late Animation<double> _countScaleAnim;
  bool showReadyPhase = true;
  bool showGo = false;
  int currentNumber = 9;
  String currentWord = "";

  final List<String> _words = ["ARE", "YOU", "READY"];
  final List<Offset> _entryOffsets = [
    const Offset(-1.2, -1.2),
    const Offset(1.2, 1.2),
    const Offset(1.2, -1.2),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _countScaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _startIntroSequence();
  }

  /// Giới thiệu chữ "ARE YOU READY"
  Future<void> _startIntroSequence() async {
    for (int i = 0; i < _words.length; i++) {
      setState(() => currentWord = _words[i]);
      await _introController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 700));
      await _introController.reverse();
    }

    setState(() => showReadyPhase = false);
    _startCountdown();
  }

  /// Bắt đầu đếm số 9 → GO
  Future<void> _startCountdown() async {
    for (int i = 9; i >= 1; i--) {
      setState(() {
        currentNumber = i;
        showGo = false;
      });
      await _controller.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 950));
    }

    // Hiện chữ GO
    setState(() => showGo = true);
    await _controller.forward(from: 0);
    await Future.delayed(const Duration(seconds: 2));

    // 👉 Sau khi hiện "GO!" xong, tự động chuyển màn hình
    if (mounted) context.go('/main');
  }

  /// Text hiệu ứng 3D
  Widget _build3DText(String text, double fontSize, {Color? color}) {
    const baseColor = Color(0xFF00B5D8);
    final mainColor = color ?? baseColor;
    final darkShade = Colors.blueGrey.shade900;

    return Stack(
      alignment: Alignment.center,
      children: [
        // tạo chiều sâu 3D
        for (int i = 10; i >= 1; i--)
          Transform.translate(
            offset: Offset(i.toDouble(), i.toDouble()),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.anton(
                textStyle: TextStyle(
                  fontSize: fontSize,
                  color: Color.lerp(darkShade, mainColor, i / 10)!,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        // lớp trên cùng rõ nét
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.anton(
            textStyle: TextStyle(
              fontSize: fontSize,
              color: mainColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              shadows: [
                const Shadow(offset: Offset(4, 4), color: Colors.black38),
                Shadow(
                  offset: const Offset(0, 0),
                  color: Colors.cyanAccent.withOpacity(0.7),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Hiệu ứng chữ “ARE YOU READY”
  Widget _buildIntroText() {
    final index = _words.indexOf(currentWord);
    final entryOffset = _entryOffsets[index];
    final animation = CurvedAnimation(
      parent: _introController,
      curve: Curves.elasticOut,
    );

    final position = Tween<Offset>(
      begin: entryOffset,
      end: Offset.zero,
    ).animate(animation);

    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
    final scale = Tween<double>(begin: 0.3, end: 1.1).animate(animation);

    return SlideTransition(
      position: position,
      child: ScaleTransition(
        scale: scale,
        child: FadeTransition(
          opacity: opacity,
          child: _build3DText(currentWord, 122),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = showGo ? 'GO!' : currentNumber.toString();

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Stack(
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: showReadyPhase
                  ? _buildIntroText()
                  : AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final scale = _countScaleAnim.value;
                        return Transform.scale(
                          scale: scale,
                          child: _build3DText(text, showGo ? 150 : 150),
                        );
                      },
                    ),
            ),
          ),

          /// 🟦 Nút Skip cố định góc trên phải
          Positioned(
            top: 40,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                context.go('/main'); 
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _introController.dispose();
    super.dispose();
  }
}
