import 'package:coach_workout/config/theme/color_scheme_extension.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class GymCard extends StatelessWidget {
   final VoidCallback onTap ; 
   final String Title ; 
   final String path ; 
   final String time ; 
   final String rep ;  
  const GymCard({super.key, required this.onTap, required this.path, required this.time, required this.rep, required this.Title});

  @override
  Widget build(BuildContext context) {
     final customwhite = context.colorScheme.customWhite;
    return GestureDetector(
      onTap:onTap ,
      child: Container(
                    width: 170,
                    height: 162,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            child: Image.asset(
                              path,
                              width: 170,
                              height: 112,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 170,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF212020),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                              border: Border(
                                right: BorderSide(color: customwhite, width: 2),
                                left: BorderSide(color: customwhite, width: 2),
                                bottom: BorderSide(color: customwhite, width: 2),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Title,
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFFE2F163),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_sharp,
                                        size: 20,
                                        color: Color(0xFF896CFE),
                                      ),
                                      Gap(3),
                                      Text(
                                        time,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Icon(
                                        Icons.local_fire_department,
                                        size: 20,
                                        color: Color(0xFF896CFE),
                                      ),
                                      Gap(3),
                                      Text(
                                        '$rep  Rep',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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