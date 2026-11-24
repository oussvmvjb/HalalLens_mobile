import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/barcode_lookup_result.dart';

final barcodeRepositoryProvider = Provider<BarcodeRepository>((ref) {
  return ApiBarcodeRepository(ref.watch(apiClientProvider));
});

abstract interface class BarcodeRepository {
  Future<BarcodeLookupResult> lookup(String barcode);
}

class ApiBarcodeRepository implements BarcodeRepository {
  const ApiBarcodeRepository(this._dio);

  final Dio _dio;

  @override
  Future<BarcodeLookupResult> lookup(String barcode) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/scan/barcode',
        data: {'barcode': barcode},
      );
      final data = response.data;
      if (data == null) {
        throw const FormatException('Barcode response body is empty.');
      }
      return BarcodeLookupResult.fromJson(data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
