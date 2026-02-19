import '../../domain/entities/item.dart';
import '../../domain/entities/item_failure.dart';
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
}
