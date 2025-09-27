import 'package:flutter/foundation.dart' show immutable;

@immutable
class RouteLocation {
  const RouteLocation._();
 static String get login => '/login';
  static String get home => '/home';
  static String get resetpass => '/resetpass';
  static String get register => '/register';
  static String get onboarding => '/onboarding';
  static String get profilesetup => '/profilesetup';
  static String get wourkoutlibrary => '/wourkoutlibrary';
  static String get profile => '/profile';
}