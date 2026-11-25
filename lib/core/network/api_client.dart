import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../constants/storage_keys.dart';
import '../errors/api_exception.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

abstract interface class TokenStorage {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String value});

  Future<void> delete({required String key});
}

class SecureTokenStorage implements TokenStorage {
  const SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => SecureTokenStorage(ref.watch(secureStorageProvider)),
);

final apiClientProvider = Provider<Dio>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      headers: const {'Accept': 'application/json'},
    ),
  );
  ref.onDispose(() => dio.close());
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.read(key: StorageKeys.accessToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        final apiException = ApiException.fromDio(error);
        _logApiFailure(error, apiException.failureKind);
        handler.next(error.copyWith(error: apiException));
      },
    ),
  );
  return dio;
});

void _logApiFailure(DioException error, ApiFailureKind failureKind) {
  final parsedPath = Uri.tryParse(error.requestOptions.path)?.path;
  final path = parsedPath == null || parsedPath.isEmpty ? '/' : parsedPath;
  final statusCode = error.response?.statusCode;
  final status = statusCode == null ? '' : ' (HTTP $statusCode)';
  developer.log(
    'API ${failureKind.name} failure: '
    '${error.requestOptions.method.toUpperCase()} $path$status',
    name: 'halallens.api',
    level: 900,
  );
}
