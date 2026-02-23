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
    );
  }

  static Item fromJson(dynamic json) {
    try {
      return Item.create(
        id: UniqueId.fromUniqueString(json['id']),
        title: Title(json['title']),
        author: Author(json['author']),
        publisher: Publisher(json['publisher']),
        tags: List<String>.from(json['tags'] ?? []),
        topic: Topic(json['topic']),
        language: Language(json['language']),
        cover: Cover(json['cover']),
        description: Description(json['description']),
        year: Year(int.tryParse(json['year'].toString()) ?? 0),
        format: Format(json['format'] ?? ''),
        reference: Reference(json['reference'] ?? ''),
        category: Category.create(
          id: UniqueId.fromUniqueString(
            json['category'] is Map
                ? json['category']['id'] ?? 'unknown-id'
                : (json['category'] is String
                      ? json['category']
                      : 'unknown-id'),
          ),
          name: Name(
            json['category'] is Map
                ? json['category']['name'] ?? 'Unknown'
                : (json['category'] is String ? json['category'] : 'Unknown'),
          ),
        ),
        completed: Completed(json['completed'] ?? false),
        ownerId: UniqueId.fromUniqueString(json['owner'] ?? 'default-owner'),
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
    );
  }
}
