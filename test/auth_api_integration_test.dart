import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halal_lens/core/constants/storage_keys.dart';
import 'package:halal_lens/core/network/api_client.dart';
import 'package:halal_lens/features/authentication/data/auth_repository.dart';

class MemoryTokenStorage implements TokenStorage {
  final Map<String, String> _values = {};

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }
}

const apiBaseUrl = String.fromEnvironment('AUTH_API_BASE_URL');
const testEmail = String.fromEnvironment('AUTH_TEST_EMAIL');

void main() {
  test(
    'registers, logs in, restores the profile, and logs out through the API',
    () async {
      final storage = MemoryTokenStorage();
      final container = ProviderContainer(
        overrides: [tokenStorageProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);
      final dio = container.read(apiClientProvider)
        ..options.baseUrl = apiBaseUrl;
      final repository = ApiAuthRepository(dio: dio, storage: storage);

      final user = await repository.signUp(
        fullName: 'HalalLens Mobile Test',
        email: testEmail,
        password: 'halallens-integration-password',
      );
      expect(user.email, testEmail);
      expect(user.fullName, 'HalalLens Mobile Test');
      expect(await storage.read(key: StorageKeys.accessToken), isNotEmpty);
      expect(await storage.read(key: StorageKeys.refreshToken), isNotEmpty);

      await storage.write(
        key: StorageKeys.accessToken,
        value: 'expired-access-token',
      );
      final restoredUser = await repository.restoreSession();
      expect(restoredUser?.id, user.id);
      expect(restoredUser?.email, testEmail);

      await repository.signOut();
      expect(await storage.read(key: StorageKeys.accessToken), isNull);
      expect(await storage.read(key: StorageKeys.refreshToken), isNull);
      expect(await repository.restoreSession(), isNull);

      dio.close();
    },
    skip:
        apiBaseUrl.isEmpty || testEmail.isEmpty
            ? 'Set AUTH_API_BASE_URL and AUTH_TEST_EMAIL to run the live API integration test.'
            : false,
  );
}
