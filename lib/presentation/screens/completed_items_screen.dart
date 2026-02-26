import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../config/injection.dart';
import '../widgets/item_preview_widget.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';

class CompletedItemsScreen extends StatelessWidget {
  const CompletedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _CompletedItemsView(),
    );
  }
}

class _CompletedItemsView extends StatefulWidget {
  const _CompletedItemsView();

  @override
  State<_CompletedItemsView> createState() => _CompletedItemsViewState();
}

class _CompletedItemsViewState extends State<_CompletedItemsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    sl<ItemsCubit>().retain();
  }

  @override
  void dispose() {
    sl<ItemsCubit>().release();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed Items')),
      drawer: const MainDrawer(),
      floatingActionButton: CyberpunkFab(scrollController: _scrollController),
      body: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          return switch (state.status) {
            ItemsStatus.initial || ItemsStatus.loading
                when state.items.isEmpty =>
              const Center(child: CircularProgressIndicator()),
            ItemsStatus.failure when state.items.isEmpty => Center(
              child: Text('Error: ${state.errorMessage}'),
            ),
            ItemsStatus.success when state.items.isEmpty => const Center(
              child: Text('No items found.'),
            ),
            _ => LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 800
                    ? 5
                    : constraints.maxWidth > 600
                    ? 4
                    : 2;

                final completedItems = state.items
                    .where((item) => item.completed.value)
                    .toList();

                if (state.status == ItemsStatus.success &&
                    completedItems.isEmpty) {
                  return const Center(child: Text('No completed items found.'));
                }

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.46,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.hasReachedMax
                      ? completedItems.length
                      : completedItems.length +
                            1, // Will likely need to refine pagination down the line. Currently matching all items logic.
                  itemBuilder: (context, index) {
                    if (index >= completedItems.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return ItemPreviewWidget(item: completedItems[index]);
                  },
                );
              },
            ),
          };
        },
      ),
    );
  }
}
