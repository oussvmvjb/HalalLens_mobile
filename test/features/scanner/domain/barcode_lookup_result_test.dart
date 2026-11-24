import 'package:flutter_test/flutter_test.dart';
import 'package:halal_lens/features/scanner/domain/barcode_lookup_result.dart';

void main() {
  test('preserves product ingredients and conservative analysis status', () {
    final result = BarcodeLookupResult.fromJson({
      'success': true,
      'status': 'completed',
      'product': {
        'id': '00000000-0000-0000-0000-000000000001',
        'barcode': '5449000000996',
        'name': 'Soap',
        'brand': 'Example',
        'image_url': null,
        'source': 'open_food_facts',
        'ingredients': ['Aqua', 'Gelatin', 'Limonene'],
        'ingredients_text': 'Aqua, Gelatin, Limonene',
        'categories': ['en:soaps'],
        'country_of_origin': null,
        'origin_description': 'France',
        'labels': ['en:organic'],
        'nutriments': {'energy-kcal_100g': 12},
      },
      'analysis': {
        'scan_id': '00000000-0000-0000-0000-000000000002',
        'overall_status': 'UNKNOWN',
        'confidence_score': null,
        'explanation': 'No religious ruling was generated.',
      },
      'certifications': [],
    });

    expect(result.product.ingredients, ['Aqua', 'Gelatin', 'Limonene']);
    expect(result.product.originDescription, 'France');
    expect(result.product.labels, ['en:organic']);
    expect(result.product.nutriments['energy-kcal_100g'], 12.0);
    expect(result.analysis.status, 'UNKNOWN');
    expect(result.certifications, isEmpty);
  });

  test('accepts a product with incomplete source data', () {
    final result = BarcodeLookupResult.fromJson({
      'success': true,
      'status': 'completed',
      'product': {
        'id': '00000000-0000-0000-0000-000000000001',
        'barcode': '5449000000996',
        'name': null,
        'brand': null,
        'image_url': null,
        'source': 'open_food_facts',
        'ingredients': [],
        'ingredients_text': null,
        'categories': [],
        'country_of_origin': null,
        'origin_description': null,
        'labels': [],
        'nutriments': {},
      },
      'analysis': {
        'scan_id': '00000000-0000-0000-0000-000000000002',
        'overall_status': 'UNKNOWN',
        'confidence_score': null,
        'explanation': 'Insufficient information.',
      },
      'certifications': [],
    });

    expect(result.product.name, isNull);
    expect(result.product.ingredients, isEmpty);
    expect(result.product.imageUrl, isNull);
    expect(result.analysis.status, 'UNKNOWN');
  });

  test('rejects a malformed success response', () {
    expect(
      () => BarcodeLookupResult.fromJson({'success': true}),
      throwsFormatException,
    );
  });
}
