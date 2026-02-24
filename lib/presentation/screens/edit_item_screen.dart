import 'package:flutter/material.dart' hide Title;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../config/injection.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/category.dart';
import '../../domain/value_objects/string_value_objects.dart';
import '../../domain/value_objects/unique_id.dart';
import '../../domain/value_objects/year.dart';
import '../../domain/value_objects/completed.dart';
import '../../application/services/items_write_cubit.dart';
import '../../application/services/items_write_state.dart';
import '../../application/services/items_write_service.dart';
import '../../domain/repositories/i_storage_repository.dart';
import '../widgets/item_form_widget.dart';

class EditItemScreen extends StatelessWidget {
  final String itemId;
  final Item? itemData;

  const EditItemScreen({super.key, required this.itemId, this.itemData});

  @override
  Widget build(BuildContext context) {
    if (itemData == null) {
      return const Scaffold(
        body: Center(child: Text('Item not found or loading...')),
      );
    }
    return BlocProvider.value(
      value: sl<ItemsWriteCubit>(),
      child: _EditItemView(item: itemData!),
    );
  }
}

class _EditItemView extends StatelessWidget {
  final Item item;

  const _EditItemView({required this.item});

  void _handleUpdate(BuildContext context, Map<String, dynamic> formData) {
    final updatedItem = Item.create(
      id: item.id, // KEEP EXISTING ID
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
      ownerId: item.ownerId, // KEEP EXISTING OWNER ID
    );

    sl<IItemsWriteService>().updateItem(updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemsWriteCubit, ItemsWriteState>(
      listener: (context, state) {
        if (state is ItemsWriteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully!')),
          );
          // Return to home page after success
          context.go('/');
        } else if (state is ItemsWriteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update item: \n\n${state.errorMessage}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Item')),
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
                    'EDIT ITEM',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Modify the details of your item.',
                  style: TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 32),

                BlocBuilder<ItemsWriteCubit, ItemsWriteState>(
                  builder: (context, state) {
                    if (state is ItemsWriteLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final initialMap = <String, dynamic>{
                      'title': item.title.value,
                      'description': item.description.value,
                      'author': item.author.value,
                      'cover': item.cover.value,
                      'tags': item.tags.toList(),
                      'topic': item.topic.value,
                      'format': item.format.value,
                      'completed': item.completed.value,
                      'year': item.year.value.toString(),
                      'publisher': item.publisher.value,
                      'language': item.language.value,
                      'category': item.category.name.value
                          .toLowerCase(), // Maps to the dropdown values (books, video, etc)
                      'reference': item.reference.value,
                    };

                    return ItemFormWidget(
                      initialValues: initialMap,
                      submitLabel: 'UPDATE ITEM',
                      onSubmit: (data) => _handleUpdate(context, data),
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
