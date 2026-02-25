import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaniabase/domain/entities/category.dart';
import 'package:vaniabase/domain/value_objects/string_value_objects.dart';
import 'items_state.dart';
import '../../domain/entities/item.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final void Function() onRetain;
  final void Function() onRelease;

  ItemsCubit({required this.onRetain, required this.onRelease})
    : super(const ItemsState());

  void retain() {
    onRetain();
  }

  void release() {
    onRelease();
  }

  void emitLoading() {
    emit(state.copyWith(status: ItemsStatus.loading));
  }

  void emitError(String message) {
    emit(state.copyWith(status: ItemsStatus.failure, errorMessage: message));
  }

  void updateItems(List<Item> items, {bool hasReachedMax = false}) {
    emit(
      state.copyWith(
        status: ItemsStatus.success,
        items: items,
        hasReachedMax: hasReachedMax,
      ),
    );
  }

  void updateSearchResults(List<Item> searchResults) {
    emit(
      state.copyWith(status: ItemsStatus.success, searchResults: searchResults),
    );
  }

  void updateLatestItems(List<Item> latestItems) {
    emit(state.copyWith(status: ItemsStatus.success, latestItems: latestItems));
  }

  void updateCategories(List<Category> categories) {
    emit(state.copyWith(status: ItemsStatus.success, categories: categories));
  }

  void updateAuthors(List<Author> authors) {
    emit(state.copyWith(status: ItemsStatus.success, authors: authors));
  }

  void updateTopics(List<Topic> topics) {
    emit(state.copyWith(status: ItemsStatus.success, topics: topics));
  }

  void updateTags(List<String> tags) {
    emit(state.copyWith(status: ItemsStatus.success, tags: tags));
  }

  void updatePublishers(List<String> publishers) {
    emit(state.copyWith(status: ItemsStatus.success, publishers: publishers));
  }

  void updateStats(int totalItems, int completedItems) {
    emit(
      state.copyWith(
        status: ItemsStatus.success,
        totalItems: totalItems,
        completedItems: completedItems,
      ),
    );
  }

  void clear() {
    emit(const ItemsState());
  }
}
