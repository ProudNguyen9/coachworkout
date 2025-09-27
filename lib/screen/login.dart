import 'package:coach_workout/config/config.dart';
import 'package:coach_workout/config/theme/color_scheme_extension.dart';
import 'package:coach_workout/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../utils/utils.dart';

class LoginScreen extends StatelessWidget {
  static LoginScreen builder(BuildContext context, GoRouterState state) =>
      LoginScreen();
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  // Controller chỉ tồn tại trong màn hình này
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final passwordProvider = context.watch<PasswordProvider>();
    final deviceSize = context.deviceSize;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: context.colorScheme.primary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  width: deviceSize.width,
                  height: deviceSize.height - 70,
                  color: context.colorScheme.surface,
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Gap(40),
                          const Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  style: TextStyle(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Gap(15),

                          Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  validator: Validators.validateEmail,
                                  controller: emailController,
                                  hintText: 'Email Address',
                                  prefixIcon: Icons.email_outlined,
                                ),
                                const Gap(15),
                                CustomTextField(
                                  validator: Validators.validatePassword,
                                  controller: passwordController,
                                  obscureText: !passwordProvider.isVisible,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: IconButton(
                                    onPressed: () => context
                                        .read<PasswordProvider>()
                                        .toggle(),
                                    icon: Icon(
                                      passwordProvider.isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Gap(10),
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (v) {}),
                              Text("Remember me"),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  context.go(RouteLocation.resetpass);
                                },
                                child: Text(
                                  "Forget password?",
                                  style: TextStyle(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Gap(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final user = await AuthRepository.instance
                                          .signInWithEmail(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                          );

                                      if (user != null) {
                                        context.go(RouteLocation.onboarding);
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Lỗi  ${e.message}"),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colorScheme.primary,
                                  minimumSize: Size(140, 45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Gap(10),
                              OutlinedButton(
                                onPressed: () {
                                  context.go(RouteLocation.register);
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
                                  "Register",
                                  style: TextStyle(
                                    color: context.colorScheme.customWhite,
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
                                onPressed: () async {
                                  final googleSignIn = GoogleSignIn.instance;

                                  await googleSignIn.initialize();

                                  final account = await googleSignIn
                                      .authenticate();

                                  final auth = account.authentication;
                                  final credential =
                                      GoogleAuthProvider.credential(
                                        idToken: auth.idToken,
                                      );
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                },
                                path: 'assets/google_icon.svg',
                              ),
                              Gap(10),
                              IconButtonSvg(
                                onPressed: () async {
                                  final user = await AuthRepository.instance
                                      .signInWithFacebook();
                                  if (user != null) {
                                    print(
                                      "Đăng nhập thành công: ${user.email}",
                                    );
                                  } else {
                                    print("Đăng nhập thất bại");
                                  }
                                },
                                path: 'assets/facebook_icon.svg',
                              ),
                              Gap(10),
                              IconButtonSvg(
                                onPressed: () async {
                                  final user = await AuthRepository.instance
                                      .signInWithGithubFirebase();
                                  if (user != null) {
                                    // Đăng nhập thành công
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Xin chào ${user.displayName}!',
                                        ),
                                      ),
                                    );
                                  } else {
                                    // User hủy login hoặc lỗi
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đăng nhập thất bại'),
                                      ),
                                    );
                                  }
                                },
                                path: 'assets/github_icon.svg',
                                color: context.colorScheme.colorlogogithub,
                              ),
                            ],
                          ),
                          Gap(15),
                          Image.asset(
                            'assets/gifrunning_nobackground.gif',
                            width: 140,
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
