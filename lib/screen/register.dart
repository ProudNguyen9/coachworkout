import 'package:coach_workout/config/config.dart';
import 'package:coach_workout/config/theme/color_scheme_extension.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:coach_workout/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  static RegisterScreen builder(BuildContext context, GoRouterState state) =>
      RegisterScreen();
  const RegisterScreen({super.key});

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
                    "Welcome",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  Column(
                    children: [
                      Text('By signing in you are agreeing our '),
                      Gap(5),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Term and privacy policy',
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),

                  const Gap(20),
                  CustomTextField(
                    hintText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const Gap(20),

                  CustomTextField(
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                  const Gap(20),
                  CustomTextField(
                    hintText: 'Confirm Password',
                    prefixIcon: Icons.check_circle_outline,
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          context.go(RouteLocation.login);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(140, 45),
                          side: BorderSide(
                            color: context.colorScheme.customWhite,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: context.colorScheme.customWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Gap(10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          minimumSize: Size(140, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Register",
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
                  const Gap(10),
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
                  Gap(10),
                  Image.asset('assets/register.gif', width: 150, height: 110),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
