import '../../domain/entities/item.dart';
import '../../domain/entities/item_failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/value_objects/string_value_objects.dart';
import '../../domain/repositories/i_items_repository.dart';
import '../data_sources/seed_items_data_source.dart';

class ItemsRepositoryImpl implements IItemsRepository {
  final IItemsDataSource _dataSource;

  ItemsRepositoryImpl(this._dataSource);

  @override
  Future<(ItemFailure?, List<Item>?)> getAllItems() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();
      return (null, items);
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, List<Item>?)> getItems({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();
      final paginatedItems = items.skip(offset).take(limit).toList();
      return (null, paginatedItems);
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, List<Item>?)> getLatestItems(int count) async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();
      final latest = items.reversed.take(count).toList();
      return (null, latest);
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, List<Item>?)> searchItems(String query) async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();
      final lowercaseQuery = query.toLowerCase();
      final searchResults = items.where((item) {
        return item.title.value.toLowerCase().contains(lowercaseQuery) ||
            item.author.value.toLowerCase().contains(lowercaseQuery) ||
            item.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
      return (null, searchResults);
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, List<Category>?)> getCategories() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();

      final categoryMap = <String, Category>{};
      for (var item in items) {
        final catName = item.category.name.value.toLowerCase();

        if (catName.isEmpty || catName == 'unknown') continue;

        if (!categoryMap.containsKey(catName)) {
          categoryMap[catName] = item.category;
        }
      }

      final sortedCategories = categoryMap.values.toList()
        ..sort((a, b) => a.name.value.compareTo(b.name.value));

      return (null, sortedCategories);
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, List<Author>?)> getAuthors() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();

      final authorMap = <String, Author>{};
      for (var item in items) {
        final authorStr = item.author.value;
        if (!authorMap.containsKey(authorStr)) {
          authorMap[authorStr] = item.author;
        }
      }
      return (null, authorMap.values.toList());
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, List<Topic>?)> getTopics() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();

      final topicMap = <String, Topic>{};
      for (var item in items) {
        final topicStr = item.topic.value;
        if (!topicMap.containsKey(topicStr)) {
          topicMap[topicStr] = item.topic;
        }
      }
      return (null, topicMap.values.toList());
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, List<String>?)> getTags() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();

      final tagsSet = <String>{};
      for (var item in items) {
        tagsSet.addAll(item.tags);
      }
      return (null, tagsSet.toList());
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }
}
