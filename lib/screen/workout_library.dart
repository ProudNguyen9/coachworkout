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
        bottomNavigationBar: const NavBarBottom(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(25),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Workout Library',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
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
        floatingActionButton: AnimatedFloatingActionButton(
          key: fabKey,

          fabButtons: <Widget>[_searchFab(context), _addFab(context)],
          colorStartAnimation: const Color(0xFF00B5D8),
          colorEndAnimation: Colors.cyan,
          animatedIconData: AnimatedIcons.menu_close,
        ),
      ),
    );
  }

  Widget _searchFab(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btnSearch",
      onPressed: () {
        showSearch(context: context, delegate: MySearchDelegate(data));
      },
      tooltip: "Search",
      backgroundColor: const Color(0xFF00B5D8),
      elevation: 4,
      child: const Icon(Icons.search, size: 20, color: Colors.white),
    );
  }

  Widget _addFab(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btnAdd",
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Add new workout")));
      },
      tooltip: "Add Workout",
      backgroundColor: const Color(0xFF00B5D8),
      elevation: 4,
      child: const Icon(Icons.add, size: 26, color: Colors.white),
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
