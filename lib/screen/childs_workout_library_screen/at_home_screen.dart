import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/widgets.dart';

class AtHomeScreen extends StatelessWidget {
  const AtHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(19),
            Center(
              child: SizedBox(
                height: 52,
                width: context.deviceSize.width - 30,
                //search fiel
                child: TextField(
                  onChanged: null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hint: Text('Fill your context ....'),
                    fillColor: context.colorScheme.surface,
                    focusColor: context.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(10),
            TextTile(title: 'Target Area'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MuscleScrollRow(),
            ),

            // banner  movivated
            BannerChild(
              Title: '  Weekly Challenge',
              TitleChild: 'Plank With Hip Twist',
              path: 'assets/banner_library.png',
            ),
            //
            TitleTextAndButtonSA(onPressed: () {}, title: 'Beginner Workout'),
            SizedBox(
              height: 240,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  final workout = beginnerWorkouts[index];
                  return ItemListBeginner(
                    path: workout["path"]!,
                    title: workout["title"]!,
                    description: workout["description"]!,
                    times: workout["times"]!,
                    ontap: () {},
                  );
                },
              ),
            ),
            TitleTextAndButtonSA(onPressed: () {}, title: 'Just For You'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI9J598TmGZgO2bHvdpw8BUkqRajVV2EqScw&s',
                      'Workout Plan',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdqhHRm1HgAHL9k6cyYfWCEM0M7REXUyeGyw&s',
                      'AI Coaching',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxV7ToOVEGNyP05_I6kdLnxDrGwKF_mOmcqQ&s',
                      'Nutrition',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrdOI-pFGm7VdHOcUd6oDxmu1KVtpPMRqE_A&s',
                      'Yoga',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJlgqbfsLrI7FIO0gPUoMYVde1nwCUixjxaA&s',
                      'Cardio',
                    ),
                    buildImageCard(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyaV0bWwrQvU3TKjhtqMbMoXssD23mDFa2g&s',
                      'HIIT',
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
            // banner  2
            Container(
              width: 393,
              height: 347,
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/banner_library2.jpg',
                        width: 300,
                        height: 310,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(color: Color(0xE5212020)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Cycling Challenge",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 238, 254, 98),
                                  ),
                                ),

                                Row(
                                  children: const [
                                    Icon(
                                      Icons.timer,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    Gap(4),
                                    Text(
                                      "15 Minutes",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Gap(12),
                                    Icon(
                                      Icons.local_fire_department,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    Gap(4),
                                    Text(
                                      "100 Kcal",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Icon(
                          FontAwesomeIcons.solidStar,
                          color: Color(0xFFE2F163),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(15),
            TitleTextAndButtonSA(onPressed: () {}, title: 'Articles & Tips'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardTip(
                    onTap: () {},
                    title: 'Supplement Guide...',
                    path: 'assets/tip1.jpg',
                  ),
                  CardTip(
                    onTap: () {},
                    title: '15 Quick & Effective....',
                    path: 'assets/tip2.jpg',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardTip(
                    onTap: () {},
                    title: 'Supplement Guide...',
                    path: 'assets/tip3.jpg',
                  ),
                  CardTip(
                    onTap: () {},
                    title: '15 Quick & Effective....',
                    path: 'assets/tip2.jpg',
                  ),
                ],
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
