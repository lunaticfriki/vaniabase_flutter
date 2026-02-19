import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color _violet = Color.fromARGB(255, 77, 19, 95);
  static const Color _lima = Color.fromARGB(255, 105, 230, 3);
  static const Color _yellow = Color.fromARGB(255, 255, 189, 7);

  // Background Colors
  static const Color _darkBackground = Color(0xFF1E1E1E);
  static const Color _lightBackground = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.inconsolata().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _violet,
      brightness: Brightness.light,
      primary: _violet,
      secondary: _lima,
      tertiary: _yellow,
      surface: _lightBackground,
    ),
    scaffoldBackgroundColor: _lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: _violet,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.inconsolata().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _violet,
      brightness: Brightness.dark,
      primary: _violet,
      secondary: _lima,
      tertiary: _yellow,
      surface:
          _darkBackground, // For cards/bottom sheets to blend or slightly distinct
    ),
    scaffoldBackgroundColor: _darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackground,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: _darkBackground),
  );
}
