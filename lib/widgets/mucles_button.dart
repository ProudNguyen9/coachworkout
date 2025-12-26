import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MuscleScrollRow extends StatelessWidget {
  final List<Map<String, String>> muscles = [
    {'key': 'chest', 'image': 'assets/libraryworkout/chest.png'},
    {'key': 'back', 'image': 'assets/libraryworkout/back.png'},
    {'key': 'shoulders', 'image': 'assets/libraryworkout/shoulders.png'},
    {'key': 'biceps', 'image': 'assets/libraryworkout/biceps.png'},
    {'key': 'triceps', 'image': 'assets/libraryworkout/triceps.png'},
    {'key': 'legs', 'image': 'assets/libraryworkout/legs.png'},
    {'key': 'core', 'image': 'assets/libraryworkout/core.png'},
  ];

  MuscleScrollRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...muscles.map((muscle) => _buildMuscleCard(muscle)),
            _buildCustomCard(),
          ],
        ),
      ),
    );
  }

  /// card nhóm cơ
  Widget _buildMuscleCard(Map<String, String> muscle) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 120,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.asset(
                    muscle['image']!,
                    height: 100,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 8,
                    child: Text(
                      'muscles.${muscle['key']}'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ô Custom
  Widget _buildCustomCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 100,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6A11CB),
                    Color.fromARGB(255, 37, 248, 252),
                    Color(0xFFFF6FD8),
                    Color(0xFFFF8C00),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.add, size: 40, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
