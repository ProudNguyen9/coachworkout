import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

class WalkingScreen extends StatelessWidget {
  const WalkingScreen({super.key});

  static const Color primary = Color(0xFF22B8F0);
  static const Color primarySoft = Color(0xFFEAF7FD);
  static const Color textSub = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// ===== CONTENT =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Text(
                      'Walking',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      'Today • 3,245 steps',
                      style: GoogleFonts.inter(fontSize: 14, color: textSub),
                    ),

                    const Gap(24),

                    /// PROGRESS RING
                    Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: CustomPaint(
                          painter: _RingPainter(progress: 0.65),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '3,245',
                                style: GoogleFonts.inter(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                'steps',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: textSub,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Gap(24),

                    /// METRICS
                    Row(
                      children: const [
                        Expanded(
                          child: _MetricCard(
                            title: 'Distance',
                            value: '2.3 km',
                            icon: Icons.route_rounded,
                            gradient: [Color(0xFF22B8F0), Color(0xFF4DD0E1)],
                          ),
                        ),
                        Gap(14),
                        Expanded(
                          child: _MetricCard(
                            title: 'Calories',
                            value: '123 kcal',
                            icon: Icons.local_fire_department_rounded,
                            gradient: [Color(0xFFFF8A65), Color(0xFFFF7043)],
                          ),
                        ),
                      ],
                    ),

                    const Gap(18),

                    /// SET GOAL
                    _SetGoalCard(),
                  ],
                ),
              ),
            ),

            /// ===== CTA FIXED BOTTOM =====
            Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 16 + bottomInset),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Start walking',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= RING =================
class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 14;

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final fgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF22B8F0), Color(0xFF4DD0E1)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}

/// ================= METRIC CARD =================
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradient;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -6,
            bottom: -6,
            child: Icon(icon, size: 60, color: Colors.white.withOpacity(0.15)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const Gap(6),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ================= SET GOAL =================
class _SetGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WalkingScreen.primarySoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: WalkingScreen.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flag_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily goal',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(4),
                Text(
                  'Set your walking target',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: WalkingScreen.textSub,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Set',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: WalkingScreen.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
