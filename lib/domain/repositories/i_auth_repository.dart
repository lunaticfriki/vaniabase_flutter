import '../entities/user.dart';

abstract class IAuthRepository {
  Future<User?> getSignedInUser();
  Future<void> signInWithGoogle();
  Future<void> signOut();
}
