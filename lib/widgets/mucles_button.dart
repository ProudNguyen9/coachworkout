import 'package:flutter/material.dart';

class MuscleScrollRow extends StatelessWidget {
  final List<Map<String, String>> muscles = [
    {
      'name': 'Chest',
      'image':
          'https://images.pexels.com/photos/3838381/pexels-photo-3838381.jpeg', // ngực
    },
    {
      'name': 'Back',
      'image':
          'https://images.pexels.com/photos/1552106/pexels-photo-1552106.jpeg', // lưng
    },
    {
      'name': 'Biceps',
      'image':
          'https://images.pexels.com/photos/414029/pexels-photo-414029.jpeg', // tay trước
    },
    {
      'name': 'Abs',
      'image':
          'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg', // bụng
    },
    {
      'name': 'Legs',
      'image':
          'https://images.pexels.com/photos/2261485/pexels-photo-2261485.jpeg', // chân
    },
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
            _buildCustomCard(), // ô Custom
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
                  Image.network(
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
                      muscle['name']!,
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

  /// ô Custom với gradient
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
                    offset: const Offset(0, 4),
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
