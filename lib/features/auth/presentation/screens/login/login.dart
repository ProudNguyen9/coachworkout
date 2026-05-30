// import 'package:coach_workout/config/config.dart';
// import 'package:coach_workout/config/theme/color_scheme_extension.dart';
// import 'package:coach_workout/features/auth/presentation/screens/register/register.dart';
// import 'package:coach_workout/screen/screens.dart';
// import 'package:coach_workout/widgets/widgets.dart';

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:coach_workout/providers/provider.dart';
// import 'package:coach_workout/utils/utils.dart';

// class LoginScreen extends StatelessWidget {
//   static LoginScreen builder(BuildContext context, GoRouterState state) =>
//       LoginScreen();
//   LoginScreen({super.key});
//   final _formKey = GlobalKey<FormState>();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final passwordProvider = context.watch<PasswordProvider>();
//     final deviceSize = context.deviceSize;
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       behavior: HitTestBehavior.translucent,
//       child: Scaffold(
//         backgroundColor: context.colorScheme.primary,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               ClipPath(
//                 clipper: BottomCurveClipper(),
//                 child: Container(
//                   width: deviceSize.width,
//                   height: deviceSize.height - 70,
//                   color: context.colorScheme.surface,
//                   padding: EdgeInsets.zero,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           const Gap(40),
//                           const Text(
//                             "Welcome",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Gap(10),
//                           Column(
//                             children: [
//                               Text('By signing in you are agreeing our '),
//                               Gap(5),
//                               InkWell(
//                                 onTap: () {},
//                                 child: Text(
//                                   'Term and privacy policy',
//                                   style: TextStyle(
//                                     color: context.colorScheme.primary,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const Gap(15),

//                           Form(
//                             autovalidateMode:
//                                 AutovalidateMode.onUserInteraction,
//                             key: _formKey,
//                             child: Column(
//                               children: [
//                                 CustomTextField(
//                                   validator: Validators.validateEmail,
//                                   controller: emailController,
//                                   hintText: 'Email Address',
//                                   prefixIcon: Icons.email_outlined,
//                                 ),
//                                 const Gap(15),
//                                 CustomTextField(
//                                   validator: Validators.validatePassword,
//                                   controller: passwordController,
//                                   obscureText: !passwordProvider.isVisible,
//                                   hintText: 'Password',
//                                   prefixIcon: Icons.lock_outline,
//                                   suffixIcon: IconButton(
//                                     onPressed: () => context
//                                         .read<PasswordProvider>()
//                                         .toggle(),
//                                     icon: Icon(
//                                       passwordProvider.isVisible
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const Gap(10),
//                           Row(
//                             children: [
//                               Checkbox(value: true, onChanged: (v) {}),
//                               Text("Remember me"),
//                               const Spacer(),
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           ResetPasswordScreen(),
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   "Forget password?",
//                                   style: TextStyle(
//                                     color: context.colorScheme.primary,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const Gap(15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   await Supabase.instance.client.auth
//                                       .signInWithOAuth(
//                                         OAuthProvider
//                                             .google, // 👈 dùng OAuthProvider thay vì Provider
//                                         redirectTo:
//                                             'coachworkout://login-callback',
//                                       );
//                                 },

//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: context.colorScheme.primary,
//                                   minimumSize: Size(140, 45),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(24),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Login",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               Gap(10),
//                               OutlinedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => RegisterScreen(),
//                                     ),
//                                   );
//                                 },
//                                 style: OutlinedButton.styleFrom(
//                                   minimumSize: Size(140, 45),
//                                   side: BorderSide(
//                                     color: context.colorScheme.customWhite,
//                                     width: 1,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(24),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "Register",
//                                   style: TextStyle(
//                                     color: context.colorScheme.customWhite,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const Gap(20),
//                           const Text("or connect with"),
//                           const Gap(10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButtonSvg(
//                                 onPressed: () async {
//                                   try {
//                                     await Supabase.instance.client.auth
//                                         .signInWithOAuth(
//                                           OAuthProvider.google,
//                                           redirectTo:
//                                               'coachworkout://login-callback',
//                                           authScreenLaunchMode:
//                                               LaunchMode.externalApplication,
//                                         );
//                                   } catch (e) {
//                                     debugPrint('Lỗi đăng nhập Google: $e');
//                                   }
//                                 },
//                                 path: 'assets/google_icon.svg',
//                               ),

//                               Gap(10),
//                               IconButtonSvg(
//                                 onPressed: () async {
//                                   // try {
//                                   //   await AuthRepository.instance
//                                   //       .signInWithFacebook();
//                                   //   final user =
//                                   //       AuthRepository.instance.currentUser;

//                                   //   if (user != null) {
//                                   //     print(
//                                   //       "Facebook login successful: ${user.email}",
//                                   //     );
//                                   //   } else {
//                                   //     print(
//                                   //       "Facebook login failed or canceled.",
//                                   //     );
//                                   //   }
//                                   // } catch (e) {
//                                   //   print("Facebook login error: $e");
//                                   // }
//                                 },

//                                 path: 'assets/facebook_icon.svg',
//                               ),
//                               Gap(10),
//                               IconButtonSvg(
//                                 onPressed: () async {
//                                   // try {
//                                   //   await AuthRepository.instance
//                                   //       .signInWithGithub();
//                                   //   final user =
//                                   //       AuthRepository.instance.currentUser;

