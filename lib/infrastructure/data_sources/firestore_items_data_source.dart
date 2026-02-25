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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<dynamic>> watchItems() {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('items')
        .where('owner', isEqualTo: currentUser.uid)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  @override
  Future<void> createItem(Map<String, dynamic> itemMap) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    try {
      itemMap['owner'] = currentUser.uid;
      final id = itemMap['id'];
      if (id != null && id.toString().isNotEmpty) {
        await _firestore.collection('items').doc(id.toString()).set(itemMap);
      } else {
        await _firestore.collection('items').add(itemMap);
      }
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      rethrow;
    }
  }
}
