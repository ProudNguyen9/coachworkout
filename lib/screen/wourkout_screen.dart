import 'dart:io';

import 'package:coach_workout/data/services/supabase_service.dart';
import 'package:coach_workout/providers/group_exercise_provider.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'screens.dart';

class WorkoutScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const WorkoutScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  static WorkoutScreen builder(BuildContext context, GoRouterState state) {
    final groupId = state.uri.queryParameters['id'] ?? '';
    final groupName = state.uri.queryParameters['name'] ?? 'Workout';
    return WorkoutScreen(groupId: groupId, groupName: groupName);
  }

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool isDownloading = false;
  bool downloadCompleted = false;

  int totalVideos = 0;
  int downloadedVideos = 0;

  Future<void> _downloadAllVideos(List items) async {
    if (items.isEmpty) return;

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/videos/${widget.groupId}');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    debugPrint("📂 Video folder: ${folder.path}");
    debugPrint("🎬 Total items: ${items.length}");

    setState(() {
      isDownloading = true;
      downloadCompleted = false;
      totalVideos = items.length;
      downloadedVideos = 0;
    });

    final dio = Dio();

    for (final item in items) {
      final url = item.mediaUrl;
      final id = item.exerciseId;

      debugPrint("➡️ Processing item: $id");
      debugPrint("🔗 Video URL: $url");

      if (url == null || url.isEmpty) {
        debugPrint("⚠️ Skip: empty url");
        downloadedVideos++;
        setState(() {});
        continue;
      }

      final filePath = '${folder.path}/$id.mp4';
      final file = File(filePath);

      if (await file.exists()) {
        debugPrint("✅ Already downloaded: $filePath");
        downloadedVideos++;
        setState(() {});
        continue;
      }

      try {
        debugPrint("⬇️ Start downloading: $filePath");

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              final percent = (received / total * 100).toStringAsFixed(1);
              debugPrint("📥 $id → $percent%");
            }
          },
        );

        debugPrint("✅ Download completed: $filePath");
      } catch (e) {
        debugPrint("❌ Download failed ($id): $e");
      }

      downloadedVideos++;
      setState(() {});
    }

    debugPrint("🎉 ALL VIDEOS DOWNLOADED");

    setState(() {
      isDownloading = false;
      downloadCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: downloadCompleted
          ? _buildFloatingButtons(context)
          : null,
      body: SafeArea(
        child: Consumer<GroupExerciseProvider>(
          builder: (context, provider, _) {
            /// fetch list
            if (provider.getItemList(widget.groupId).isEmpty &&
                !provider.isLoading) {
              Future.microtask(() {
                provider.fetchItemGroupExercises(widget.groupId);
              });
            }

            /// auto download
            if (!provider.isLoading &&
                provider.getItemList(widget.groupId).isNotEmpty &&
                !isDownloading &&
                !downloadCompleted) {
              Future.microtask(() {
                _downloadAllVideos(provider.getItemList(widget.groupId));
              });
            }

            return Column(
              children: [
                _buildHeader(provider),

                const Gap(20),

                /// ⬇️ ĐANG TẢI VIDEO
                if (isDownloading) _buildDownloadProgress(),

                /// ✅ TẢI XONG → HIỂN THỊ DANH SÁCH
                if (downloadCompleted)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount:
                          provider.getItemList(widget.groupId).length + 1,
                      itemBuilder: (context, index) {
                        if (index ==
                            provider.getItemList(widget.groupId).length) {
                          return const SizedBox(height: 100);
                        }

                        final item = provider.getItemList(
                          widget.groupId,
                        )[index];

                        return _exerciseItem(
                          context,
                          title: item.exerciseName,
                          sets: item.sets,
                          reps: item.repetitions,
                          time: item.durationSeconds,
                          description: item.description ?? "",
                          imageUrl: item.mediaUrl,
                          exerciseId: item.exerciseId,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader(GroupExerciseProvider provider) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(45),
        bottomRight: Radius.circular(45),
      ),
      child: Container(
        height: 125,
        color: context.colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  widget.groupName,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tag(
                  Icons.local_fire_department,
                  provider.getTotalcalo(widget.groupId),
                  Colors.red,
                ),
                const Gap(10),
                _tag(
                  Icons.access_time,
                  "${provider.totaltime(widget.groupId)}m",
                  Colors.green,
                ),
                const Gap(10),
                _tag(Icons.fitness_center, "Any Equipment", Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DOWNLOAD UI =================
  Widget _buildDownloadProgress() {
    final double progress = totalVideos == 0
        ? 0
        : downloadedVideos / totalVideos;
    final int percent = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Preparing your workout 💪",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            "Please wait while we get everything ready for you...",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(minHeight: 12, value: progress),
          ),
          const SizedBox(height: 10),
          Text(
            "$percent%",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= EXERCISE ITEM =================
  Widget _exerciseItem(
    BuildContext context, {
    required String title,
    required int sets,
    required int reps,
    required int? time,
    required String description,
    required String? imageUrl,
    required String exerciseId, // 👈 THÊM
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/fullbody1.png",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$sets sets x $reps reps",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        showExerciseDetail(
                          context,
                          title,
                          description,
                          exerciseId, // 👈 TRUYỀN ID
                          time,
                          widget.groupId, // 👈 TRUYỀN GROUP
                        );
                      },
                      child: const Text("View Tutorial"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  /// ================= TAG =================
  Widget _tag(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  /// ================= FAB =================
  Widget _buildFloatingButtons(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 56,
      child: Row(
        children: [
          FloatingActionButton.extended(
            icon: const FaIcon(
              FontAwesomeIcons.calendarPlus,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              showMultiDatePickerBottomSheet(context, widget.groupId);
            },
            backgroundColor: context.colorScheme.primary,
            label: const Text("Add to Schedule"),
          ),
          const Gap(10),
          FloatingActionButton.extended(
            icon: const FaIcon(
              FontAwesomeIcons.play,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutSession(groupId: widget.groupId),
                ),
              );
            },
            backgroundColor: context.colorScheme.primary,
            label: const Text("Start Now"),
          ),
        ],
      ),
    );
  }
}

void showMultiDatePickerBottomSheet(BuildContext context, String groupid) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
    ),
    builder: (context) {
      Set<DateTime> selectedDays = {};

      return StatefulBuilder(
        builder: (context, setState) {
          return FractionallySizedBox(
            heightFactor: 0.82,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Workout Schedule",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Calendar picker
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.multiple,
                          onSelectionChanged: (args) {
                            setState(() {
                              selectedDays = (args.value as List<DateTime>)
                                  .toSet();
                            });
                          },
                          showActionButtons: false,
                          monthViewSettings:
                              const DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 1,
                              ),
                          selectionColor: context.colorScheme.primary,
                          todayHighlightColor: Colors.green,
                          rangeSelectionColor: context.colorScheme.primary
                              .withOpacity(0.2),
                          minDate: DateTime.now(),

                          startRangeSelectionColor: context.colorScheme.primary,
                          endRangeSelectionColor: context.colorScheme.primary,
                          backgroundColor: Colors.blue.shade50,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Divider(thickness: 1),

                  Expanded(
                    child: selectedDays.isEmpty
                        ? const Center(
                            child: Text(
                              "No days selected yet",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : ListView(
                            children:
                                (selectedDays.toList()
                                      ..sort((a, b) => a.compareTo(b)))
                                    .map((day) {
                                      final formatted = DateFormat(
                                        'EEE, MMM d, yyyy',
                                      ).format(day);
                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.calendar_today,
                                            color: Colors.blueAccent,
                                          ),
                                          title: Text(
                                            formatted,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                selectedDays.remove(day);
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                          ),
                  ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedDays.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select at least one day'),
                            ),
                          );
                          return;
                        }

                        try {
                          // Show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    CircularProgressIndicator(
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Adding your schedule, please wait…",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );

                          await SupabaseService().createUserTrainingFromGroup(
                            groupExerciseId: groupid,
                            title:
                                "My ${selectedDays.toList().length}-Day Workout Plan",
                            selectedDays: selectedDays.toList(),
                          );

                          Navigator.pop(context); // close loading
                          Navigator.pop(
                            context,
                            selectedDays.toList(),
                          ); // close bottom sheet

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Workout plan created successfully!',
                              ),
                            ),
                          );
                        } catch (e) {
                          Navigator.pop(context); // close loading on error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to create workout plan: $e',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        "Save Selected Days",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void showExerciseDetail(
  BuildContext context,
  String title,
  String description,
  String exerciseId,
  int? time,
  String groupId,
) async {
  final dir = await getApplicationDocumentsDirectory();

  final filePath = "${dir.path}/videos/$groupId/$exerciseId.mp4";

  final file = File(filePath);

  debugPrint("🎥 Open video: $filePath");
  debugPrint("📁 Exists: ${file.existsSync()}");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) {
      return _ExerciseDetailSheet(
        title: title,
        description: description,
        time: time,
        videoFile: file.existsSync() ? file : null,
      );
    },
  );
}

class _ExerciseDetailSheet extends StatefulWidget {
  final String title;
  final String description;
  final int? time;
  final File? videoFile;

  const _ExerciseDetailSheet({
    required this.title,
    required this.description,
    required this.time,
    required this.videoFile,
  });

  @override
  State<_ExerciseDetailSheet> createState() => _ExerciseDetailSheetState();
}

class _ExerciseDetailSheetState extends State<_ExerciseDetailSheet> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.videoFile != null) {
      _controller = VideoPlayerController.file(widget.videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _controller!.setLooping(true);
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// 🎥 VIDEO LOCAL
          if (_controller != null && _controller!.value.isInitialized)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            Container(
              height: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
            ),

          const SizedBox(height: 16),

          Text(
            widget.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            "Duration: ${widget.time ?? 0}s",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 12),

          Text(
            widget.description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
