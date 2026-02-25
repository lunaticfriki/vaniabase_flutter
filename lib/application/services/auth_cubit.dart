import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthInitial());
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final user = await _authRepository.getSignedInUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithGoogle();
      final user = await _authRepository.getSignedInUser();
      emit(Authenticated(user!));
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    await _authRepository.signOut();
    emit(Unauthenticated());
  }
}
