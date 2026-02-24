import '../entities/item.dart';
import '../entities/item_failure.dart';
import '../entities/category.dart';
import '../value_objects/string_value_objects.dart';
import '../value_objects/unique_id.dart';

abstract class IItemsRepository {
  Future<(ItemFailure?, List<Item>?)> getAllItems();
  Future<(ItemFailure?, List<Item>?)> getItems({
    int limit = 10,
    int offset = 0,
  });
  Future<(ItemFailure?, List<Item>?)> getLatestItems(int count);
  Future<(ItemFailure?, List<Item>?)> searchItems(String query);
  Future<(ItemFailure?, List<Category>?)> getCategories();
  Future<(ItemFailure?, List<Author>?)> getAuthors();
  Future<(ItemFailure?, List<Topic>?)> getTopics();
  Future<(ItemFailure?, List<String>?)> getTags();
  Future<(ItemFailure?, List<String>?)> getPublishers();
  Future<(ItemFailure?, int, int)> getStats();
  Future<ItemFailure?> createItem(Item item);
  Future<ItemFailure?> updateItem(Item item);
  Future<ItemFailure?> deleteItem(UniqueId id);
}
