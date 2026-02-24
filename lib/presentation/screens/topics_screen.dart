import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/dynamic_list_layout.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';

class TopicsScreen extends StatelessWidget {
  final String? initialTopic;
  const TopicsScreen({super.key, this.initialTopic});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: _TopicsView(initialTopic: initialTopic),
    );
  }
}

class _TopicsView extends StatefulWidget {
  final String? initialTopic;
  const _TopicsView({this.initialTopic});

  @override
  State<_TopicsView> createState() => _TopicsViewState();
}

class _TopicsViewState extends State<_TopicsView> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedTopic;

  @override
  void initState() {
    super.initState();
    _selectedTopic = widget.initialTopic?.toLowerCase();
    sl<IItemsReadService>().fetchAllItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topics')),
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
            final lowerTopic = item.topic.value.toLowerCase();
            mapCounts[lowerTopic] = (mapCounts[lowerTopic] ?? 0) + 1;
          }

          final availableTopics = mapCounts.keys.toList()..sort();

          final filteredItems = _selectedTopic == null
              ? state.items
              : state.items
                    .where(
                      (item) =>
                          item.topic.value.toLowerCase() == _selectedTopic,
                    )
                    .toList();

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            child: DynamicListLayout(
              title: 'TOPICS',
              availableOptions: availableTopics,
              optionCounts: mapCounts,
              selectedOption: _selectedTopic,
              onOptionSelected: (option) {
                setState(() => _selectedTopic = option);
              },
              filteredItems: filteredItems,
            ),
          );
        },
      ),
    );
  }
}
