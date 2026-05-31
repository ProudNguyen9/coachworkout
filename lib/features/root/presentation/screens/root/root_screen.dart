import 'package:coach_workout/config/routes/routes_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool _checkingProfile = true;

  @override
  void initState() {
    super.initState();
    _redirectIfProfileMissing();
  }

  Future<void> _redirectIfProfileMissing() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      if (mounted) context.go(RouteLocation.login);
      return;
    }

    try {
      final profile = await supabase
          .from('users')
          .select('id, name')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      if (profile == null ||
          profile['name'] == null ||
          '${profile['name']}'.trim().isEmpty) {
        context.go(RouteLocation.onboarding);
        return;
      }
    } catch (_) {
      if (!mounted) return;
    }

    if (mounted) {
      setState(() => _checkingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingProfile) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
