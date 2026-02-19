import 'package:flutter/material.dart';
import '../../domain/entities/item.dart';

class ItemPreviewWidget extends StatelessWidget {
  final Item item;

  const ItemPreviewWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildCover(),
        title: Text(item.title.value),
        subtitle: Text(item.author.value),
      ),
    );
  }

  Widget _buildCover() {
    if (item.cover.value.isEmpty) {
      return const SizedBox(width: 50, height: 75, child: Placeholder());
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        item.cover.value,
        width: 50,
        height: 75,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 50,
            height: 75,
            child: Icon(Icons.error),
          );
        },
      ),
    );
  }
}
