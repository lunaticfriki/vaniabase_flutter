import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/repositories/i_storage_repository.dart';

class FirebaseStorageRepositoryImpl implements IStorageRepository {
  final FirebaseStorage _firebaseStorage;

  FirebaseStorageRepositoryImpl(this._firebaseStorage);

  @override
  Future<String> uploadItemCover({
    required String userId,
    required String tempId,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final path = 'users/$userId/items/$tempId/$fileName';
    final ref = _firebaseStorage.ref().child(path);

    final uploadTask = await ref.putData(
      fileBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<void> deleteItemCover(String coverUrl) async {
    if (coverUrl.isEmpty || !coverUrl.startsWith('http')) return;

    try {
      final ref = _firebaseStorage.refFromURL(coverUrl);
      await ref.delete();
    } catch (e) {}
  }
}
