import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halal_lens/features/product/data/product_translation_repository.dart';
import 'package:halal_lens/features/product/domain/product_details_translation.dart';

class _TranslationAdapter implements HttpClientAdapter {
  _TranslationAdapter(this.onRequest);

  final void Function(RequestOptions options) onRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onRequest(options);
    return ResponseBody.fromString(
      jsonEncode({
        'target_language': 'en',
        'details': {
          'product_name': 'Cleanser',
          'brand': 'Clear Spring',
          'ingredients': ['Water', 'Glycerin'],
          'categories': ['Personal care'],
          'origin_description': 'China',
          'labels': ['Fragrance-free'],
          'certification_issuers': ['Halal Certification Board'],
          'analysis_explanation': 'Analysis is not yet available.',
        },
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'sends product-only text and keeps translated ingredient order',
    () async {
      RequestOptions? request;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/v1'))
        ..httpClientAdapter = _TranslationAdapter(
          (options) => request = options,
        );
      const source = ProductDetailsText(
        productName: '洁面乳',
        brand: '清泉',
        ingredients: ['水', '甘油'],
        analysisExplanation: '尚未完成验证。',
      );

      final result = await ApiProductTranslationRepository(
        dio,
      ).translate(source, 'en');

      expect(request?.method, 'POST');
      expect(request?.path, '/translations/product-details');
      expect((request?.data as Map<String, dynamic>)['target_language'], 'en');
      expect(
        (request?.data as Map<String, dynamic>)['details']['ingredients'],
        ['水', '甘油'],
      );
      expect(result.details.ingredients, ['Water', 'Glycerin']);
      expect(source.ingredients, ['水', '甘油']);
      dio.close(force: true);
    },
  );
}
