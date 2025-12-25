import 'dart:async';
import 'dart:io';
import 'package:coach_workout/data/models/groupexerciseitem.dart';
import 'package:coach_workout/providers/group_exercise_provider.dart';
import 'package:coach_workout/screen/home_screen.dart';
import 'package:coach_workout/screen/root_screen.dart';
import 'package:coach_workout/screen/workout_library.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'animated_countdown.dart';

class WorkoutSession extends StatefulWidget {
  final String groupId;

  const WorkoutSession({super.key, required this.groupId});

  static WorkoutSession builder(BuildContext context, GoRouterState state) {
    final groupId = state.uri.queryParameters['groupId'] ?? '';
    return WorkoutSession(groupId: groupId);
  }

  @override
  State<WorkoutSession> createState() => _WorkoutSessionState();
}

class _WorkoutSessionState extends State<WorkoutSession> {
  bool showCountdown = true;
  bool isPaused = false;
  int currentIndex = 0;
  double progress = 0.0;
  int remainingSeconds = 0;
  Timer? timer;

  VideoPlayerController? _controller;
  VideoPlayerController? _nextController;

  List<GroupExerciseItem> exercises = [];

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  Future<void> _loadGroupData() async {
    final provider = Provider.of<GroupExerciseProvider>(context, listen: false);

    await provider.fetchItemGroupExercises(widget.groupId);
    final list = provider.getItemList(widget.groupId);
    final withRest = provider.insertRestItems(list);

    if (mounted) {
      setState(() {
        exercises = withRest;
      });
    }
  }

  Future<void> _initializeVideo() async {
    final current = exercises[currentIndex];
    remainingSeconds = current.durationSeconds;

    // ⛔ REST thì không load video
    if (current.exerciseId == "rest") {
      _controller = null;
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        "${dir.path}/videos/${widget.groupId}/${current.exerciseId}.mp4";
    final file = File(filePath);

    debugPrint("🎥 Play local video: $filePath");
    debugPrint("📁 Exists: ${file.existsSync()}");

    if (!file.existsSync()) {
      debugPrint("❌ Video not found, skip");
      _controller = null;
      return;
    }

    _controller = VideoPlayerController.file(file)..setLooping(true);

    await _controller!.initialize();

    if (mounted) {
      setState(() {});
    }

    /// 🔥 preload video kế tiếp (LOCAL)
    if (currentIndex + 1 < exercises.length) {
      final next = exercises[currentIndex + 1];

      if (next.exerciseId != "rest") {
        final nextPath =
            "${dir.path}/videos/${widget.groupId}/${next.exerciseId}.mp4";
        final nextFile = File(nextPath);

        if (nextFile.existsSync()) {
          _nextController = VideoPlayerController.file(nextFile);
          await _nextController!.initialize();
        }
      }
    }
  }

  void _startTimer() {
    timer?.cancel();
    final current = exercises[currentIndex];
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isPaused && mounted) {
        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
            progress =
                (current.durationSeconds - remainingSeconds) /
                current.durationSeconds;
          });
        } else {
          t.cancel();
          _switchToNext();
        }
      }
    });
  }

  Future<void> _switchToNext() async {
    timer?.cancel();
    await _controller?.pause();
    await _controller?.dispose();

    if (currentIndex + 1 >= exercises.length) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CelebrationScreen()),
      );
      return;
    }

    setState(() {
      currentIndex++;
      progress = 0.0;
      remainingSeconds = exercises[currentIndex].durationSeconds;
    });

    await _initializeVideo();
    if (exercises[currentIndex].exerciseId != "rest") {
      _controller?.play();
    }

    _startTimer();
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
      if (isPaused) {
        _controller?.pause();
      } else {
        _controller?.play();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller?.dispose();
    _nextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = exercises[currentIndex];
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: !showCountdown
          ? AppBar(
              title: Text(
                current.exerciseId == "rest"
                    ? "Rest Time 😌"
                    : "You’re doing great! 💪🔥",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => _showQuitBottomSheet(context),
              ),
            )
          : null,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (showCountdown)
            AnimatedCountdown(
              onFinish: () async {
                // countdown xong mới chạy tiếp
                setState(() => showCountdown = false);

                if (exercises.isEmpty) {
                  await _loadGroupData(); // đảm bảo có dữ liệu
                }

                if (exercises.isNotEmpty) {
                  await _initializeVideo();
                  if (exercises[currentIndex].exerciseId != "rest") {
                    _controller?.play();
                  }
                  _startTimer();
                }
              },
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔹 Video hoặc màn nghỉ
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: current.exerciseId == "rest"
                          ? Text(
                              "Rest Time 😴\nTake a deep breath!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 220,
                                child:
                                    _controller != null &&
                                        _controller!.value.isInitialized
                                    ? FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: _controller!.value.size.width,
                                          height:
                                              _controller!.value.size.height,
                                          child: VideoPlayer(_controller!),
                                        ),
                                      )
                                    : const Center(),
                              ),
                            ),
                    ),
                  ),

                  // 🔹 Info + Timer
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          current.exerciseName,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 10.0,
                          percent: progress.clamp(0.0, 1.0),
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
                      ],
                    ),
                  ),

                  // 🔹 Controls
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _controlButton(
                            Icons.skip_previous_rounded,
                            "Previous",
                            _previousVideo,
                            primary,
                          ),
                          _pauseButton(primary),
                          _controlButton(
                            Icons.skip_next_rounded,
                            "Next",
                            _switchToNext,
                            primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _previousVideo() async {
    if (currentIndex == 0) return;
    await _controller?.pause();
    await _controller?.dispose();

    setState(() => currentIndex--);
    await _initializeVideo();
    _controller?.play();
    _startTimer();
  }

  Widget _pauseButton(Color primary) => GestureDetector(
    onTap: _togglePause,
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
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutLibraryScreen(),
                    ),
                  );
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

// class celebrate
class CelebrationScreen extends StatefulWidget {
  const CelebrationScreen({super.key});

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 4));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: const Alignment(0, -0.5),
        children: [
          // 🎊 Hiệu ứng pháo giấy
          ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.09,
            numberOfParticles: 30,
            shouldLoop: true,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.yellow,
            ],
          ),

          // 🏆 Nội dung chính
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber,
                  size: 90,
                ),
                const SizedBox(height: 20),
                Text(
                  "Workout Completed!",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "You did amazing 💪🔥",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RootScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.library_books_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Back to Home",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
