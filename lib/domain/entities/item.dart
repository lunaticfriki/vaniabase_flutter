import '../value_objects/completed.dart';
import '../value_objects/string_value_objects.dart';
import '../value_objects/unique_id.dart';
import '../value_objects/year.dart';
import 'category.dart';

class Item {
  final UniqueId id;
  final Title title;
  final Author author;
  final Publisher publisher;
  final List<String> tags;
  final Topic topic;
  final Language language;
  final Cover cover;
  final Description description;
  final Year year;
  final Format format;
  final Reference reference;
  final Category category;
  final Completed completed;
  final UniqueId ownerId;
  final DateTime? createdAt;

  const Item._({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.tags,
    required this.topic,
    required this.language,
    required this.cover,
    required this.description,
    required this.year,
    required this.format,
    required this.reference,
    required this.category,
    required this.completed,
    required this.ownerId,
    this.createdAt,
  });

  static Item create({
    required Title title,
    required Author author,
    required Publisher publisher,
    required List<String> tags,
    required Topic topic,
    required Language language,
    required Cover cover,
    required Description description,
    required Year year,
    required Format format,
    required Reference reference,
    required Category category,
    required Completed completed,
    required UniqueId ownerId,
    DateTime? createdAt,
    UniqueId? id,
  }) {
    return Item._(
      id: id ?? UniqueId(),
      title: title,
      author: author,
      publisher: publisher,
      tags: tags,
      topic: topic,
      language: language,
      cover: cover,
      description: description,
      year: year,
      format: format,
      reference: reference,
      category: category,
      completed: completed,
      ownerId: ownerId,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static Item fromJson(dynamic json) {
    try {
      final categoryData = json['category'];
      String categoryId = 'unknown-id';
      String categoryName = 'Unknown';

      if (categoryData is Map) {
        categoryId = (categoryData['id']?.toString() ?? 'unknown-id').trim();
        categoryName = (categoryData['name']?.toString() ?? 'Unknown').trim();
      } else if (categoryData is String) {
        categoryId = categoryData.trim();
        categoryName = categoryData.trim();
      }

      return Item.create(
        id: UniqueId.fromUniqueString((json['id']?.toString() ?? '').trim()),
        title: Title((json['title']?.toString() ?? '').trim()),
        author: Author((json['author']?.toString() ?? '').trim()),
        publisher: Publisher((json['publisher']?.toString() ?? '').trim()),
        tags: List<String>.from(
          (json['tags'] as List<dynamic>? ?? []).map(
            (t) => t.toString().trim(),
          ),
        ),
        topic: Topic((json['topic']?.toString() ?? '').trim()),
        language: Language((json['language']?.toString() ?? '').trim()),
        cover: Cover((json['cover']?.toString() ?? '').trim()),
        description: Description(
          (json['description']?.toString() ?? '').trim(),
        ),
        year: Year(int.tryParse(json['year']?.toString().trim() ?? '') ?? 0),
        format: Format((json['format']?.toString() ?? '').trim()),
        reference: Reference((json['reference']?.toString() ?? '').trim()),
        category: Category.create(
          id: UniqueId.fromUniqueString(categoryId),
          name: Name(categoryName),
        ),
        completed: Completed(json['completed'] ?? false),
        ownerId: UniqueId.fromUniqueString(
          (json['owner']?.toString() ?? 'default-owner').trim(),
        ),
        createdAt: json['created_at'] != null
            ? (json['created_at'] is int
                  ? DateTime.fromMillisecondsSinceEpoch(
                      json['created_at'] as int,
                    )
                  : DateTime.tryParse(json['created_at'].toString()))
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Item empty() {
    return Item._(
      id: UniqueId(),
      title: const Title(''),
      author: const Author(''),
      publisher: const Publisher(''),
      tags: const [],
      topic: const Topic(''),
      language: const Language(''),
      cover: const Cover(''),
      description: const Description(''),
      year: const Year(0),
      format: const Format(''),
      reference: const Reference(''),
      category: Category.empty(),
      completed: const Completed(false),
      ownerId: UniqueId(),
      createdAt: DateTime.now(),
    );
  }
}
