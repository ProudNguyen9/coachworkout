import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBarBottom extends StatelessWidget {
  const NavBarBottom({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChange;

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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: GNav(
              selectedIndex: selectedIndex,

              rippleColor: colorScheme.primary.withOpacity(0.15),
              hoverColor: colorScheme.primary.withOpacity(0.05),
              gap: 10,
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

              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.message_rounded, text: 'Message'),
                GButton(icon: Icons.public_rounded, text: 'Community'),
                GButton(icon: Icons.fitness_center_rounded, text: 'Workout'),
                GButton(icon: Icons.person_rounded, text: 'Profile'),
              ],

              /// 🔥 Chỉ đổi index
              onTabChange: onTabChange,
            ),
          ),
        ),
      ),
    );
  }
}
