import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screen/screens.dart';
import 'routes_location.dart';

List<GoRoute> getAppRoutes(GlobalKey<NavigatorState> navigatorKey) {
  return [
    GoRoute(
      path: RouteLocation.home,
      parentNavigatorKey: navigatorKey,
      builder: HomeScreen.builder,
    ),
    GoRoute(
      path: RouteLocation.login,
      parentNavigatorKey: navigatorKey,
      builder: LoginScreen.builder,
    ),
    GoRoute(
      path: RouteLocation.register,
      parentNavigatorKey: navigatorKey,
      builder: RegisterScreen.builder,
    ),
    GoRoute(
      path: RouteLocation.resetpass,
      parentNavigatorKey: navigatorKey,
      builder: ResetPasswordScreen.builder,
    ),
    GoRoute(
      path: RouteLocation.onboarding,
      parentNavigatorKey: navigatorKey,
      builder: OnboardingScreen.builder,
    ),
    GoRoute(
      path: RouteLocation.profilesetup,
      parentNavigatorKey: navigatorKey,
      builder: ProfileSetupScreen.builder,
    ),
    GoRoute(
      path: RouteLocation.wourkoutlibrary,
      parentNavigatorKey: navigatorKey,
      builder: WorkoutLibraryScreen.builder,
    ),
    GoRoute(
      path: RouteLocation.profile,
      parentNavigatorKey: navigatorKey,
      builder: ProfileScreen.builder,
    ),
  
  ];
}
