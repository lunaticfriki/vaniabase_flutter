import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../config/injection.dart';
import '../widgets/item_preview_widget.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';
import '../widgets/cyberpunk_styling.dart';

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

                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: CyberpunkStyling.getVolumeDecoration(
                              context,
                              bgColor: Colors.black.withValues(alpha: 0.5),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (GoRouter.of(context).canPop()) {
                                  GoRouter.of(context).pop();
                                } else {
                                  GoRouter.of(context).go('/');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        Color(0xFFFF00FF),
                                        Color(0xFFFFFF00),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(bounds),
                                child: Text(
                                  'COMPLETED',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.1,
                                        letterSpacing: -2.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.46,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.hasReachedMax
                            ? completedItems.length
                            : completedItems.length + 1,
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
                      ),
                    ],
                  ),
                );
              },
            ),
          };
        },
      ),
    );
  }
}
