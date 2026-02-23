import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/item.dart';
import '../widgets/cyberpunk_styling.dart';
import '../widgets/main_drawer.dart';

class ItemDetailScreen extends StatelessWidget {
  final String itemId;
  final Item? itemData;

  const ItemDetailScreen({super.key, required this.itemId, this.itemData});

  @override
  Widget build(BuildContext context) {
    if (itemData == null) {
      // Typically, we would fetch from Cubit here if accessed directly by URL
      return const Scaffold(
        body: Center(child: Text('Item not found or loading...')),
      );
    }
    return _ItemDetailView(item: itemData!);
  }
}

class _ItemDetailView extends StatelessWidget {
  final Item item;

  const _ItemDetailView({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Actions: Back, Edit, Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white60),
                  label: const Text(
                    'BACK',
                    style: TextStyle(color: Colors.white60),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context.push('/edit/${item.id.value}', extra: item);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: theme.colorScheme.secondary,
                        size: 16,
                      ),
                      label: Text(
                        'EDIT',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        print('Delete tapped for ${item.id.value}');
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      label: const Text(
                        'DELETE',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Two-column layout (stacks on mobile implicitly below if we used Wrap/etc., but we'll use a responsive builder or just column for simplicity, let's use LayoutBuilder)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildCoverColumn(context)),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 3,
                        child: _buildDetailsColumn(context, theme),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCoverColumn(context),
                    const SizedBox(height: 32),
                    _buildDetailsColumn(context, theme),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverColumn(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: CyberpunkStyling.getVolumeDecoration(
        context,
        bgColor: const Color(0xFF18181B), // zinc-900
      ),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: item.cover.value.isEmpty
            ? Container(
                color: Colors.black26,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white38,
                  size: 64,
                ),
              )
            : Image.network(
                item.cover.value,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black26,
                    child: const Icon(
                      Icons.error,
                      color: Colors.white38,
                      size: 64,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDetailsColumn(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(
              alpha: 0.2,
            ), // Magenta tint
            border: Border(
              left: BorderSide(color: theme.colorScheme.secondary, width: 2),
            ),
          ),
          child: Text(
            item.category.name.value.toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          item.title.value,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),

        // Author
        Text.rich(
          TextSpan(
            text: 'BY ',
            style: const TextStyle(color: Colors.white60, fontSize: 18),
            children: [
              TextSpan(
                text: item.author.value.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Description
        Text(
          item.description.value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        // Mark Completed Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Stub for WriteService toggle
              print('Toggled complete status for ${item.title.value}');
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: item.completed.value
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.green,
              foregroundColor: item.completed.value
                  ? Colors.white
                  : Colors.black,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            child: Text(
              item.completed.value ? 'MARK UNCOMPLETED' : 'MARK COMPLETED',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Details Grid
        Container(
          padding: const EdgeInsets.only(top: 24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3, // Gives adequate width vs height
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDetailItem('YEAR', item.year.value.toString()),
              _buildDetailItem(
                'PUBLISHER',
                item.publisher.value.isEmpty ? '-' : item.publisher.value,
              ),
              _buildDetailItem(
                'REFERENCE',
                item.reference.value.isEmpty ? '-' : item.reference.value,
              ),
              _buildDetailItem(
                'LANGUAGE',
                item.language.value.isEmpty ? '-' : item.language.value,
              ),
              _buildDetailItem(
                'FORMAT',
                item.format.value.isEmpty ? '-' : item.format.value,
              ),
              _buildDetailItem(
                'TOPIC',
                item.topic.value.isEmpty ? '-' : item.topic.value,
              ),
              _buildDetailItem(
                'COMPLETED',
                item.completed.value ? 'Yes' : 'No',
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Tags
        if (item.tags.isNotEmpty) ...[
          const Text(
            'TAGS',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${tag.toLowerCase()}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              );
            }).toList(),
          ),
        ] else ...[
          const Text(
            'TAGS',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'No tags',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
