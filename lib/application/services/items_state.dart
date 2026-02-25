import 'package:equatable/equatable.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/category.dart';
import '../../domain/value_objects/string_value_objects.dart';

enum ItemsStatus { initial, loading, success, failure }

class ItemsState extends Equatable {
  final ItemsStatus status;
  final List<Item> items;
  final List<Item> searchResults;
  final List<Item> latestItems;
  final List<Category> categories;
  final List<Author> authors;
  final List<Topic> topics;
  final List<String> tags;
  final List<String> publishers;
  final int totalItems;
  final int completedItems;
  final String? errorMessage;
  final bool hasReachedMax;
  const ItemsState({
    this.status = ItemsStatus.initial,
    this.items = const [],
    this.searchResults = const [],
    this.latestItems = const [],
    this.categories = const [],
    this.authors = const [],
    this.topics = const [],
    this.tags = const [],
    this.publishers = const [],
    this.totalItems = 0,
    this.completedItems = 0,
    this.errorMessage,
    this.hasReachedMax = false,
  });
  ItemsState copyWith({
    ItemsStatus? status,
    List<Item>? items,
    List<Item>? searchResults,
    List<Item>? latestItems,
    List<Category>? categories,
    List<Author>? authors,
    List<Topic>? topics,
    List<String>? tags,
    List<String>? publishers,
    int? totalItems,
    int? completedItems,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return ItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      searchResults: searchResults ?? this.searchResults,
      latestItems: latestItems ?? this.latestItems,
      categories: categories ?? this.categories,
      authors: authors ?? this.authors,
      topics: topics ?? this.topics,
      tags: tags ?? this.tags,
      publishers: publishers ?? this.publishers,
      totalItems: totalItems ?? this.totalItems,
      completedItems: completedItems ?? this.completedItems,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    searchResults,
    latestItems,
    categories,
    authors,
    topics,
    tags,
    publishers,
    totalItems,
    completedItems,
    errorMessage,
    hasReachedMax,
  ];
}
