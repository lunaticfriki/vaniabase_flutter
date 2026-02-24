import 'package:flutter/material.dart' hide Title;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../config/injection.dart';
import '../../domain/repositories/i_storage_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/item.dart';
import '../../domain/entities/category.dart';
import '../../domain/value_objects/string_value_objects.dart';
import '../../domain/value_objects/unique_id.dart';
import '../../domain/value_objects/year.dart';
import '../../domain/value_objects/completed.dart';
import '../../application/services/items_write_cubit.dart';
import '../../application/services/items_write_state.dart';
import '../../application/services/items_write_service.dart';
import '../widgets/item_form_widget.dart';

class NewItemScreen extends StatelessWidget {
  const NewItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsWriteCubit>(),
      child: const _NewItemView(),
    );
  }
}

class _NewItemView extends StatelessWidget {
  const _NewItemView();

  void _handleSubmit(BuildContext context, Map<String, dynamic> formData) {
    final newItemId = const Uuid().v4();

    final item = Item.create(
      id: UniqueId.fromUniqueString(newItemId),
      title: Title(formData['title']?.toString() ?? ''),
      author: Author(formData['author']?.toString() ?? ''),
      publisher: Publisher(formData['publisher']?.toString() ?? ''),
      tags: formData['tags'] as List<String>? ?? [],
      topic: Topic(formData['topic']?.toString() ?? ''),
      language: Language(formData['language']?.toString() ?? ''),
      cover: Cover(formData['cover']?.toString() ?? ''),
      description: Description(formData['description']?.toString() ?? ''),
      year: Year(int.tryParse(formData['year']?.toString() ?? '') ?? 0),
      format: Format(formData['format']?.toString() ?? ''),
      reference: Reference(formData['reference']?.toString() ?? ''),
      category: Category.create(
        id: UniqueId.fromUniqueString(
          formData['category']?.toString() ?? 'unknown-id',
        ),
        name: Name(formData['category']?.toString() ?? 'Unknown'),
      ),
      completed: Completed(formData['completed'] ?? false),
      ownerId: UniqueId.fromUniqueString(''),
    );

    sl<IItemsWriteService>().createItem(item);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemsWriteCubit, ItemsWriteState>(
      listener: (context, state) {
        if (state is ItemsWriteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item created successfully!')),
          );
          context.go('/');
        } else if (state is ItemsWriteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create item: \n\n${state.errorMessage}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Item')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFF00FF), Color(0xFFFFFF00)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'ADD NEW ITEM',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add a new item to your collection manually.',
                  style: TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 32),

                BlocBuilder<ItemsWriteCubit, ItemsWriteState>(
                  builder: (context, state) {
                    if (state is ItemsWriteLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final initialMap = <String, dynamic>{
                      'title': '',
                      'description': '',
                      'author': '',
                      'cover': '',
                      'tags': <String>[],
                      'topic': '',
                      'format': '',
                      'completed': false,
                      'year': '',
                      'publisher': '',
                      'language': '',
                      'category': 'books',
                      'reference': '',
                    };

                    return ItemFormWidget(
                      initialValues: initialMap,
                      submitLabel: 'CREATE ITEM',
                      onSubmit: (data) => _handleSubmit(context, data),
                      onUploadCover: (file) async {
                        final auth = sl<firebase_auth.FirebaseAuth>();
                        final storageRepo = sl<IStorageRepository>();

                        final userId = auth.currentUser?.uid ?? 'unknown_user';
                        final tempId = const Uuid().v4();
                        final fileBytes = await file.readAsBytes();

                        return storageRepo.uploadItemCover(
                          userId: userId,
                          tempId: tempId,
                          fileName: file.name,
                          fileBytes: fileBytes,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
