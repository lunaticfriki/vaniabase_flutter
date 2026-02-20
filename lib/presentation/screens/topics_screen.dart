import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/main_drawer.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _TopicsView(),
    );
  }
}

class _TopicsView extends StatefulWidget {
  const _TopicsView();

  @override
  State<_TopicsView> createState() => _TopicsViewState();
}

class _TopicsViewState extends State<_TopicsView> {
  @override
  void initState() {
    super.initState();
    sl<IItemsReadService>().fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topics')),
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
              state.topics.isEmpty
                  ? const Center(child: Text('No topics found.'))
                  : ListView.builder(
                      itemCount: state.topics.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.topic),
                          title: Text(state.topics[index].value),
                        );
                      },
                    ),
          };
        },
      ),
    );
  }
}
