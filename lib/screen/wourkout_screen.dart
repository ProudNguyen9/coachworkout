import 'package:coach_workout/providers/group_exercise_provider.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens.dart';

class WorkoutScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 56,
        child: Row(
          children: [
            FloatingActionButton.extended(
              icon: const FaIcon(
                size: 19,
                FontAwesomeIcons.calendarPlus,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutSession(),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              label: const Text(
                "Add to Schedule",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Gap(10),
            FloatingActionButton.extended(
              icon: const FaIcon(
                FontAwesomeIcons.play,
                color: Colors.white,
                size: 19,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutSession(),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              label: const Text(
                "Start Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<GroupExerciseProvider>(
          builder: (context, provider, _) {
            // Nếu chưa load thì gọi fetch
            if (provider.getItemList(groupId).isEmpty && !provider.isLoading) {
              Future.microtask(() {
                provider.fetchItemGroupExercises(groupId);
              });
            }

            return Column(
              children: [
                // 🔹 Header
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                  child: Container(
                    height: 125,
                    color: context.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Text(
                                  groupName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.more_horiz, color: Colors.white),
                          ],
                        ),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTag(
                              Icons.local_fire_department,
                              provider.getTotalcalo(groupId),
                              Colors.red,
                            ),
                            _buildTag(
                              Icons.access_time,
                              "${provider.getTotaltime(groupId)}m",
                              Colors.green,
                            ),
                            _buildTag(
                              Icons.fitness_center,
                              "Any Equipment",
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Gap(20),

                // 🔹 Danh sách bài tập
                Expanded(
                  child:
                      provider.isLoading &&
                          provider.getItemList(groupId).isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: provider.getItemList(groupId).length,
                          itemBuilder: (context, index) {
                            if (index == provider.getItemList(groupId).length) {
                              return const Gap(250);
                            }
                            final item = provider.getItemList(groupId)[index];
                            return _exerciseItem(
                              context,
                              title: item.exerciseName,
                              sets: item.sets,
                              calories: item.caloriesPerRep! * item.repetitions,
                              imageUrl: item.mediaUrl,
                              description: item.description ?? "",
                              time: item.durationSeconds,
                              reps: item.repetitions,
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

  static Widget _buildTag(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 21),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _exerciseItem(
    BuildContext context, {
    required String title,
    required int sets,
    required int reps,
    required int? time,
    required double calories,
    required String? imageUrl,
    required String description,
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
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "$sets Sets x",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          "$reps Rep",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 37,
                      child: TextButton(
                        onPressed: () => showExerciseDetail(
                          context,
                          title,
                          description,
                          imageUrl,
                          time,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: Text(
                          "View Tutorial",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(10),
          Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 1,
            indent: 9,
            endIndent: 9,
          ),
        ],
      ),
    );
  }
}

void showExerciseDetail(
  BuildContext context,
  String name,
  String description,
  String? urlmedia,
  int? time,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.59,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedVideoPlayerWidget(
                      videoUrl:
                          urlmedia ??
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Text(
                        "Time: ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "$time s",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Text(
                    "Decription",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
