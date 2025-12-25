import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_workout/screen/conversation_list_screen.dart';
import 'package:coach_workout/screen/feed_screen.dart';
import 'package:coach_workout/screen/home_screen.dart';
import 'package:coach_workout/screen/profile_screen.dart';
import 'package:coach_workout/screen/workout_library.dart';
import 'package:coach_workout/widgets/nav_bar_bottom.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  static RootScreen builder(BuildContext context, GoRouterState state) =>
      const RootScreen();

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ✅ Giữ state các tab
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeScreen(),
            ConversationListScreen(),
            FeedScreen(),
            WorkoutLibraryScreen(),
            ProfileScreen(),
          ],
        ),
      ),

      /// ✅ Truyền index + callback xuống nav
      bottomNavigationBar: NavBarBottom(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
