import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/item_preview_widget.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    sl<IItemsReadService>().searchItems('');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      drawer: const MainDrawer(),
      floatingActionButton: CyberpunkFab(scrollController: _scrollController),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: 'Search items, authors, tags...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                sl<IItemsReadService>().searchItems(query);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, state) {
                return switch (state.status) {
                  ItemsStatus.initial => const Center(
                    child: Text('Start typing to search.'),
                  ),
                  ItemsStatus.loading => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ItemsStatus.failure => Center(
                    child: Text('Error: ${state.errorMessage}'),
                  ),
                  ItemsStatus.success =>
                    state.searchResults.isEmpty
                        ? const Center(child: Text('No results found.'))
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = constraints.maxWidth > 800
                                  ? 5
                                  : constraints.maxWidth > 600
                                  ? 4
                                  : 2;

                              return GridView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 0.46,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                itemCount: state.searchResults.length,
                                itemBuilder: (context, index) {
                                  return ItemPreviewWidget(
                                    item: state.searchResults[index],
                                  );
                                },
                              );
                            },
                          ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
