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
}
