import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widgets.dart';
import 'screens.dart';

class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({super.key});

  static WorkoutLibraryScreen builder(
    BuildContext context,
    GoRouterState state,
  ) => const WorkoutLibraryScreen();

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  final GlobalKey<AnimatedFloatingActionButtonState> fabKey =
      GlobalKey<AnimatedFloatingActionButtonState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(25),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Gap(30),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Workout Library',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TabBar(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              labelColor: context.colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: context.colorScheme.primary,
              dividerHeight: 0,

              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 16),
              tabs: [
                Tab(text: "At Home"),
                Tab(text: "At Gym"),
                Tab(text: "Meal plan"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [AtHomeScreen(), AtGymScreen(), MealPlanScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----- SearchDelegate giữ nguyên -----
class MySearchDelegate extends SearchDelegate {
  final List<String> data;
  MySearchDelegate(this.data);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data.where(
      (e) => e.toLowerCase().contains(query.toLowerCase()),
    );
    return ListView(
      children: results.map((e) => ListTile(title: Text(e))).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = data.where(
      (e) => e.toLowerCase().startsWith(query.toLowerCase()),
    );
    return ListView(
      children: suggestions
          .map(
            (e) => ListTile(
              title: Text(e),
              onTap: () {
                query = e;
                showResults(context);
              },
            ),
          )
          .toList(),
    );
  }
}

// Fake data
final List<String> data = [
  "Apple",
  "Banana",
  "Orange",
  "Pineapple",
  "Grape",
  "Mango",
];
