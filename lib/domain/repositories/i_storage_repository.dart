import 'dart:typed_data';

abstract class IStorageRepository {
  Future<String> uploadItemCover({
    required String userId,
    required String tempId,
    required String fileName,
    required Uint8List fileBytes,
  });
  Future<void> deleteItemCover(String coverUrl);
}
