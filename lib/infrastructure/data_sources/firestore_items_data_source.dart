import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'seed_items_data_source.dart';

class FirestoreItemsDataSource implements IItemsDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreItemsDataSource(this._firestore, this._firebaseAuth);

  @override
  Future<List<dynamic>> fetchItems() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return [];
    }

    try {
      final querySnapshot = await _firestore
          .collection('items')
          .where('owner', isEqualTo: currentUser.uid)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e, stackTrace) {
      print('🔥 FIRESTORE FETCH ERROR 🔥');
      print('Error mapping items for user ${currentUser.uid}: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> createItem(Map<String, dynamic> itemMap) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      itemMap['owner'] = currentUser.uid;
      // Do not generate the ID localy, let Firestore do it, but if it has one, keep it as document name?
      // Since item creation in TS seems to use randomUUID, let's just let firestore generate it via .add()
      // Wait, let me check what the UI will pass in.
      final id = itemMap['id'];
      if (id != null && id.toString().isNotEmpty) {
        await _firestore.collection('items').doc(id.toString()).set(itemMap);
      } else {
        await _firestore.collection('items').add(itemMap);
      }
    } catch (e, stackTrace) {
      print('🔥 FIRESTORE CREATE ERROR 🔥');
      print('Error creating item for user ${currentUser.uid}: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> updateItem(Map<String, dynamic> itemMap) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final id = itemMap['id'];
      if (id == null || id.toString().isEmpty) {
        throw Exception('Item ID is required for updating');
      }

      itemMap['owner'] = currentUser.uid;
      await _firestore.collection('items').doc(id.toString()).update(itemMap);
    } catch (e, stackTrace) {
      print('🔥 FIRESTORE UPDATE ERROR 🔥');
      print('Error updating item for user ${currentUser.uid}: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      if (id.isEmpty) {
        throw Exception('Item ID is required for deleting');
      }

      await _firestore.collection('items').doc(id).delete();
    } catch (e, stackTrace) {
      print('🔥 FIRESTORE DELETE ERROR 🔥');
      print('Error deleting item for user ${currentUser.uid}: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }
}
