import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

import 'screens.dart';

class WorkoutScreen extends StatelessWidget {
  static WorkoutScreen builder(BuildContext context, GoRouterState state) =>
      const WorkoutScreen();
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // chiếm 90%
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkoutSession()),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Do this exercise ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      backgroundColor: Colors.white, // nền tổng thể trắng
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Phần đen bo góc trên
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
                        Text(
                          " Chest & Tricep",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.more_horiz, color: Colors.white),
                      ],
                    ),
                    const Gap(18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTag(
                          Icons.local_fire_department,
                          "40 Cal",
                          Colors.red,
                        ),
                        const Gap(12),
                        _buildTag(Icons.access_time, "73 min", Colors.green),
                        const Gap(12),
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Row(
                    children: [
                      Text(
                        'Set 1 × 9 Rounds',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showConfirmDialog(context);
                        },
                        icon: Icon(FontAwesomeIcons.pen, size: 19),
                        color: context.colorScheme.primary,
                      ),
                    ],
                  ),
                  Gap(10),
                  _exerciseItem("Dumbell Fly", context),
                  _exerciseItem("Rope Pushdown", context),
                  _exerciseItem("Cable Pushdown", context),
                  Row(
                    children: [
                      Text(
                        'Set 2 × 2 Rounds',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.pen, size: 19),
                        color: context.colorScheme.primary,
                      ),
                    ],
                  ),
                  Gap(10),
                  _exerciseItem("Cable Tricep Kickback", context),
                  _exerciseItem("Incline Dumbbell Press", context),
                ],
              ),
            ),
          ],
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

  Widget _exerciseItem(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/banner_library.png',
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
                const Row(
                  children: [
                    Text("4 Set", style: TextStyle(color: Colors.grey)),
                    Gap(10),
                    Text("40 Cal", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 37,
                  child: TextButton(
                    onPressed: () => showExerciseDetail(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
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
    );
  }
}

void showExerciseDetail(BuildContext context) {
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
        initialChildSize: 0.83,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.only(top: 0, right: 18, left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nút đóng
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Ảnh bài tập
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1599058917212-d750089bc07e',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tên bài tập
                  const Text(
                    'jumbale',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Thời lượng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time of workout',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '00:20',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Hướng dẫn
                  Text(
                    'Tutorio',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start by standing with your feet close together and your arms relaxed at your sides.'
                    'Then, jump up while spreading your legs apart and raising your arms above your head.'
                    'Return to the starting position and repeat.'
                    'This exercise works the entire body and targets all major muscle groups.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nút XONG
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Finish',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

Future<void> showConfirmDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
      child: Container(
        width: context.deviceSize.width * 0.9,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: Colors.white,
        ),

        child: Column(
          children: [
            Gap(20),
            Text(
              "Set rounds",
              style: GoogleFonts.poppins(
                color: context.colorScheme.primary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            Gap(10),
            NumberPicker(
              textStyle: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.grey,
              ),
              selectedTextStyle: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: context.colorScheme.primary,
              ),

              value: 9,
              minValue: 0,
              maxValue: 100,
              onChanged: (value) {},
            ),
            Gap(10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
              ),
              child: Text(
                "Confirm",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
