import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';
import '../screens/all_items_screen.dart';
import '../screens/search_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/authors_screen.dart';
import '../screens/topics_screen.dart';
import '../screens/tags_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
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
    ],
  );
}
