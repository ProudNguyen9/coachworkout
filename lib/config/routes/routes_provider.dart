import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_routes.dart';
import 'routes_location.dart';

class RoutesNotifier with ChangeNotifier {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  RoutesNotifier() {
    // ✅ Lắng nghe trạng thái đăng nhập Supabase
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        navigationKey.currentContext?.go(RouteLocation.home);
      } else if (event == AuthChangeEvent.signedOut) {
        navigationKey.currentContext?.go(RouteLocation.login);
      }
    });
  }

  late final GoRouter router = getAppRoutes(navigationKey);
}
