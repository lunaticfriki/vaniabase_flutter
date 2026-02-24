import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cyberpunk_styling.dart';

class AppTheme {
  static const Color _violet = Color(0xFF2E004F);
  static const Color _magenta = Color(0xFFFF00FF);
  static const Color _yellow = Color(0xFFFFFF00);

  static const Color _darkBackground = Color(0xFF242424);
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.inconsolata().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _violet,
      brightness: Brightness.dark,
      primary: _violet,
      secondary: _magenta,
      tertiary: _yellow,
      surface: _darkBackground,
    ),
    scaffoldBackgroundColor: _darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackground,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: _darkBackground),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _darkBackground,
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: GoogleFonts.inconsolata().fontFamily,
      ),
      shape: CyberpunkStyling.getCutEdgeBorder(
        borderColor: _magenta,
        borderWidth: 1.5,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
