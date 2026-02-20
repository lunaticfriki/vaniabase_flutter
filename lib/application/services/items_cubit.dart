import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaniabase/domain/entities/category.dart';
import 'package:vaniabase/domain/value_objects/string_value_objects.dart';
import 'items_state.dart';
import '../../domain/entities/item.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(const ItemsState());

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
}
