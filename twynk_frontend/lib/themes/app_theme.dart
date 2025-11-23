import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nomirro_flex_scheme.dart';

class AppTheme {
  AppTheme._();

  static final String? _fontFamily = GoogleFonts.roboto().fontFamily;

  /// Light Theme
  static ThemeData light = FlexThemeData.light(
    colors: NomirroFlexScheme.schemeColors,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 12,
    appBarStyle: FlexAppBarStyle.primary,
    fontFamily: _fontFamily,
    useMaterial3: true,
  );

  /// Dark Theme
  static ThemeData dark = FlexThemeData.dark(
    colors: NomirroFlexScheme.darkSchemeColors,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 22,
    appBarStyle: FlexAppBarStyle.primary,
    fontFamily: _fontFamily,
    useMaterial3: true,
  );
}
