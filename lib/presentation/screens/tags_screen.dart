import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/main_drawer.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _TagsView(),
    );
  }
}

class _TagsView extends StatefulWidget {
  const _TagsView();

  @override
  State<_TagsView> createState() => _TagsViewState();
}

class _TagsViewState extends State<_TagsView> {
  @override
  void initState() {
    super.initState();
    sl<IItemsReadService>().fetchTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      drawer: const MainDrawer(),
      body: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          return switch (state.status) {
            ItemsStatus.initial || ItemsStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            ItemsStatus.failure => Center(
              child: Text('Error: ${state.errorMessage}'),
            ),
            ItemsStatus.success =>
              state.tags.isEmpty
                  ? const Center(child: Text('No tags found.'))
                  : ListView.builder(
                      itemCount: state.tags.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.tag),
                          title: Text(state.tags[index]),
                        );
                      },
                    ),
          };
        },
      ),
    );
  }
}
