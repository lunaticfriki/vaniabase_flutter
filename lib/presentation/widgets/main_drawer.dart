import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme_controller.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.pop(); // Close the drawer
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              context.pop(); // Close the drawer
              context.go('/about');
            },
          ),
          const Divider(),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController().themeNotifier,
            builder: (context, themeMode, _) {
              final isDark =
                  themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system &&
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark);
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: isDark,
                activeTrackColor: Theme.of(context).colorScheme.secondary,
                onChanged: (value) {
                  ThemeController().toggleTheme();
                },
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              );
            },
          ),
        ],
      ),
    );
  }
}
