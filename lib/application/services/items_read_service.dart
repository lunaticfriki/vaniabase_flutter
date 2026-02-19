import '../../domain/repositories/i_items_repository.dart';
import 'items_cubit.dart';

abstract class IItemsReadService {
  Future<void> fetchItems();
}

class ItemsReadService implements IItemsReadService {
  final IItemsRepository _repository;
  final ItemsCubit _cubit;

  ItemsReadService(this._repository, this._cubit);

  @override
  Future<void> fetchItems() async {
    _cubit.emitLoading();
    final (failure, items) = await _repository.getAllItems();

    if (failure != null) {
      _cubit.emitError(failure.message);
    } else if (items != null) {
      _cubit.emitLoaded(items);
    } else {
      _cubit.emitError('Unknown error occurred');
    }
  }
}
