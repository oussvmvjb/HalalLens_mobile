class OcrTextRegion {
  const OcrTextRegion({
    required this.text,
    required this.confidence,
    required this.boundingBox,
  });

  final String text;
  final double confidence;
  final List<List<double>> boundingBox;

  factory OcrTextRegion.fromJson(Map<String, dynamic> json) {
    final text = json['text'];
    final confidence = json['confidence'];
    final rawBoundingBox = json['bounding_box'] ?? const <dynamic>[];
    if (text is! String || confidence is! num || rawBoundingBox is! List) {
      throw const FormatException('OCR text region has an invalid shape.');
    }

    final boundingBox = <List<double>>[];
    for (final rawPoint in rawBoundingBox) {
      if (rawPoint is! List ||
          rawPoint.any((coordinate) => coordinate is! num)) {
        throw const FormatException('OCR bounding box has an invalid shape.');
      }
      boundingBox.add(
        rawPoint.map((coordinate) => (coordinate as num).toDouble()).toList(),
      );
    }

    return OcrTextRegion(
      text: text,
      confidence: confidence.toDouble(),
      boundingBox: boundingBox,
    );
  }
}

class OcrIngredientSuggestion {
  const OcrIngredientSuggestion({
    required this.originalText,
    required this.normalizedText,
    required this.confidence,
    required this.normalizationConfidence,
    required this.needsReview,
  });

  final String originalText;
  final String? normalizedText;
  final double confidence;
  final double normalizationConfidence;
  final bool needsReview;

  factory OcrIngredientSuggestion.fromJson(Map<String, dynamic> json) {
    final originalText = json['original_text'];
    final normalizedText = json['normalized_text'];
    final confidence = json['confidence'];
    final normalizationConfidence = json['normalization_confidence'];
    final needsReview = json['needs_review'];
    if (originalText is! String ||
        (normalizedText != null && normalizedText is! String) ||
        confidence is! num ||
        normalizationConfidence is! num ||
        needsReview is! bool) {
      throw const FormatException('OCR ingredient has an invalid shape.');
    }

    return OcrIngredientSuggestion(
      originalText: originalText,
      normalizedText: normalizedText as String?,
      confidence: confidence.toDouble(),
      normalizationConfidence: normalizationConfidence.toDouble(),
      needsReview: needsReview,
    );
  }
}

class OcrTextResult {
  const OcrTextResult({
    required this.success,
    required this.fullText,
    required this.extractedText,
    this.language = const [],
    this.ingredients = const [],
    this.warnings = const [],
  });

  final bool success;
  final String fullText;
  final List<OcrTextRegion> extractedText;
  final List<String> language;
  final List<OcrIngredientSuggestion> ingredients;
  final List<String> warnings;

  factory OcrTextResult.fromJson(Map<String, dynamic> json) {
    final success = json['success'];
    final fullText = json['full_text'];
    final rawRegions = json['extracted_text'] ?? const <dynamic>[];
    final rawLanguages = json['language'] ?? const <dynamic>[];
    final rawIngredients = json['ingredients'] ?? const <dynamic>[];
    final rawWarnings = json['warnings'] ?? const <dynamic>[];
    if (success is! bool ||
        fullText is! String ||
        rawRegions is! List ||
        rawLanguages is! List ||
        rawIngredients is! List ||
        rawWarnings is! List) {
      throw const FormatException('OCR response has an invalid shape.');
    }

    return OcrTextResult(
      success: success,
      fullText: fullText,
      extractedText:
          rawRegions
              .map(
                (region) =>
                    OcrTextRegion.fromJson(_asJsonMap(region, 'region')),
              )
              .toList(),
      language: _asStringList(rawLanguages, 'language'),
      ingredients:
          rawIngredients
              .map(
                (ingredient) => OcrIngredientSuggestion.fromJson(
                  _asJsonMap(ingredient, 'ingredient'),
                ),
              )
              .toList(),
      warnings: _asStringList(rawWarnings, 'warnings'),
    );
  }
}

Map<String, dynamic> _asJsonMap(Object? value, String field) {
  if (value is Map<String, dynamic>) return value;
  throw FormatException('OCR $field must be an object.');
}

List<String> _asStringList(List<dynamic> values, String field) {
  if (values.any((value) => value is! String)) {
    throw FormatException('OCR $field must contain strings.');
  }
  return values.cast<String>();
}
