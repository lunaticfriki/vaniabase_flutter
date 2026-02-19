import 'dart:convert';
import 'package:flutter/services.dart';

abstract class IItemsDataSource {
  Future<List<dynamic>> fetchItems();
}

class SeedItemsDataSource implements IItemsDataSource {
  @override
  Future<List<dynamic>> fetchItems() async {
    try {
      final String response = await rootBundle.loadString('assets/seed.json');
      final data = await json.decode(response);
      return data as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load seed data: $e');
    }
  }
}
