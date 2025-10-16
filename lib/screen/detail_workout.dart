import 'package:animate_do/animate_do.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DetailWorkout extends StatelessWidget {
  static DetailWorkout builder(BuildContext context, GoRouterState state) =>
      const DetailWorkout();

  const DetailWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Stack(
        children: [
          // 🔹 Ảnh trên: chéo xuống
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: ClipPath(
              clipper: TopDiagonalClipper(),
              child: Image.asset(
                'assets/banner_library2.jpg',
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Nút back
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FadeInLeft(
                duration: const Duration(milliseconds: 600),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 🔹 Nền xanh dưới
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomDiagonalClipper(),
              child: Container(
                height: 470,
                width: double.infinity,
                color: context.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(75),

                    // 🔸 Tiêu đề
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: const Text(
                        'BELLY FAT BURNER HIIT\nBEGINNER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const Gap(10),

                    // --- Thông tin phụ
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _InfoItem(title: 'Beginner', subtitle: 'Level'),
                          _InfoItem(title: '14 mins', subtitle: 'Time'),
                          _InfoItem(title: '204 kcal', subtitle: 'Calories'),
                        ],
                      ),
                    ),

                    const Gap(10),

                    // --- Mô tả
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 200),
                      child: const Text(
                        'Belly fat burning HIIT alternates intense exercises with less intense recovery periods.\n\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const Gap(10),

                    // --- Hashtags
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 300),
                      child: Wrap(
                        spacing: 8,
                        children: const [
                          _TagChip('#For beginners'),
                          _TagChip('#HIIT'),
                          _TagChip('#Fat burner'),
                        ],
                      ),
                    ),

                    const Gap(10),

                    // --- Button
                    Center(
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 400),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'More Detail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Hình chéo
          Positioned(
            top: 256,
            child: Align(
              alignment: Alignment.center,
              child: FadeInUp(
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 200),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateZ(0.10),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.asset(
                      'assets/bannerycdi.png',
                      fit: BoxFit.cover,
                      width: context.deviceSize.width,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Phần trên
class TopDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double topOffset = 354;
    final double bottomOffset = 274;
    final path = Path()
      ..moveTo(0, topOffset)
      ..lineTo(size.width, bottomOffset)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

/// 🔹 Phần dưới
class BottomDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double topOffset = 100;
    final double bottomOffset = 20;
    final path = Path()
      ..moveTo(0, topOffset)
      ..lineTo(size.width, bottomOffset)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String subtitle;
  const _InfoItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
