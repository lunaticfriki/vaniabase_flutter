import '../../domain/repositories/i_items_repository.dart';
import 'items_cubit.dart';
import 'items_state.dart';
import '../../domain/entities/item.dart';

abstract class IItemsReadService {
  Future<void> fetchAllItems({bool refresh = false});
  Future<void> fetchLatestItems();
  Future<void> searchItems(String query);
  Future<void> fetchCategories();
  Future<void> fetchAuthors();
  Future<void> fetchTopics();
  Future<void> fetchTags();
  Future<void> fetchPublishers();
  Future<void> fetchStats();
}

class ItemsReadService implements IItemsReadService {
  final IItemsRepository _repository;
  final ItemsCubit _cubit;
  final int _limit = 10;

  ItemsReadService(this._repository, this._cubit);

  @override
  Future<void> fetchAllItems({bool refresh = false}) async {
    final currentState = _cubit.state;
    if (currentState.status == ItemsStatus.loading && !refresh) return;

    int offset = 0;
    List<Item> currentItems = [];

    if (!refresh && currentState.status == ItemsStatus.success) {
      if (currentState.hasReachedMax) return;
      currentItems = currentState.items;
      offset = currentItems.length;
    } else {
      _cubit.emitLoading();
    }

    final (failure, newItems) = await _repository.getItems(
      limit: _limit,
      offset: offset,
    );

    if (failure != null) {
      _cubit.emitError(failure.message);
    } else if (newItems != null) {
      final hasReachedMax = newItems.isEmpty || newItems.length < _limit;
      _cubit.updateItems(
        refresh ? newItems : (List.of(currentItems)..addAll(newItems)),
        hasReachedMax: hasReachedMax,
      );
    } else {
      _cubit.emitError('Unknown error occurred');
    }
  }

  @override
  Future<void> fetchLatestItems() async {
    _cubit.emitLoading();
    final (failure, items) = await _repository.getLatestItems(5);

    if (failure != null) {
      _cubit.emitError(failure.message);
    } else if (items != null) {
      _cubit.updateLatestItems(items);
    } else {
      _cubit.emitError('Unknown error occurred');
    }
  }

  @override
  Future<void> searchItems(String query) async {
    if (query.isEmpty) {
      _cubit.updateSearchResults([]);
      return;
    }

    _cubit.emitLoading();
    final (failure, items) = await _repository.searchItems(query);

    if (failure != null) {
      _cubit.emitError(failure.message);
    } else if (items != null) {
      _cubit.updateSearchResults(items);
    } else {
      _cubit.emitError('Unknown error occurred');
    }
  }

  @override
  Future<void> fetchCategories() async {
    _cubit.emitLoading();
    final (failure, items) = await _repository.getCategories();
    if (failure != null) {
      _cubit.emitError(failure.message);
    } else {
      _cubit.updateCategories(items ?? []);
    }
  }

  @override
  Future<void> fetchAuthors() async {
    _cubit.emitLoading();
    final (failure, items) = await _repository.getAuthors();
    if (failure != null) {
      _cubit.emitError(failure.message);
    } else {
      _cubit.updateAuthors(items ?? []);
    }
  }

  @override
  Future<void> fetchTopics() async {
    _cubit.emitLoading();
    final (failure, items) = await _repository.getTopics();
    if (failure != null) {
      _cubit.emitError(failure.message);
    } else {
      _cubit.updateTopics(items ?? []);
    }
  }

  @override
  Future<void> fetchTags() async {
    _cubit.emitLoading();
    final (failure, items) = await _repository.getTags();
    if (failure != null) {
      _cubit.emitError(failure.message);
    } else {
      _cubit.updateTags(items ?? []);
    }
  }

  @override
  Future<void> fetchPublishers() async {
    _cubit.emitLoading();
    final (failure, items) = await _repository.getPublishers();
    if (failure != null) {
      _cubit.emitError(failure.message);
    } else {
      _cubit.updatePublishers(items ?? []);
    }
  }

  @override
  Future<void> fetchStats() async {
    _cubit.emitLoading();
    final (failure, total, completed) = await _repository.getStats();
    if (failure != null) {
      _cubit.emitError(failure.message);
    } else {
      _cubit.updateStats(total, completed);
    }
  }
}
