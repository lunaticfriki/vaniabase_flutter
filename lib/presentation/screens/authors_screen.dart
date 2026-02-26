import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';

import '../../config/injection.dart';
import '../widgets/dynamic_list_layout.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';

class AuthorsScreen extends StatelessWidget {
  final String? initialAuthor;
  const AuthorsScreen({super.key, this.initialAuthor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: _AuthorsView(initialAuthor: initialAuthor),
    );
  }
}

class _AuthorsView extends StatefulWidget {
  final String? initialAuthor;
  const _AuthorsView({this.initialAuthor});

  @override
  State<_AuthorsView> createState() => _AuthorsViewState();
}

class _AuthorsViewState extends State<_AuthorsView> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedAuthor;

  @override
  void initState() {
    super.initState();
    _selectedAuthor = widget.initialAuthor?.toLowerCase();
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
            final lowerAuthor = item.author.value.toLowerCase();
            mapCounts[lowerAuthor] = (mapCounts[lowerAuthor] ?? 0) + 1;
          }

          final availableAuthors = mapCounts.keys.toList()..sort();

          final filteredItems = _selectedAuthor == null
              ? state.items
              : state.items
                    .where(
                      (item) =>
                          item.author.value.toLowerCase() == _selectedAuthor,
                    )
                    .toList();

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            child: DynamicListLayout(
              title: 'AUTHORS',
              availableOptions: availableAuthors,
              optionCounts: mapCounts,
              selectedOption: _selectedAuthor,
              onOptionSelected: (option) {
                setState(() => _selectedAuthor = option);
              },
              filteredItems: filteredItems,
            ),
          );
        },
      ),
    );
  }
}
