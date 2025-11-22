import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nomirro_colors.dart';

class DefaultLight {
  static const Color bg = Color(0xFFFFFFFF);
  static const Color sidebar = Color(0xFFF3F3F3);
  static const Color editor = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1E1E1E);
  static const Color comment = Color(0xFF008000);
  static const Color keyword = Color(0xFF0000FF);
  static const Color string = Color(0xFFA31515);
  static const Color blue = Color(0xFF0A84FF);
  static const Color accent = Color(0xFF2ea9e0); 
}

ThemeData defaultLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: DefaultLight.bg,
  primaryColor: NomirroColors.primary,
  cardColor: DefaultLight.sidebar,
  canvasColor: DefaultLight.editor,
  fontFamily: 'Roboto',
  textTheme: GoogleFonts.robotoTextTheme(
    const TextTheme(
      bodyMedium: TextStyle(color: DefaultLight.text),
      bodyLarge: TextStyle(color: DefaultLight.text),
      titleLarge: TextStyle(color: DefaultLight.blue, fontWeight: FontWeight.bold),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: DefaultLight.sidebar,
    foregroundColor: DefaultLight.text,
    elevation: 4,
    shadowColor: Colors.black26,
  ),
  iconTheme: const IconThemeData(color: DefaultLight.blue),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: DefaultLight.sidebar.withAlpha(230),
    hintStyle: const TextStyle(color: DefaultLight.comment),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: DefaultLight.blue),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: NomirroColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      shadowColor: Colors.black26,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, color: DefaultLight.text),
    ),
  ),
  cardTheme: CardThemeData(
    color: DefaultLight.sidebar,
    elevation: 8,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: DefaultLight.accent,
    elevation: 8,
  ),
);