import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/auth/repository/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepository;

  AuthController(this.authRepository) : super(const AsyncData(null));

  Stream<User?> get authStateChanges => authRepository.authStateChanges;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await authRepository.signIn(email, password);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> userExists(String email) async {
    return await authRepository.userExists(email);
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      await authRepository.signUp(email, password);
      await signIn(email, password);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}
