class ProductDetailsText {
  const ProductDetailsText({
    this.productName,
    this.brand,
    this.ingredients = const [],
    this.categories = const [],
    this.originDescription,
    this.labels = const [],
    this.certificationIssuers = const [],
    required this.analysisExplanation,
  });

  final String? productName;
  final String? brand;
  final List<String> ingredients;
  final List<String> categories;
  final String? originDescription;
  final List<String> labels;
  final List<String> certificationIssuers;
  final String analysisExplanation;

  Map<String, Object?> toJson() => {
    'product_name': productName,
    'brand': brand,
    'ingredients': ingredients,
    'categories': categories,
    'origin_description': originDescription,
    'labels': labels,
    'certification_issuers': certificationIssuers,
    'analysis_explanation': analysisExplanation,
  };

  factory ProductDetailsText.fromJson(Map<String, dynamic> json) {
    return ProductDetailsText(
      productName: _optionalString(json['product_name']),
      brand: _optionalString(json['brand']),
      ingredients: _stringList(json['ingredients']),
      categories: _stringList(json['categories']),
      originDescription: _optionalString(json['origin_description']),
      labels: _stringList(json['labels']),
      certificationIssuers: _stringList(json['certification_issuers']),
      analysisExplanation: _requiredString(json, 'analysis_explanation'),
    );
  }
}

class ProductDetailsTranslation {
  const ProductDetailsTranslation({
    required this.targetLanguage,
    required this.details,
  });

  final String targetLanguage;
  final ProductDetailsText details;

  factory ProductDetailsTranslation.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    if (details is! Map) {
      throw const FormatException(
        'Translation response has no product details.',
      );
    }
    return ProductDetailsTranslation(
      targetLanguage: _requiredString(json, 'target_language'),
      details: ProductDetailsText.fromJson(Map<String, dynamic>.from(details)),
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) return value;
  throw FormatException('Translation response is missing $key.');
}

String? _optionalString(Object? value) => value is String ? value : null;

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList(growable: false);
}
