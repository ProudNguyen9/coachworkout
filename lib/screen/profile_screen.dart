import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static ProfileScreen builder(BuildContext context, GoRouterState state) =>
      ProfileScreen();
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isOwner = true;
    return Scaffold(
      bottomNavigationBar: NavBarBottom(),
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Center(
              child: TextTile(
                // ignore: dead_code
                title: isOwner ? "My Profile" : "User Join Profile",
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/tip1.jpg',
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Username hehe',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Nguyenvana@gmail.com',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ],
            ),
            const Gap(20),
            isOwner
                ?
                  // ignore: dead_code
                  SizedBox.shrink()
                // ignore: dead_code
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        label: Text(
                          'Follow',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.add, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1F4690),
                        ),
                      ),
                      const Gap(20),
                      ElevatedButton.icon(
                        onPressed: () {},
                        label: Text(
                          'Message',
                          style: TextStyle(color: Color(0xFFCC2229)),
                        ),
                        icon: Icon(Icons.message, color: Color(0xFFCC2229)),
                      ),
                    ],
                  ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CD964),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/bx-video-recording.svg',
                        width: 14,
                        height: 14,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const Gap(10),
                    Column(
                      children: [
                        Text(
                          "Workout",
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6C6C6C),
                            letterSpacing: 0.06,
                          ),
                        ),
                        Text(
                          "153",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111111),
                            letterSpacing: 0.12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(15),
                SizedBox(
                  height: 40,
                  child: VerticalDivider(color: Colors.grey, thickness: 1),
                ),
                const Gap(15),

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFFE970F),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/bxs-hot 1.svg',
                    width: 14,
                    height: 14,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const Gap(10),
                Column(
                  children: [
                    Text(
                      "Calories",
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C6C6C),
                        letterSpacing: 0.06,
                      ),
                    ),
                    Text(
                      "320",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        letterSpacing: 0.12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            TextTile(title: 'Activities'),
            SizedBox(
              height: 240,
              width: context.deviceSize.width - 5,
              child: ActiveChart(),
            ),
            const Gap(10),
            TextTile(title: "Today's Report"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                InfoCard(
                  title: 'Calories Burned',
                  value: '245',
                  unit: 'Kcal',
                  iconPath: 'assets/icons/bxs-hot 1.svg',
                  backgroundColor: Color(0xFF4C6EF5),
                ),
                InfoCard(
                  title: 'Heart Rate',
                  value: '78',
                  unit: 'Bpm',
                  iconPath: 'assets/icons/bxs-heart 1.svg',
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                InfoCard(
                  title: 'Carbohydrate',
                  value: '123',
                  unit: 'Gram',
                  iconPath: 'assets/icons/bxs-bowl-rice 1.svg',
                  backgroundColor: Color(0xFF4DD0E1),
                ),
                InfoCard(
                  title: 'Workout',
                  value: '60',
                  unit: 'Mins',
                  iconPath: 'assets/icons/bx-dumbbell.svg',
                  backgroundColor: Color(0xFFFFA726),
                ),
              ],
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}
