import 'package:flutter_test/flutter_test.dart';
import 'package:vaniabase/domain/value_objects/string_value_objects.dart';
import 'package:vaniabase/domain/value_objects/unique_id.dart';
import 'object_mothers/category_mother.dart';
import 'object_mothers/item_mother.dart';

void main() {
  group('Domain Tests', () {
    group('Category tests', () {
      test('CategoryMother.test creates a category with test data', () {
        final category = CategoryMother.test();

        expect(category.name.value, 'Test Category');
        expect(category.id, isA<UniqueId>());
      });
      test('CategoryMother.withData creates Category with custom data', () {
        final category = CategoryMother.withData(
          name: const Name('Custom Category'),
        );

        expect(category.name.value, 'Custom Category');
        expect(category.id, isA<UniqueId>());
      });

      test('CategoryMother.withName creates a category with custom name', () {
        final category = CategoryMother.withName('Custom Category');

        expect(category.name.value, 'Custom Category');
        expect(category.id, isA<UniqueId>());
      });
    });

    group('Item tests', () {
      test('ItemMother.test creates an item with test data', () {
        final item = ItemMother.test();

        expect(item.title.value, 'Test Item Title');
        expect(item.author.value, 'Test Author');
        expect(item.category, isNotNull);
      });

      test('ItemMother.withData creates Item with custom data', () {
        final item = ItemMother.withData(
          title: const Title('Custom Title'),
          author: const Author('Custom Author'),
        );

        expect(item.title.value, 'Custom Title');
        expect(item.author.value, 'Custom Author');
        expect(item.category, isNotNull);
      });

      test('Item.withCategory creates an Item with custom category', () {
        final category = CategoryMother.withData(
          name: const Name('Custom Category'),
        );

        final item = ItemMother.withCategory(category);

        expect(item.category, category);
      });
    });
  });
}
