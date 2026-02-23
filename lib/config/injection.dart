import 'package:get_it/get_it.dart';

import '../application/services/auth_cubit.dart';
import '../application/services/items_cubit.dart';
import '../application/services/items_read_service.dart';
import '../domain/repositories/i_items_repository.dart';
import '../domain/repositories/i_auth_repository.dart';
import '../infrastructure/data_sources/seed_items_data_source.dart';
import '../infrastructure/data_sources/firestore_items_data_source.dart';
import '../infrastructure/repositories/items_repository_impl.dart';
import '../infrastructure/repositories/firebase_auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<ItemsCubit>(() => ItemsCubit());
  sl.registerLazySingleton<IItemsReadService>(
    () => ItemsReadService(sl(), sl()),
  );

  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Auth
  sl.registerLazySingleton<IAuthRepository>(
    () => FirebaseAuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl()));

  // Items Data Source (Replacing Seed with Firestore)
  sl.registerLazySingleton<IItemsDataSource>(
    () => FirestoreItemsDataSource(sl(), sl()),
  );

  sl.registerLazySingleton<IItemsRepository>(() => ItemsRepositoryImpl(sl()));
}
