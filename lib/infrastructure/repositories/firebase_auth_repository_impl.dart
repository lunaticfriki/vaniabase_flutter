import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/value_objects/auth_value_objects.dart';
import '../../domain/value_objects/unique_id.dart';

class FirebaseAuthRepositoryImpl implements IAuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  late final GoogleSignIn _googleSignIn;
  FirebaseAuthRepositoryImpl(this._firebaseAuth, this._firestore) {
    _googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? dotenv.env['GOOGLE_SIGN_IN_WEB_CLIENT_ID'] : null,
    );
  }
  @override
  Future<User?> getSignedInUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return await _firebaseUserToDomain(firebaseUser);
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        try {
          final userDoc = await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .get();
          if (!userDoc.exists) {
            final now = DateTime.now();
            await _firestore.collection('users').doc(firebaseUser.uid).set({
              'id': firebaseUser.uid,
              'email': firebaseUser.email ?? 'unknown@example.com',
              'name': firebaseUser.displayName ?? 'Unknown',
              'avatar': firebaseUser.photoURL ?? '',
              'created_at': now.toIso8601String(),
            });
          } else {}
        } catch (dbError) {
          throw Exception('Database sync failed: $dbError');
        }
      }
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Unknown authentication error');
    } catch (e) {
      throw Exception(
        'Google Sign In failed: $e. If on Web, check your Google Cloud Console "Authorized JavaScript origins" port.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<User> _firebaseUserToDomain(firebase.User user) async {
    String name = 'Unknown';
    String avatar = '';
    DateTime createdAt = DateTime.now();
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        name = data['name'] ?? name;
        avatar = data['avatar'] ?? avatar;
        final createdAtRaw = data['created_at'];
        if (createdAtRaw != null) {
          if (createdAtRaw is Timestamp) {
            createdAt = createdAtRaw.toDate();
          } else if (createdAtRaw is String) {
            createdAt = DateTime.tryParse(createdAtRaw) ?? createdAt;
          }
        }
      }
    } catch (e) {
      debugPrint('Error parsing user data from Firestore: \$e');
    }
    return User.create(
      id: UniqueId.fromUniqueString(user.uid),
      emailAddress: EmailAddress(user.email ?? ''),
      name: name,
      avatar: avatar,
      createdAt: createdAt,
    );
  }
}
