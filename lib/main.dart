import 'package:flutter/material.dart';
import 'presentation/router/app_router.dart';
import 'presentation/theme/theme_controller.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController().themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}
