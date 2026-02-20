import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/item_preview_widget.dart';
import '../widgets/main_drawer.dart';

class AllItemsScreen extends StatelessWidget {
  const AllItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _AllItemsView(),
    );
  }
}

class _AllItemsView extends StatefulWidget {
  const _AllItemsView();

  @override
  State<_AllItemsView> createState() => _AllItemsViewState();
}

class _AllItemsViewState extends State<_AllItemsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    sl<IItemsReadService>().fetchAllItems(refresh: true);
  }

  void _onScroll() {
    if (_isBottom) {
      sl<IItemsReadService>().fetchAllItems();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Items')),
      drawer: const MainDrawer(),
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
            _ => ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.items.length
                  : state.items.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return ItemPreviewWidget(item: state.items[index]);
              },
            ),
          };
        },
      ),
    );
  }
}
