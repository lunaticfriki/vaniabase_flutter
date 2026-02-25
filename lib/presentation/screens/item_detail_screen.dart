import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item.dart';
import '../../domain/value_objects/completed.dart';
import '../../config/injection.dart';
import '../../application/services/items_write_service.dart';
import '../../application/services/items_write_cubit.dart';
import '../../application/services/items_write_state.dart';
import '../../application/services/items_cubit.dart';
import '../widgets/cyberpunk_styling.dart';
import '../widgets/cyberpunk_fab.dart';
import '../widgets/main_drawer.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsWriteCubit>(),
      child: _ItemDetailView(item: item),
    );
  }
}

class _ItemDetailView extends StatefulWidget {
  final Item item;

  const _ItemDetailView({required this.item});

  @override
  State<_ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<_ItemDetailView> {
  late ScrollController _scrollController;
  late Item currentItem;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    currentItem = widget.item;
    sl<ItemsCubit>().retain();
  }

  @override
  void dispose() {
    sl<ItemsCubit>().release();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleCompleted() {
    final updatedItem = currentItem.copyWith(
      completed: Completed(!currentItem.completed.value),
    );

    sl<IItemsWriteService>().updateItem(updatedItem);

    setState(() {
      currentItem = updatedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemsWriteCubit, ItemsWriteState>(
      listener: (context, state) {
        if (state is ItemsWriteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully')),
          );
        } else if (state is ItemsWriteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentItem.title.value),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                GoRouter.of(context).push(
                  '/item/${currentItem.id.value}/edit',
                  extra: currentItem,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, currentItem),
            ),
          ],
        ),
        drawer: const MainDrawer(),
        floatingActionButton: CyberpunkFab(scrollController: _scrollController),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          child: _buildDetailsColumn(
                            context,
                            Theme.of(context),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCoverColumn(context),
                      const SizedBox(height: 32),
                      _buildDetailsColumn(context, Theme.of(context)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverColumn(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: CyberpunkStyling.getVolumeDecoration(
        context,
        bgColor: const Color(0xFF18181B),
      ),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: currentItem.cover.value.isEmpty
            ? Container(
                color: Colors.black26,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white38,
                  size: 64,
                ),
              )
            : Image.network(
                currentItem.cover.value,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.2),
            border: Border(
              left: BorderSide(color: theme.colorScheme.secondary, width: 2),
            ),
          ),
          child: InkWell(
            onTap: () {
              GoRouter.of(
                context,
              ).push('/categories', extra: currentItem.category.name.value);
            },
            child: Text(
              currentItem.category.name.value.toUpperCase(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF00FF), Color(0xFFFFFF00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            currentItem.title.value,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text.rich(
          TextSpan(
            text: 'BY ',
            style: const TextStyle(color: Colors.white60, fontSize: 18),
            children: [
              TextSpan(
                text: currentItem.author.value.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Text(
          currentItem.description.value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _toggleCompleted,
            style: OutlinedButton.styleFrom(
              backgroundColor: currentItem.completed.value
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.green,
              foregroundColor: currentItem.completed.value
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
              currentItem.completed.value
                  ? 'MARK UNCOMPLETED'
                  : 'MARK COMPLETED',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

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
            childAspectRatio: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDetailItem('YEAR', currentItem.year.value.toString()),
              _buildDetailItem(
                'PUBLISHER',
                currentItem.publisher.value.isEmpty
                    ? '-'
                    : currentItem.publisher.value,
              ),
              _buildDetailItem(
                'REFERENCE',
                currentItem.reference.value.isEmpty
                    ? '-'
                    : currentItem.reference.value,
              ),
              _buildDetailItem(
                'LANGUAGE',
                currentItem.language.value.isEmpty
                    ? '-'
                    : currentItem.language.value,
              ),
              _buildDetailItem(
                'FORMAT',
                currentItem.format.value.isEmpty
                    ? '-'
                    : currentItem.format.value,
              ),
              _buildDetailItem(
                'TOPIC',
                currentItem.topic.value.isEmpty ? '-' : currentItem.topic.value,
              ),
              _buildDetailItem(
                'COMPLETED',
                currentItem.completed.value ? 'Yes' : 'No',
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        if (currentItem.tags.isNotEmpty) ...[
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
            children: currentItem.tags.map((tag) {
              return InkWell(
                onTap: () {
                  GoRouter.of(context).push('/tags', extra: tag);
                },
                child: Container(
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
          value.toUpperCase(),
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

  void _confirmDelete(BuildContext context, Item item) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF18181B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.5),
            ),
          ),
          title: Text(
            'DELETE ITEM',
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${item.title.value}"? This action cannot be undone and will remove the item cover image if it exists.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white60),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  await sl<IItemsWriteService>().deleteItem(item);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item deleted successfully'),
                      ),
                    );
                    context.go('/');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete item: $e'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
