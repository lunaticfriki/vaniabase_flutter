import 'dart:async';
import '../../domain/repositories/i_items_repository.dart';
import '../../domain/entities/item_failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/value_objects/string_value_objects.dart';
import 'items_cubit.dart';
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
  StreamSubscription<(ItemFailure?, List<Item>?)>? _subscription;
  ItemsReadService(this._repository, this._cubit) {
    _initStream();
  }
  void _initStream() {
    _subscription?.cancel();
    _cubit.emitLoading();
    _subscription = _repository.watchAllItems().listen((result) {
      final failure = result.$1;
      final items = result.$2 ?? [];
      if (failure != null) {
        _cubit.emitError(failure.message);
        return;
      }
      _cubit.updateItems(items, hasReachedMax: true);
      final latestItems = items.take(5).toList();
      _cubit.updateLatestItems(latestItems);
      final categoryMap = <String, Category>{};
      for (var item in items) {
        final catName = item.category.name.value.toLowerCase();
        if (catName.isNotEmpty && catName != 'unknown') {
          if (!categoryMap.containsKey(catName)) {
            categoryMap[catName] = item.category;
          }
        }
      }
      final sortedCategories = categoryMap.values.toList()
        ..sort((a, b) => a.name.value.compareTo(b.name.value));
      _cubit.updateCategories(sortedCategories);
      final authorMap = <String, Author>{};
      for (var item in items) {
        final authorStr = item.author.value;
        if (!authorMap.containsKey(authorStr)) {
          authorMap[authorStr] = item.author;
        }
      }
      _cubit.updateAuthors(authorMap.values.toList());
      final topicMap = <String, Topic>{};
      for (var item in items) {
        final topicStr = item.topic.value;
        if (!topicMap.containsKey(topicStr)) {
          topicMap[topicStr] = item.topic;
        }
      }
      _cubit.updateTopics(topicMap.values.toList());
      final tagsSet = <String>{};
      for (var item in items) {
        tagsSet.addAll(item.tags);
      }
      _cubit.updateTags(tagsSet.toList());
      final publisherSet = <String>{};
      for (var item in items) {
        final pubStr = item.publisher.value;
        if (pubStr.isNotEmpty && pubStr.toLowerCase() != 'unknown') {
          publisherSet.add(pubStr);
        }
      }
      final sortedPublishers = publisherSet.toList()..sort();
      _cubit.updatePublishers(sortedPublishers);
      final completed = items.where((i) => i.completed.value).length;
      _cubit.updateStats(items.length, completed);
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  @override
  Future<void> fetchAllItems({bool refresh = false}) async {
    if (refresh) {
      _initStream();
    }
  }

  @override
  Future<void> fetchLatestItems() async {}
  @override
  Future<void> searchItems(String query) async {
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

  @override
  Future<void> fetchCategories() async {}
  @override
  Future<void> fetchAuthors() async {}
  @override
  Future<void> fetchTopics() async {}
  @override
  Future<void> fetchTags() async {}
  @override
  Future<void> fetchPublishers() async {}
  @override
  Future<void> fetchStats() async {}
}
