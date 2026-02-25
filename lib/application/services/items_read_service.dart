import 'dart:async';
import '../../domain/repositories/i_items_repository.dart';
import '../../domain/entities/item_failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/value_objects/string_value_objects.dart';
import 'items_cubit.dart';
import '../../domain/entities/item.dart';

abstract class IItemsReadService {
  void retain();
  void release();
  void searchItems(String query);
}

class ItemsReadService implements IItemsReadService {
  final IItemsRepository _repository;
  final ItemsCubit _cubit;

  StreamSubscription<(ItemFailure?, List<Item>?)>? _subscription;
  Timer? _disconnectTimer;
  int _refCount = 0;
  final int _disconnectDelaySeconds = 8;

  ItemsReadService(this._repository, this._cubit);

  @override
  void retain() {
    _refCount++;
    _disconnectTimer?.cancel();
    _disconnectTimer = null;

    if (_subscription == null) {
      _cubit.emitLoading();

      _subscription = _repository.watchAllItems().listen((result) {
        final failure = result.$1;
        final items = result.$2 ?? [];

        if (failure != null) {
          _cubit.emitError(failure.message);
          return;
        }

        _cubit.updateItems(items, hasReachedMax: true);
        _cubit.updateLatestItems(items.take(5).toList());

        final categoryMap = <String, Category>{};
        final authorMap = <String, Author>{};
        final topicMap = <String, Topic>{};
        final tagsSet = <String>{};
        final publisherSet = <String>{};

        for (var item in items) {
          final catName = item.category.name.value.toLowerCase();
          if (catName.isNotEmpty &&
              catName != 'unknown' &&
              !categoryMap.containsKey(catName)) {
            categoryMap[catName] = item.category;
          }

          final authorStr = item.author.value;
          if (!authorMap.containsKey(authorStr)) {
            authorMap[authorStr] = item.author;
          }

          final topicStr = item.topic.value;
          if (!topicMap.containsKey(topicStr)) topicMap[topicStr] = item.topic;

          tagsSet.addAll(item.tags);

          final pubStr = item.publisher.value;
          if (pubStr.isNotEmpty && pubStr.toLowerCase() != 'unknown') {
            publisherSet.add(pubStr);
          }
        }

        final sortedCategories = categoryMap.values.toList()
          ..sort((a, b) => a.name.value.compareTo(b.name.value));
        _cubit.updateCategories(sortedCategories);
        _cubit.updateAuthors(authorMap.values.toList());
        _cubit.updateTopics(topicMap.values.toList());
        _cubit.updateTags(tagsSet.toList());

        final sortedPublishers = publisherSet.toList()..sort();
        _cubit.updatePublishers(sortedPublishers);

        final completed = items.where((i) => i.completed.value).length;
        _cubit.updateStats(items.length, completed);
      });
    }
  }

  @override
  void release() {
    _refCount--;
    if (_refCount <= 0) {
      _refCount = 0;
      _disconnectTimer?.cancel();
      _disconnectTimer = Timer(Duration(seconds: _disconnectDelaySeconds), () {
        _subscription?.cancel();
        _subscription = null;
      });
    }
  }

  @override
  void searchItems(String query) {
    final currentState = _cubit.state;
    final allItems = currentState.items;

    if (query.isEmpty) {
      _cubit.updateSearchResults([]);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final searchResults = allItems.where((item) {
      return item.title.value.toLowerCase().contains(lowercaseQuery) ||
          item.author.value.toLowerCase().contains(lowercaseQuery) ||
          item.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();

    _cubit.updateSearchResults(searchResults);
  }
}
