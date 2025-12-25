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

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedFloatingActionButtonState> fabKey =
      GlobalKey<AnimatedFloatingActionButtonState>();

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(25),

          /// Title
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

          /// Tabs
          TabBar(
            controller: _tabController,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            labelColor: context.colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: context.colorScheme.primary,
            dividerHeight: 0,
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 16),
            tabs: const [
              Tab(text: "Workouts"),
              Tab(text: "Walking"),
              Tab(text: "Shop"),
            ],
          ),

          /// Animated content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: _buildTabView(_currentIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabView(int index) {
    switch (index) {
      case 0:
        return const Workouts(key: ValueKey(0));
      case 1:
        return const WalkingScreen(key: ValueKey(1));
      case 2:
        return const ShopScreen(key: ValueKey(2));
      default:
        return const SizedBox();
    }
  }
}

/// ----- SearchDelegate giữ nguyên -----
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
