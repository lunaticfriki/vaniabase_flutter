import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';

import '../../config/injection.dart';
import '../widgets/dynamic_list_layout.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';

class CategoriesScreen extends StatelessWidget {
  final String? initialCategory;
  const CategoriesScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: _CategoriesView(initialCategory: initialCategory),
    );
  }
}

class _CategoriesView extends StatefulWidget {
  final String? initialCategory;
  const _CategoriesView({this.initialCategory});

  @override
  State<_CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<_CategoriesView> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory?.toLowerCase();
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
          if (state.status == ItemsStatus.initial ||
              state.status == ItemsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ItemsStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          if (state.items.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          final mapCounts = <String, int>{};
          for (final item in state.items) {
            final lowerCategory = item.category.name.value.toLowerCase();
            mapCounts[lowerCategory] = (mapCounts[lowerCategory] ?? 0) + 1;
          }

          final availableCategories = mapCounts.keys.toList()..sort();

          final filteredItems = _selectedCategory == null
              ? state.items
              : state.items
                    .where(
                      (item) =>
                          item.category.name.value.toLowerCase() ==
                          _selectedCategory,
                    )
                    .toList();

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            child: DynamicListLayout(
              title: 'CATEGORIES',
              availableOptions: availableCategories,
              optionCounts: mapCounts,
              selectedOption: _selectedCategory,
              onOptionSelected: (option) {
                setState(() => _selectedCategory = option);
              },
              filteredItems: filteredItems,
            ),
          );
        },
      ),
    );
  }
}
