import 'package:flutter/material.dart';

class NomirroColors {
  static const Color primary = Color(0xFF4B0082); // Purple for primary buttons
  static const Color lightBackground = Color(0xFFF7EAFE); // Light lilac super clear
  static const Color darkBackground = Color(0xFF1E1A22); // Dark purple almost black
  static const Color darkSecondary = Color(0xFF1E293B); // Dark section secondary
  static const Color lightSecondary = Colors.white; // Light section secondary
  static const Color accentDark = Color(0xFFA040A0);
  static const Color accentLight = Color(0xFFF28DF2);
  static const Color accentGreen = Color(0xFF34D399);
  static const Color darkLilac = Color(0xFF9966CC); // Dark lilac for buttons/cards
  static const Color lilac = Color(0xFFC8A0E6); // Light lilac for cards/surfaces
  static const Color cta = Color(0xFFFF4F8B); // Strong pink for CTA
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color neutralLight = Color(0xFFEDEDED);
}

class NomirroThemeColors {
  static const Color primary = NomirroColors.primary;
  static const Color lightBackground = NomirroColors.lightBackground;
  static const Color darkBackground = NomirroColors.darkBackground;
  static const Color darkSecondary = NomirroColors.darkSecondary;
  static const Color lightSecondary = NomirroColors.lightSecondary;
}

class NomirroBrandColors {
  static const Color primary = NomirroColors.primary;
  static const Color accent = Color(0xFF2EA9E0);
  static const Color success = NomirroColors.accentGreen;
  static const Color cta = NomirroColors.cta;
}

class NomirroPalette {
  static const Color lightBg = NomirroColors.lightBackground;
  static const Color lightSurface = NomirroColors.lightSecondary;
  static const Color lightText = NomirroColors.textDark;

  static const Color darkBg = NomirroColors.darkBackground;
  static const Color darkSurface = NomirroColors.darkSecondary;
  static const Color darkText = NomirroColors.textLight;

  static const Color blue = Color(0xFF0A84FF);
  static const Color comment = Color(0xFF6A9955);
}
