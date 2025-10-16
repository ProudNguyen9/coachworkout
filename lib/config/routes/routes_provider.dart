import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'routes_location.dart';

class RoutesNotifier with ChangeNotifier {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    initialLocation: RouteLocation.detail,
    navigatorKey: navigationKey,
    routes: getAppRoutes(navigationKey),
  );
}
