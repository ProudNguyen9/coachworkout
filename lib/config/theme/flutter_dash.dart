import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: _primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: _primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: _primary.withValues(alpha: 0.14),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _primary);
        }
        return const IconThemeData(color: Colors.grey);
      }),
    ),
    inputDecorationTheme: OutlineInputBorderTheme.inputDecorationTheme,
    popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(elevation: 6),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF101820),
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: _secondary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: _secondary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: _secondary.withValues(alpha: 0.18),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _secondary);
        }
        return const IconThemeData(color: Colors.grey);
      }),
    ),
    inputDecorationTheme: OutlineInputBorderTheme.inputDecorationTheme,
    popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF101820)),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(elevation: 6),
  );
}

abstract final class OutlineInputBorderTheme {
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _primary, width: 2),
    ),
  );
}

const Color _primary = Color(0xFF00B5D8);
const Color _primaryContainer = Color(0xFF0097A7);
const Color _secondary = Color(0xFF26C6DA);
const Color _secondaryContainer = Color(0xFFB3A0FF);
const Color _tertiary = Color(0xFF2979FF);
const Color _tertiaryContainer = Color(0xFF1565C0);

const ColorScheme _lightColorScheme = ColorScheme.light(
  primary: _primary,
  primaryContainer: _primaryContainer,
  secondary: _secondary,
  secondaryContainer: _secondaryContainer,
  tertiary: _tertiary,
  tertiaryContainer: _tertiaryContainer,
  surface: Colors.white,
);

const ColorScheme _darkColorScheme = ColorScheme.dark(
  primary: _primary,
  primaryContainer: _primaryContainer,
  secondary: _secondary,
  secondaryContainer: _secondaryContainer,
  tertiary: _tertiary,
  tertiaryContainer: _tertiaryContainer,
  surface: Color(0xFF101820),
);
