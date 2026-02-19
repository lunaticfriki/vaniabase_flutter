import '../entities/item.dart';
import '../entities/item_failure.dart';

abstract class IItemsRepository {
  Future<(ItemFailure?, List<Item>?)> getAllItems();
}
