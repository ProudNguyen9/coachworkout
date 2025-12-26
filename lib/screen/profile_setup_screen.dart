import 'package:coach_workout/screen/screens.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSetupScreen extends StatefulWidget {
  static ProfileSetupScreen builder(
    BuildContext context,
    GoRouterState state,
  ) => ProfileSetupScreen();
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  bool isFemaleSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),
              Center(
                child: Text(
                  'ProfileSetupScreen.personal_info_title'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(10),
              Text(
                'ProfileSetupScreen.personal_info_desc'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const Gap(30),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        isFemaleSelected = true;
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 155,
                      decoration: BoxDecoration(
                        color: isFemaleSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: context.colorScheme.primary,
                        ),
                        boxShadow: isFemaleSelected
                            ? [
                                BoxShadow(
                                  color: Colors.cyan[400]!.withOpacity(0.8),
                                  blurRadius: 12, // nhỏ hơn để bóng rõ nét
                                  spreadRadius: 3, // lan rộng hơn
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Image.asset('assets/female.png'),
                    ),
                  ),
                  const Gap(5),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        isFemaleSelected = false;
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 155,
                      decoration: BoxDecoration(
                        color: !isFemaleSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: context.colorScheme.primary,
                        ),
                        boxShadow: !isFemaleSelected
                            ? [
                                BoxShadow(
                                  color: Colors.cyan[400]!.withOpacity(0.8),
                                  blurRadius: 12, // nhỏ hơn để bóng rõ nét
                                  spreadRadius: 3, // lan rộng hơn
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Image.asset('assets/male.png'),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              Text(
                'ProfileSetupScreen.nickname_label'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ProfileSetupScreen.nickname_hint'.tr(),
                  filled: true,
                  fillColor: context.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const Gap(20),
              Text(
                'ProfileSetupScreen.about_me_label'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ProfileSetupScreen.about_me_hint'.tr(),
                  filled: true,
                  fillColor: context.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                maxLines: 2,
                keyboardType: TextInputType.text,
              ),
              const Gap(50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[600],
                  foregroundColor: Colors.white,
                  minimumSize: Size(context.deviceSize.width - 50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'ProfileSetupScreen.next_button'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}