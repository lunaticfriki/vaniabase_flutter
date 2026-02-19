import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    ],
  );
}
