import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'presentation/router/app_router.dart';
import 'presentation/theme/app_theme.dart';

import 'config/injection.dart' as di;
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'application/services/auth_cubit.dart';
import 'application/services/items_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }
  await di.init();

  di.sl<AuthCubit>().checkAuthStatus();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()),
        BlocProvider<ItemsCubit>(create: (_) => di.sl<ItemsCubit>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
      ),
    );
  }
}
