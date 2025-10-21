import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../screen/screens.dart';
import 'routes_location.dart';

GoRouter getAppRoutes(GlobalKey<NavigatorState> navigatorKey) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteLocation.login,

    // ✅ Danh sách route của bạn
    routes: [
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
      GoRoute(
        path: RouteLocation.detail,
        parentNavigatorKey: navigatorKey,
        builder: DetailWorkout.builder,
      ),
      GoRoute(
        path: RouteLocation.workoutexercises,
        parentNavigatorKey: navigatorKey,
        builder: WorkoutScreen.builder,
      ),
      GoRoute(
        path: RouteLocation.animatedcountdown,
        parentNavigatorKey: navigatorKey,
        builder: AnimatedCountdown.builder,
      ),
      GoRoute(
        path: RouteLocation.WorkoutSession,
        parentNavigatorKey: navigatorKey,
        builder: WorkoutSession.builder,
      ),

      // ✅ Supabase callback (chỉ để GoRouter không báo lỗi)
      GoRoute(
        path: '/login-callback',
        parentNavigatorKey: navigatorKey,
        builder: (context, state) {
          debugPrint('✅ [GoRouter] Caught Supabase callback: ${state.uri}');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    ],

    // ✅ Tự động redirect nếu user đã đăng nhập
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final loggedIn = session != null;
      final isAtLogin = state.matchedLocation == RouteLocation.login;
      final isAtCallback = state.matchedLocation == '/login-callback';

      // 🔹 Nếu Supabase trả về callback → bỏ qua not found và về home luôn
      if (isAtCallback && loggedIn) return RouteLocation.home;

      // 🔹 Nếu chưa login mà đang ở trang khác → quay về login
      if (!loggedIn && !isAtLogin) return RouteLocation.login;

      // 🔹 Nếu đã login mà vẫn ở login → chuyển qua home
      if (loggedIn && isAtLogin) return RouteLocation.home;

      return null;
    },

    // // ✅ Nếu GoRouter không khớp route nào → tự về home luôn
    // errorBuilder: (context, state) {
    //   debugPrint('⚠️ [GoRouter] Route not found: ${state.uri}');
    //   final session = Supabase.instance.client.auth.currentSession;
    //   if (session != null) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       context.go(RouteLocation.home);
    //     });
    //   } else {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       context.go(RouteLocation.login);
    //     });
    //   }
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // },
  );
}
