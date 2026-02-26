import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';

import '../../config/injection.dart';
import '../widgets/dynamic_list_layout.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';

class PublishersScreen extends StatelessWidget {
  final String? initialPublisher;
  const PublishersScreen({super.key, this.initialPublisher});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: _PublishersView(initialPublisher: initialPublisher),
    );
  }
}

class _PublishersView extends StatefulWidget {
  final String? initialPublisher;
  const _PublishersView({this.initialPublisher});

  @override
  State<_PublishersView> createState() => _PublishersViewState();
}

class _PublishersViewState extends State<_PublishersView> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedPublisher;

  @override
  void initState() {
    super.initState();
    _selectedPublisher = widget.initialPublisher?.toLowerCase();
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
            final lowerPublisher = item.publisher.value.toLowerCase();
            if (lowerPublisher.isNotEmpty) {
              mapCounts[lowerPublisher] = (mapCounts[lowerPublisher] ?? 0) + 1;
            }
          }

          final availablePublishers = mapCounts.keys.toList()..sort();

          final filteredItems = _selectedPublisher == null
              ? state.items
                    .where((item) => item.publisher.value.isNotEmpty)
                    .toList()
              : state.items
                    .where(
                      (item) =>
                          item.publisher.value.toLowerCase() ==
                          _selectedPublisher,
                    )
                    .toList();

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            child: DynamicListLayout(
              title: 'PUBLISHERS',
              availableOptions: availablePublishers,
              optionCounts: mapCounts,
              selectedOption: _selectedPublisher,
              onOptionSelected: (option) {
                setState(() => _selectedPublisher = option);
              },
              filteredItems: filteredItems,
            ),
          );
        },
      ),
    );
  }
}
