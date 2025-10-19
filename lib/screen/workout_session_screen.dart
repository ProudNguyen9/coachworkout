import 'dart:async';
import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WorkoutSession extends StatefulWidget {
  static WorkoutSession builder(BuildContext context, GoRouterState state) =>
      const WorkoutSession();

  const WorkoutSession({super.key});

  @override
  State<WorkoutSession> createState() => _WorkoutSessionState();
}

class _WorkoutSessionState extends State<WorkoutSession> {
  int totalSeconds = 30;
  int remainingSeconds = 30;
  bool isPaused = false;
  double progress = 0.0;
  Timer? timer;

  // 🔹 Giả lập thông tin bài tập
  final int currentExercise = 1;
  final int totalExercises = 10;
  final String exerciseName = "Jumping Jacks";
  final String exerciseImage = "assets/tip1.jpg";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isPaused) {
        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
            progress = (totalSeconds - remainingSeconds) / totalSeconds;
          });
        } else {
          t.cancel();
          context.go('/next-exercise');
        }
      }
    });
  }

  void togglePause() {
    setState(() => isPaused = !isPaused);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          "Exercise $currentExercise/$totalExercises",
          style: GoogleFonts.poppins(
            fontSize: 20, // 🔹 chữ to hơn
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.black87),
            onPressed: () {
              _showQuitBottomSheet(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 Hình ảnh bài tập
            Expanded(
              flex: 4,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    exerciseImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),

            // 🔹 Thông tin bài tập + đồng hồ
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Keep Going!",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exerciseName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 Vòng tròn tiến trình
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, _) => CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 10.0,
                      percent: value.clamp(0.0, 1.0),
                      center: Text(
                        "$remainingSeconds",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      progressColor: primary,
                      backgroundColor: primary.withOpacity(0.2),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Nút điều khiển
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _controlButton(Icons.skip_previous_rounded, "Previous", () {
                      // TODO: Quay lại bài trước
                    }, primary),
                    _pauseButton(primary),
                    _controlButton(Icons.skip_next_rounded, "Skip", () {
                      timer?.cancel();
                      context.go('/next-exercise');
                    }, primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Nút pause/play giữa
  Widget _pauseButton(Color primary) {
    return GestureDetector(
      onTap: togglePause,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary.withOpacity(0.1),
        ),
        child: Icon(
          isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          color: primary,
          size: 38,
        ),
      ),
    );
  }

  // 🔹 Nút Previous / Skip
  Widget _controlButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    Color primary,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: primary, size: 28),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

void _showQuitBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/emotionbad.png',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Text(
              "Are you sure you want to\nQuit Exercise?",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 28),

            // 🔹 Nút Quit
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // ✅ Ví dụ: quay về Home
                  // timer?.cancel();
                  // context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Quit",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Nút Close
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Close",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
