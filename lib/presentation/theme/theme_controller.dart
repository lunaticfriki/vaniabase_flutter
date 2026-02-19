import 'package:flutter/material.dart';

class ThemeController {
  // Singleton instance
  static final ThemeController _instance = ThemeController._internal();
  factory ThemeController() => _instance;
  ThemeController._internal();

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  void toggleTheme() {
    if (themeNotifier.value == ThemeMode.light) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }

  void setTheme(ThemeMode mode) {
    themeNotifier.value = mode;
  }
}
