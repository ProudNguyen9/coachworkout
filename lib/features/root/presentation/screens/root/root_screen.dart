import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_workout/features/chat/presentation/screens/conversation_list/conversation_list_screen.dart';
import 'package:coach_workout/features/feed/presentation/screens/feed/feed_screen.dart';
import 'package:coach_workout/features/home/presentation/screens/home/home_screen.dart';
import 'package:coach_workout/features/profile/presentation/screens/profile/profile_screen.dart';
import 'package:coach_workout/features/workout/presentation/screens/workout_library/workout_library.dart';
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


