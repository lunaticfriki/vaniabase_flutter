import 'package:vaniabase/domain/entities/item.dart';
import 'package:vaniabase/domain/entities/category.dart';
import 'package:vaniabase/domain/value_objects/string_value_objects.dart';
import 'package:vaniabase/domain/value_objects/unique_id.dart';
import 'package:vaniabase/domain/value_objects/year.dart';
import 'category_mother.dart';

class ItemMother {
  static Item test() {
    return Item.create(
      id: UniqueId.fromUniqueString('item-id'),
      title: const Title('Test Item Title'),
      author: const Author('Test Author'),
      publisher: const Publisher('Test Publisher'),
      tags: ['tag1', 'tag2'],
      topic: const Topic('Test Topic'),
      language: const Language('English'),
      cover: const Cover('http://example.com/cover.jpg'),
      description: const Description('Test Description'),
      year: const Year(2023),
      format: const Format('Hardcover'),
      reference: const Reference('REF-123'),
      category: CategoryMother.test(),
    );
  }

  static Item withCategory(Category category) {
    return Item.create(
      title: const Title('Test Item Title'),
      author: const Author('Test Author'),
      publisher: const Publisher('Test Publisher'),
      tags: ['tag1', 'tag2'],
      topic: const Topic('Test Topic'),
      language: const Language('English'),
      cover: const Cover('http://example.com/cover.jpg'),
      description: const Description('Test Description'),
      year: const Year(2023),
      format: const Format('Hardcover'),
      reference: const Reference('REF-123'),
      category: category,
    );
  }

  static Item withData({
    UniqueId? id,
    Title? title,
    Author? author,
    Publisher? publisher,
    List<String>? tags,
    Topic? topic,
    Language? language,
    Cover? cover,
    Description? description,
    Year? year,
    Format? format,
    Reference? reference,
    Category? category,
  }) {
    return Item.create(
      id: id ?? UniqueId.fromUniqueString('item-id'),
      title: title ?? const Title('Test Item Title'),
      author: author ?? const Author('Test Author'),
      publisher: publisher ?? const Publisher('Test Publisher'),
      tags: tags ?? ['tag1', 'tag2'],
      topic: topic ?? const Topic('Test Topic'),
      language: language ?? const Language('English'),
      cover: cover ?? const Cover('http://example.com/cover.jpg'),
      description: description ?? const Description('Test Description'),
      year: year ?? const Year(2023),
      format: format ?? const Format('Hardcover'),
      reference: reference ?? const Reference('REF-123'),
      category: category ?? CategoryMother.test(),
    );
  }
}
