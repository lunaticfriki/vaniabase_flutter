import '../../domain/entities/item.dart';
import '../../domain/entities/item_failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/value_objects/string_value_objects.dart';
import '../../domain/value_objects/unique_id.dart';
import '../../domain/repositories/i_items_repository.dart';
import '../data_sources/seed_items_data_source.dart';

class ItemsRepositoryImpl implements IItemsRepository {
  final IItemsDataSource _dataSource;
  ItemsRepositoryImpl(this._dataSource);
  @override
  Stream<(ItemFailure?, List<Item>?)> watchAllItems() {
    return _dataSource.watchItems().map((rawData) {
      try {
        final items = rawData.map((e) => Item.fromJson(e)).toList();
        final sortedItems = items.reversed.toList();
        sortedItems.sort(
          (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
        );
        return (null, sortedItems);
      } catch (e) {
        return (ItemUnexpectedFailure(e.toString()), null);
      }
    });
  }

  @override
  Future<(ItemFailure?, List<Item>?)> getAllItems() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();
      final sortedItems = items.reversed.toList();
      sortedItems.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
      return (null, sortedItems);
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
      final sortedItems = items.reversed.toList();
      sortedItems.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
      final paginatedItems = sortedItems.skip(offset).take(limit).toList();
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
      final sortedItems = items.reversed.toList();
      sortedItems.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
      final latest = sortedItems.take(count).toList();
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
      final sortedItems = items.reversed.toList();
      sortedItems.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
      final lowercaseQuery = query.toLowerCase();
      final searchResults = sortedItems.where((item) {
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

  @override
  Future<(ItemFailure?, List<String>?)> getPublishers() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();
      final publisherSet = <String>{};
      for (var item in items) {
        final pubStr = item.publisher.value;
        if (pubStr.isNotEmpty && pubStr.toLowerCase() != 'unknown') {
          publisherSet.add(pubStr);
        }
      }
      return (null, publisherSet.toList()..sort());
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), null);
    }
  }

  @override
  Future<(ItemFailure?, int, int)> getStats() async {
    try {
      final rawData = await _dataSource.fetchItems();
      final items = rawData.map((e) => Item.fromJson(e)).toList();
      final total = items.length;
      final completed = items.where((i) => i.completed.value).length;
      return (null, total, completed);
    } catch (e) {
      return (ItemUnexpectedFailure(e.toString()), 0, 0);
    }
  }

  @override
  Future<ItemFailure?> createItem(Item item) async {
    try {
      final map = {
        'id': item.id.value,
        'title': item.title.value,
        'author': item.author.value,
        'publisher': item.publisher.value,
        'tags': item.tags,
        'topic': item.topic.value,
        'language': item.language.value,
        'cover': item.cover.value,
        'description': item.description.value,
        'year': item.year.value,
        'format': item.format.value,
        'reference': item.reference.value,
        'category': {
          'id': item.category.id.value,
          'name': item.category.name.value,
        },
        'completed': item.completed.value,
        'owner': item.ownerId.value,
        'created_at': (item.createdAt ?? DateTime.now()).millisecondsSinceEpoch,
      };
      await _dataSource.createItem(map);
      return null;
    } catch (e) {
      return ItemUnexpectedFailure(e.toString());
    }
  }

  @override
  Future<ItemFailure?> updateItem(Item item) async {
    try {
      final map = {
        'id': item.id.value,
        'title': item.title.value,
        'author': item.author.value,
        'publisher': item.publisher.value,
        'tags': item.tags,
        'topic': item.topic.value,
        'language': item.language.value,
        'cover': item.cover.value,
        'description': item.description.value,
        'year': item.year.value,
        'format': item.format.value,
        'reference': item.reference.value,
        'category': {
          'id': item.category.id.value,
          'name': item.category.name.value,
        },
        'completed': item.completed.value,
        'owner': item.ownerId.value,
        'created_at': item.createdAt?.millisecondsSinceEpoch,
      };
      map.removeWhere((key, value) => value == null);
      await _dataSource.updateItem(map);
      return null;
    } catch (e) {
      return ItemUnexpectedFailure(e.toString());
    }
  }

  @override
  Future<ItemFailure?> deleteItem(UniqueId id) async {
    try {
      await _dataSource.deleteItem(id.value);
      return null;
    } catch (e) {
      return ItemUnexpectedFailure(e.toString());
    }
  }
}
