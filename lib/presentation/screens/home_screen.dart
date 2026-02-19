import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_read_service.dart';
import '../../application/services/items_state.dart';
import '../../config/injection.dart';
import '../widgets/item_preview_widget.dart';
import '../widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();
    sl<IItemsReadService>().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const MainDrawer(),
      body: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          return switch (state) {
            ItemsInitial() => const Center(
              child: Text('Press refresh or load items.'),
            ),
            ItemsLoading() => const Center(child: CircularProgressIndicator()),
            ItemsLoaded(items: final items) when items.isEmpty => const Center(
              child: Text('No items found.'),
            ),
            ItemsLoaded(items: final items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemPreviewWidget(item: items[index]);
              },
            ),
            ItemsError(message: final message) => Center(
              child: Text('Error: $message'),
            ),
            _ => const Center(child: Text('Unknown error')),
          };
        },
      ),
    );
  }
}
