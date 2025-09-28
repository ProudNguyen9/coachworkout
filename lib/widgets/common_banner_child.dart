import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerChild extends StatelessWidget {
  final String Title;
  final String TitleChild;
  final String path;
  const BannerChild({
    super.key,
    required this.Title,
    required this.TitleChild,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return // banner  movivated
    Container(
      width: 393,
      height: 181,
      decoration: BoxDecoration(color: context.colorScheme.secondaryContainer),
      child: Center(
        child: Container(
          width: 324,
          height: 124,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          Title,
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE2F163),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Text(
                        TitleChild,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  path,
                  width: 140,
                  height: 124,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
