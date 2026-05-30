import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static final ThemeData light = FlexThemeData.light(
    colors: _cyanScheme,

    /// 🔧 FIX SURFACE
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 6,

    scaffoldBackground: Colors.white,
    surface: Colors.white,
    background: Colors.white,

    appBarStyle: FlexAppBarStyle.primary,
    appBarOpacity: 0.95,
    appBarElevation: 0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forBackground,

    fontFamily: GoogleFonts.montserrat().fontFamily,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,

    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      blendOnColors: true,
      blendTextTheme: true,
      fabUseShape: true,
      bottomNavigationBarElevation: 0,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      popupMenuOpacity: 0.95,
      tooltipRadius: 6,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
    ),
  );

  static final ThemeData dark = FlexThemeData.dark(
    colors: _cyanScheme,

    surfaceMode: FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog,
    blendLevel: 30,

    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 0.90,
    appBarElevation: 0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forBackground,

    fontFamily: GoogleFonts.montserrat().fontFamily,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,

    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      blendOnColors: false,
      blendTextTheme: true,
      fabUseShape: true,
      bottomNavigationBarElevation: 0,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      popupMenuOpacity: 0.90,
      tooltipRadius: 6,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
    ),
  );
}

/// 🎨 CYAN SCHEME (giữ nguyên)
const FlexSchemeColor _cyanScheme = FlexSchemeColor(
  primary: Color(0xFF00B5D8),
  primaryContainer: Color(0xFF0097A7),
  secondary: Color(0xFF26C6DA),
  secondaryContainer: Color(0xFFB3A0FF),
  tertiary: Color(0xFF2979FF),
  tertiaryContainer: Color(0xFF1565C0),
);


