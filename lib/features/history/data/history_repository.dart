import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/api_client.dart';
import '../domain/scan_history.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return ApiHistoryRepository(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageProvider),
  );
});

abstract interface class HistoryRepository {
  Future<List<ScanHistoryItem>> fetchHistory({int limit = 20, int offset = 0});
  Future<ScanDetails> fetchDetails(String scanId);
}

class ApiHistoryRepository implements HistoryRepository {
  ApiHistoryRepository(this._dio, this._storage);

  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _historyCacheKey = 'halallens.scan_history';
  static const _detailsCachePrefix = 'halallens.scan_details.';

  @override
  Future<List<ScanHistoryItem>> fetchHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/scans/history',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = response.data ?? const [];
      final items = data
          .whereType<Map>()
          .map((value) => ScanHistoryItem.fromJson(
                Map<String, dynamic>.from(value),
              ))
          .toList(growable: false);
      await _storage.write(
        key: _historyCacheKey,
        value: jsonEncode([
          for (final item in items) item.toJson(),
        ]),
      );
      return items;
    } on DioException {
      final cached = await _storage.read(key: _historyCacheKey);
      if (cached != null) {
        final data = jsonDecode(cached);
        if (data is List) {
          return data
              .whereType<Map>()
              .map((value) => ScanHistoryItem.fromJson(
                    Map<String, dynamic>.from(value),
                  ))
              .toList(growable: false);
        }
      }
      rethrow;
    }
  }

  @override
  Future<ScanDetails> fetchDetails(String scanId) async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/scans/$scanId');
      final data = response.data;
      if (data == null) {
        throw const FormatException('Scan details response is empty.');
      }
      final details = ScanDetails.fromJson(data);
      await _storage.write(
        key: '$_detailsCachePrefix$scanId',
        value: jsonEncode(details.toJson()),
      );
      return details;
    } on DioException {
      final cached =
          await _storage.read(key: '$_detailsCachePrefix$scanId');
      if (cached != null) {
        final data = jsonDecode(cached);
        if (data is Map) {
          return ScanDetails.fromJson(Map<String, dynamic>.from(data));
        }
      }
      rethrow;
    }
  }
}
