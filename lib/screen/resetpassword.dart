import 'package:coach_workout/config/config.dart';
import 'package:coach_workout/config/theme/color_scheme_extension.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:coach_workout/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatelessWidget {
  static ResetPasswordScreen builder(
    BuildContext context,
    GoRouterState state,
  ) => ResetPasswordScreen();
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    return Scaffold(
      bottomNavigationBar: Footer(),
      backgroundColor: context.colorScheme.primary,
      body: SingleChildScrollView(
        child: ClipPath(
          clipper: BottomCurveClipper(),
          child: Container(
            width: deviceSize.width,
            height: deviceSize.height - 70,
            color: context.colorScheme.surface,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Gap(40),
                  const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Gap(20),

                  Text(
                    'No problem if you can’t remember your password. Type in your email and we’ll send a link to reset it.',
                    style: context.textTheme.titleMedium!.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const Gap(30),
                  CustomTextField(
                    hintText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const Gap(30),

                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          context.go(RouteLocation.login);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(100, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          side: BorderSide(
                            width: 1,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            color: context.colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Gap(10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          minimumSize: Size(100, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),

                        child: const Text(
                          "Reset your password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(20),
                  const Text("or connect with"),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButtonSvg(
                        onPressed: () {},
                        path: 'assets/google_icon.svg',
                      ),
                      Gap(10),
                      IconButtonSvg(
                        onPressed: () {},
                        path: 'assets/facebook_icon.svg',
                      ),
                      Gap(10),
                      IconButtonSvg(
                        onPressed: () {},
                        path: 'assets/github_icon.svg',
                        color: context.colorScheme.colorlogogithub,
                      ),
                    ],
                  ),
                  Gap(20),
                  Image.asset('assets/reset.gif', width: 150, height: 140),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
