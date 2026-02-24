import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/dynamic_list_layout.dart';
import '../widgets/main_drawer.dart';

class TagsScreen extends StatelessWidget {
  final String? initialTag;
  const TagsScreen({super.key, this.initialTag});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: _TagsView(initialTag: initialTag),
    );
  }
}

class _TagsView extends StatefulWidget {
  final String? initialTag;
  const _TagsView({this.initialTag});

  @override
  State<_TagsView> createState() => _TagsViewState();
}

class _TagsViewState extends State<_TagsView> {
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    _selectedTag = widget.initialTag?.toLowerCase();
    sl<IItemsReadService>().fetchAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      drawer: const MainDrawer(),
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
            for (final tag in item.tags) {
              final lowerTag = tag.toLowerCase();
              mapCounts[lowerTag] = (mapCounts[lowerTag] ?? 0) + 1;
            }
          }

          final availableTags = mapCounts.keys.toList()..sort();

          final filteredItems = _selectedTag == null
              ? state.items
              : state.items
                    .where(
                      (item) => item.tags
                          .map((t) => t.toLowerCase())
                          .contains(_selectedTag),
                    )
                    .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: DynamicListLayout(
              title: 'TAGS',
              availableOptions: availableTags,
              optionCounts: mapCounts,
              selectedOption: _selectedTag,
              onOptionSelected: (option) {
                setState(() => _selectedTag = option);
              },
              filteredItems: filteredItems,
            ),
          );
        },
      ),
    );
  }
}
