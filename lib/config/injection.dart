import 'package:get_it/get_it.dart';

import '../application/services/items_cubit.dart';
import '../application/services/items_read_service.dart';
import '../domain/repositories/i_items_repository.dart';
import '../infrastructure/data_sources/seed_items_data_source.dart';
import '../infrastructure/repositories/items_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<ItemsCubit>(() => ItemsCubit());
  sl.registerLazySingleton<IItemsReadService>(
    () => ItemsReadService(sl(), sl()),
  );

  sl.registerLazySingleton<IItemsDataSource>(() => SeedItemsDataSource());
  sl.registerLazySingleton<IItemsRepository>(() => ItemsRepositoryImpl(sl()));
}