//                                   //   if (user != null) {
//                                   //     ScaffoldMessenger.of(
//                                   //       context,
//                                   //     ).showSnackBar(
//                                   //       SnackBar(
//                                   //         content: Text(
//                                   //           'Welcome ${user.email ?? 'User'}!',
//                                   //         ),
//                                   //       ),
//                                   //     );
//                                   //   } else {
//                                   //     ScaffoldMessenger.of(
//                                   //       context,
//                                   //     ).showSnackBar(
//                                   //       const SnackBar(
//                                   //         content: Text(
//                                   //           'GitHub login failed or canceled.',
//                                   //         ),
//                                   //       ),
//                                   //     );
//                                   //   }
//                                   // } catch (e) {
//                                   //   ScaffoldMessenger.of(context).showSnackBar(
//                                   //     SnackBar(
//                                   //       content: Text('GitHub login error: $e'),
//                                   //     ),
//                                   //   );
//                                   // }
//                                 },
//                                 path: 'assets/github_icon.svg',
//                                 color: context.colorScheme.colorlogogithub,
//                               ),
//                             ],
//                           ),
//                           Gap(15),
//                           Image.asset(
//                             'assets/gifrunning_nobackground.gif',
//                             width: 140,
//                             height: 100,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Footer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:coach_workout/config/config.dart';
import 'package:coach_workout/config/theme/color_scheme_extension.dart';
import 'package:coach_workout/features/auth/presentation/screens/register/register.dart';
import 'package:coach_workout/screen/screens.dart';
import 'package:coach_workout/widgets/widgets.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:coach_workout/providers/provider.dart';
import 'package:coach_workout/utils/utils.dart';

class LoginScreen extends StatelessWidget {
  static LoginScreen builder(BuildContext context, GoRouterState state) =>
      LoginScreen();
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();

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
                          Text(
                            'LoginScreen.welcome'.tr(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(10),
                          Column(
                            children: [
                              Text('LoginScreen.agreeing_terms'.tr()),
                              Gap(5),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  'LoginScreen.terms_policy'.tr(),
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
                                  hintText: 'LoginScreen.email_hint'.tr(),
                                  prefixIcon: Icons.email_outlined,
                                ),
                                const Gap(15),
                                CustomTextField(
                                  validator: Validators.validatePassword,
                                  controller: passwordController,
                                  obscureText: !passwordProvider.isVisible,
                                  hintText: 'LoginScreen.password_hint'.tr(),
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
                              Text("LoginScreen.remember_me".tr()),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "LoginScreen.forgot_password".tr(),
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
                                  await Supabase.instance.client.auth
                                      .signInWithOAuth(
                                        OAuthProvider
                                            .google, // 👈 dùng OAuthProvider thay vì Provider
                                        redirectTo:
                                            'coachworkout://login-callback',
                                      );
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colorScheme.primary,
                                  minimumSize: Size(140, 45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  'LoginScreen.login_button'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Gap(10),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
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
                                  'LoginScreen.register_button'.tr(),
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
                          Text('LoginScreen.or_connect'.tr()),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButtonSvg(
                                onPressed: () async {
                                  try {
                                    await Supabase.instance.client.auth
                                        .signInWithOAuth(
                                          OAuthProvider.google,
                                          redirectTo:
                                              'coachworkout://login-callback',
                                          authScreenLaunchMode:
                                              LaunchMode.externalApplication,
                                        );
                                  } catch (e) {
                                    debugPrint('Lỗi đăng nhập Google: $e');
                                  }
                                },
                                path: 'assets/google_icon.svg',
                              ),

                              Gap(10),
                              IconButtonSvg(
                                onPressed: () async {
                                  // try {
                                  //   await AuthRepository.instance
                                  //       .signInWithFacebook();
                                  //   final user =
                                  //       AuthRepository.instance.currentUser;

                                  //   if (user != null) {
                                  //     print(
                                  //       "Facebook login successful: ${user.email}",
                                  //     );
                                  //   } else {
                                  //     print(
                                  //       "Facebook login failed or canceled.",
                                  //     );
                                  //   }
                                  // } catch (e) {
                                  //   print("Facebook login error: $e");
                                  // }
                                },

                                path: 'assets/facebook_icon.svg',
                              ),
                              Gap(10),
                              IconButtonSvg(
                                onPressed: () async {
                                  // try {
                                  //   await AuthRepository.instance
                                  //       .signInWithGithub();
                                  //   final user =
                                  //       AuthRepository.instance.currentUser;

                                  //   if (user != null) {
                                  //     ScaffoldMessenger.of(
                                  //       context,
                                  //     ).showSnackBar(
                                  //       SnackBar(
                                  //         content: Text(
                                  //           'Welcome ${user.email ?? 'User'}!',
                                  //         ),
                                  //       ),
                                  //     );
                                  //   } else {
                                  //     ScaffoldMessenger.of(
                                  //       context,
                                  //     ).showSnackBar(
                                  //       const SnackBar(
                                  //         content: Text(
                                  //           'GitHub login failed or canceled.',
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }
                                  // } catch (e) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: Text('GitHub login error: $e'),
                                  //     ),
                                  //   );
                                  // }
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


