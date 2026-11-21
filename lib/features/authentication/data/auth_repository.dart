import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<AuthUser?> restoreSession();

  Future<void> signOut();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    dio: ref.watch(apiClientProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository({
    required Dio dio,
    required FlutterSecureStorage storage,
  }) : _dio = dio,
       _storage = storage;

  final Dio _dio;
  final FlutterSecureStorage _storage;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
      );
      await _saveTokens(response.data!);
      return await _currentUser();
    } on DioException catch (error) {
      await _clearTokens();
      throw _asApiException(error);
    }
  }

  @override
  Future<AuthUser> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post<void>(
        '/auth/register',
        data: {
          'full_name': fullName.trim(),
          'email': email.trim(),
          'password': password,
          'preferred_language': 'en',
        },
      );
    } on DioException catch (error) {
      throw _asApiException(error);
    }
    return signIn(email: email, password: password);
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final accessToken = await _storage.read(key: StorageKeys.accessToken);
    if (accessToken == null || accessToken.isEmpty) {
      return _refreshSession();
    }

    try {
      return await _currentUser();
    } on DioException catch (error) {
      if (error.response?.statusCode != 401) {
        throw _asApiException(error);
      }
      return _refreshSession();
    }
  }

  @override
  Future<void> signOut() => _clearTokens();

  Future<AuthUser?> _refreshSession() async {
    final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      await _clearTokens();
      return null;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      await _saveTokens(response.data!);
      return await _currentUser();
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _clearTokens();
        return null;
      }
      throw _asApiException(error);
    }
  }

  Future<AuthUser> _currentUser() async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/me');
    return AuthUser.fromJson(response.data!);
  }

  Future<void> _saveTokens(Map<String, dynamic> tokens) async {
    await _storage.write(
      key: StorageKeys.accessToken,
      value: tokens['access_token'] as String,
    );
    await _storage.write(
      key: StorageKeys.refreshToken,
      value: tokens['refresh_token'] as String,
    );
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  ApiException _asApiException(DioException error) {
    final transformed = error.error;
    if (transformed is ApiException) {
      return transformed;
    }
    return ApiException.fromDio(error);
  }
}
