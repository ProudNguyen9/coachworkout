import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBarBottom extends StatefulWidget {
  const NavBarBottom({super.key});

  @override
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
            rippleColor: const Color.fromARGB(139, 0, 180, 216),
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: context.colorScheme.primary.withOpacity(0.1),
            color: Colors.black,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.message, text: 'Message'),
              GButton(icon: Icons.public, text: 'Community'),
              GButton(icon: Icons.fitness_center, text: 'Workout'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) async {
              setState(() {
                _selectedIndex = index;
              });

              // 🔹 Khi bấm vào tab "Message", mở chat
              if (index == 1) {
                // Nếu bạn có GoRouter:
                // context.push('/chat');

                // // Nếu không có GoRouter, dùng Navigator:
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => ChatInitializer().build()),
                // );
              }
            },
          ),
        ),
      ),
    );
  }
}
