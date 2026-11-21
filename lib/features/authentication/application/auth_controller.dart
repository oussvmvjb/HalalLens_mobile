import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../domain/auth_user.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthUser?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthUser?> {
  late AuthRepository _repository;

  @override
  Future<AuthUser?> build() {
    _repository = ref.watch(authRepositoryProvider);
    return _repository.restoreSession();
  }

  Future<void> signIn({required String email, required String password}) async {
    await _run(() => _repository.signIn(email: email, password: password));
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _run(
      () => _repository.signUp(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _repository.signOut();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _run(Future<AuthUser> Function() action) async {
    state = const AsyncLoading();
    try {
      state = AsyncData(await action());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
