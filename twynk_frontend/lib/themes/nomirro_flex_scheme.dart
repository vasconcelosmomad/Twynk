import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'nomirro_colors.dart';

class NomirroFlexScheme {
  const NomirroFlexScheme._();

  static const FlexSchemeColor schemeColors = FlexSchemeColor(
    primary: NomirroBrandColors.primary,
    primaryContainer: NomirroPalette.lightBg,
    secondary: NomirroBrandColors.accent,
    secondaryContainer: NomirroPalette.lightSurface,
    tertiary: NomirroBrandColors.cta,
    tertiaryContainer: Color(0xFFFFD0E1),
    appBarColor: NomirroBrandColors.primary,
  );

  static const FlexSchemeColor darkSchemeColors = FlexSchemeColor(
    primary: NomirroBrandColors.primary,
    primaryContainer: NomirroPalette.darkBg,
    secondary: NomirroBrandColors.accent,
    secondaryContainer: NomirroPalette.darkSurface,
    tertiary: NomirroBrandColors.cta,
    tertiaryContainer: Color(0xFF5C1227),
    appBarColor: NomirroBrandColors.primary,
  );
}
