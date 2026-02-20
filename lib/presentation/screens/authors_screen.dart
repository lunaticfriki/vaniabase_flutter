import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/main_drawer.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _AuthorsView(),
    );
  }
}

class _AuthorsView extends StatefulWidget {
  const _AuthorsView();

  @override
  State<_AuthorsView> createState() => _AuthorsViewState();
}

class _AuthorsViewState extends State<_AuthorsView> {
  @override
  void initState() {
    super.initState();
    sl<IItemsReadService>().fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authors')),
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
              state.authors.isEmpty
                  ? const Center(child: Text('No authors found.'))
                  : ListView.builder(
                      itemCount: state.authors.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(state.authors[index].value),
                        );
                      },
                    ),
          };
        },
      ),
    );
  }
}
