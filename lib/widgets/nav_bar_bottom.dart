import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screen/screens.dart';

class NavBarBottom extends StatefulWidget {
  const NavBarBottom({super.key});

  @override
  _NavBarBottomState createState() => _NavBarBottomState();
}

class _NavBarBottomState extends State<NavBarBottom> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: GNav(
              rippleColor: colorScheme.primary.withOpacity(0.15),
              hoverColor: colorScheme.primary.withOpacity(0.05),
              gap: 6, // giảm nhẹ gap
              activeColor: colorScheme.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: colorScheme.primary.withOpacity(0.12),
              color: colorScheme.onSurface.withOpacity(0.7),
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: colorScheme.primary,
              ),
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                  onPressed: () {
                    setState(() => _selectedIndex = 0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                ),
                GButton(
                  icon: Icons.message_rounded,
                  text: 'Message',
                  onPressed: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConversationListScreen(),
                      ),
                    );
                  },
                ),
                GButton(
                  icon: Icons.public_rounded,
                  text: 'Community',
                  onPressed: () {
                    setState(() => _selectedIndex = 2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FeedScreen()),
                    );
                  },
                ),
                GButton(
                  icon: Icons.fitness_center_rounded,
                  text: 'Workout',
                  onPressed: () {
                    setState(() => _selectedIndex = 3);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WorkoutLibraryScreen(),
                      ),
                    );
                  },
                ),
                GButton(
                  icon: Icons.person_rounded,
                  text: 'Profile',
                  onPressed: () {
                    setState(() => _selectedIndex = 4);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (_) {},
            ),
          ),
        ),
      ),
    );
  }
}
