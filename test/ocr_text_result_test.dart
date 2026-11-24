import 'package:flutter_test/flutter_test.dart';
import 'package:halal_lens/features/scanner/domain/ocr_text_result.dart';

void main() {
  test(
    'parses OCR regions, ingredient suggestions, languages, and warnings',
    () {
      final result = OcrTextResult.fromJson({
        'success': true,
        'status': 'completed',
        'message': 'Text extracted successfully.',
        'data': {
          'extracted_text': [
            {'text': 'Ingredients: LIMONNE', 'confidence': 0.82},
          ],
        },
        'language': ['en', 'fr'],
        'full_text': 'Ingredients: LIMONNE',
        'extracted_text': [
          {
            'text': 'Ingredients: LIMONNE',
            'confidence': 0.82,
            'bounding_box': [
              [1, 2],
              [3, 2],
            ],
          },
        ],
        'ingredients': [
          {
            'original_text': 'LIMONNE',
            'normalized_text': 'LIMONENE',
            'confidence': 0.82,
            'normalization_confidence': 0.9,
            'needs_review': true,
          },
        ],
        'warnings': ['Please review uncertain ingredient names.'],
      });

      expect(result.success, isTrue);
      expect(result.fullText, 'Ingredients: LIMONNE');
      expect(result.language, ['en', 'fr']);
      expect(result.extractedText.single.boundingBox, [
        [1.0, 2.0],
        [3.0, 2.0],
      ]);
      expect(result.ingredients.single.originalText, 'LIMONNE');
      expect(result.ingredients.single.normalizedText, 'LIMONENE');
      expect(result.ingredients.single.needsReview, isTrue);
      expect(result.warnings, ['Please review uncertain ingredient names.']);
    },
  );

  test('defaults additive fields when parsing the legacy response shape', () {
    final result = OcrTextResult.fromJson({
      'success': true,
      'full_text': 'AQUA',
      'extracted_text': [
        {'text': 'AQUA', 'confidence': 0.98, 'bounding_box': []},
      ],
    });

    expect(result.language, isEmpty);
    expect(result.ingredients, isEmpty);
    expect(result.warnings, isEmpty);
  });

  test('preserves Simplified Chinese OCR and ingredient text', () {
    final result = OcrTextResult.fromJson({
      'success': true,
      'language': ['zh_CN', 'en'],
      'full_text': '配料表：水、甘油、AQUA',
      'extracted_text': [
        {'text': '配料表：水、甘油、AQUA', 'confidence': 0.96, 'bounding_box': []},
      ],
      'ingredients': [
        {
          'original_text': '水',
          'normalized_text': '水',
          'confidence': 0.95,
          'normalization_confidence': 1.0,
          'needs_review': false,
        },
      ],
      'warnings': [],
    });

    expect(result.language, ['zh_CN', 'en']);
    expect(result.fullText, '配料表：水、甘油、AQUA');
    expect(result.extractedText.single.text, '配料表：水、甘油、AQUA');
    expect(result.ingredients.single.originalText, '水');
  });

  test('rejects malformed OCR response data with a format error', () {
    expect(
      () => OcrTextResult.fromJson({
        'success': true,
        'full_text': 'AQUA',
        'extracted_text': [
          {'text': 42, 'confidence': 0.98, 'bounding_box': []},
        ],
      }),
      throwsFormatException,
    );
  });
}
