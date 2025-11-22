import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nomirro_colors.dart';

class DefaultDark {
  static const Color bg = Color(0xFF1E1E1E);
  static const Color sidebar = Color(0xFF252526);
  static const Color editor = Color(0xFF1E1E1E);
  static const Color text = Color(0xFFD4D4D4);
  static const Color comment = Color(0xFF6A9955);
  static const Color keyword = Color(0xFFC586C0);
  static const Color string = Color(0xFFCE9178);
  static const Color blue = Color(0xFF0A84FF);
  static const Color accent = Color(0xFF2EA9E0);
}

final ThemeData defaultDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DefaultDark.bg,
  primaryColor: DefaultDark.blue,
  canvasColor: DefaultDark.editor,
  cardColor: DefaultDark.sidebar,
  fontFamily: GoogleFonts.roboto().fontFamily,
  
  textTheme: GoogleFonts.robotoTextTheme().copyWith(
    bodyMedium: TextStyle(color: DefaultDark.text),
    bodyLarge: TextStyle(color: DefaultDark.text),
    titleLarge: TextStyle(color: DefaultDark.blue, fontWeight: FontWeight.bold),
  ),
  
  appBarTheme: const AppBarTheme(
    backgroundColor: DefaultDark.sidebar,
    foregroundColor: DefaultDark.text,
    elevation: 4,
    shadowColor: Colors.black54,
  ),
  
  iconTheme: const IconThemeData(color: DefaultDark.blue),
  
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: DefaultDark.sidebar.withValues(alpha: 0.9),
    hintStyle: const TextStyle(color: DefaultDark.comment),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: DefaultDark.blue),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: NomirroColors.primary,
      foregroundColor: DefaultDark.text,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      shadowColor: Colors.black87,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  
  cardTheme: CardThemeData(
    color: DefaultDark.sidebar,
    elevation: 8,
    shadowColor: Colors.black54,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: DefaultDark.accent,
    elevation: 8,
  ),
);
