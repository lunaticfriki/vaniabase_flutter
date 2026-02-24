import '../../domain/entities/item.dart';
import '../../domain/repositories/i_items_repository.dart';
import '../../domain/repositories/i_storage_repository.dart';
import 'items_write_cubit.dart';

abstract class IItemsWriteService {
  Future<void> createItem(Item item);
  Future<void> updateItem(Item item);
  Future<void> deleteItem(Item item);
}

class ItemsWriteService implements IItemsWriteService {
  final IItemsRepository _repository;
  final IStorageRepository _storageRepository;
  final ItemsWriteCubit _cubit;

  ItemsWriteService(this._repository, this._storageRepository, this._cubit);

  @override
  Future<void> createItem(Item item) async {
    _cubit.emitLoading();
    final failure = await _repository.createItem(item);

    if (failure != null) {
      _cubit.emitFailure(failure.message);
    } else {
      _cubit.emitSuccess();
    }
  }

  @override
  Future<void> updateItem(Item item) async {
    _cubit.emitLoading();
    final failure = await _repository.updateItem(item);

    if (failure != null) {
      _cubit.emitFailure(failure.message);
    } else {
      _cubit.emitSuccess();
    }
  }

  @override
  Future<void> deleteItem(Item item) async {
    _cubit.emitLoading();

    if (item.cover.value.isNotEmpty) {
      await _storageRepository.deleteItemCover(item.cover.value);
    }

    final failure = await _repository.deleteItem(item.id);

    if (failure != null) {
      _cubit.emitFailure(failure.message);
    } else {
      _cubit.emitSuccess();
    }
  }
}
