import 'package:vaniabase/domain/entities/category.dart';
import 'package:vaniabase/domain/value_objects/string_value_objects.dart';
import 'package:vaniabase/domain/value_objects/unique_id.dart';

class CategoryMother {
  static Category test() {
    return Category.create(
      id: UniqueId.fromUniqueString('category-id'),
      name: const Name('Test Category'),
    );
  }

  static Category withName(String name) {
    return Category.create(name: Name(name));
  }

  static Category withData({UniqueId? id, Name? name}) {
    return Category.create(
      id: id ?? UniqueId.fromUniqueString('category-id'),
      name: name ?? const Name('Test Category'),
    );
  }
}
