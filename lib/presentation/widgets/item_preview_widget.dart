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
      decoration: CyberpunkStyling.getVolumeDecoration(
        context,
        bgColor: const Color(0xFF18181B),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cover Image Area
          AspectRatio(aspectRatio: 2 / 3, child: _buildCover()),

          // Details Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    item.category.name.value.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary, // Magenta
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Expanded(
                    child: Text(
                      item.title.value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Divider & Author
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.0,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'By ${item.author.value}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    if (item.cover.value.isEmpty) {
      return Container(
        color: Colors.black26,
        child: const Icon(Icons.image_not_supported, color: Colors.white38),
      );
    }

    return Image.network(
      item.cover.value,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.black26,
          child: const Icon(Icons.error, color: Colors.white38),
        );
      },
    );
  }
}
