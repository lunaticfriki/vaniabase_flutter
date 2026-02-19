import 'package:flutter/material.dart';
import '../../domain/entities/item.dart';
import 'cyberpunk_styling.dart';

class ItemPreviewWidget extends StatelessWidget {
  final Item item;

  const ItemPreviewWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const textColor = Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: CyberpunkStyling.getVolumeDecoration(
        context,
        bgColor: theme.colorScheme.primary,
      ),
      child: ListTile(
        textColor: textColor,
        leading: _buildCover(),
        title: Text(
          item.title.value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          item.author.value,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ),
    );
  }

  Widget _buildCover() {
    if (item.cover.value.isEmpty) {
      return const SizedBox(width: 50, height: 75, child: Placeholder());
    }

    return ClipRRect(
      borderRadius: CyberpunkStyling.imageClipRadius,
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
