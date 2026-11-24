import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/product_details_translation.dart';

final productTranslationRepositoryProvider =
    Provider<ProductTranslationRepository>((ref) {
      return ApiProductTranslationRepository(ref.watch(apiClientProvider));
    });

abstract interface class ProductTranslationRepository {
  Future<ProductDetailsTranslation> translate(
    ProductDetailsText details,
    String targetLanguage,
  );
}

class ApiProductTranslationRepository implements ProductTranslationRepository {
  const ApiProductTranslationRepository(this._dio);

  final Dio _dio;

  @override
  Future<ProductDetailsTranslation> translate(
    ProductDetailsText details,
    String targetLanguage,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/translations/product-details',
        data: {'target_language': targetLanguage, 'details': details.toJson()},
      );
      final data = response.data;
      if (data == null) {
        throw const FormatException('Translation response body is empty.');
      }
      return ProductDetailsTranslation.fromJson(data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
