import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBarBottom extends StatefulWidget {
  const NavBarBottom({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarBottomState createState() => _NavBarBottomState();
}

class _NavBarBottomState extends State<NavBarBottom> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: GNav(
            rippleColor: Color.fromARGB(139, 0, 180, 216),
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: context.colorScheme.primary.withOpacity(0.1),
            color: Colors.black,
            tabs: [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.message, text: 'Message'),
              GButton(icon: Icons.public, text: 'Community'),
              GButton(icon: Icons.fitness_center, text: 'Workout'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
