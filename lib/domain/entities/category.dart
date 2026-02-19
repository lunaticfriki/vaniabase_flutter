import '../value_objects/string_value_objects.dart';
import '../value_objects/unique_id.dart';

class Category {
  final UniqueId id;
  final Name name;

  const Category._({required this.id, required this.name});

  static Category create({required Name name, UniqueId? id}) {
    return Category._(id: id ?? UniqueId(), name: name);
  }

  static Category empty() {
    return Category._(id: UniqueId(), name: const Name(''));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name.value == name.value;
  }

  @override
  int get hashCode => id.hashCode ^ name.value.hashCode;
}
