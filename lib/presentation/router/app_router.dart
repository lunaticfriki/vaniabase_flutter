import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../config/injection.dart';
import '../../application/services/auth_cubit.dart';
import '../../application/services/auth_state.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';
import '../screens/all_items_screen.dart';
import '../screens/search_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/authors_screen.dart';
import '../screens/topics_screen.dart';
import '../screens/tags_screen.dart';
import '../screens/login_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static GoRouter get router => _router;
  static final _router = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),
    redirect: (context, state) {
      final authState = sl<AuthCubit>().state;
      final isLoggingIn = state.matchedLocation == '/login';

      if (authState is Unauthenticated || authState is AuthInitial) {
        if (!isLoggingIn) return '/login';
      } else if (authState is Authenticated) {
        if (isLoggingIn) return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      GoRoute(
        path: '/all-items',
        builder: (context, state) => const AllItemsScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/authors',
        builder: (context, state) => const AuthorsScreen(),
      ),
      GoRoute(
        path: '/topics',
        builder: (context, state) => const TopicsScreen(),
      ),
      GoRoute(path: '/tags', builder: (context, state) => const TagsScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ],
  );
}
