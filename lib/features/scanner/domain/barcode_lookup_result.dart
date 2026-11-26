class BarcodeLookupResult {
  const BarcodeLookupResult({
    required this.product,
    required this.analysis,
    required this.certifications,
  });

  final BarcodeProduct product;
  final BarcodeAnalysis analysis;
  final List<BarcodeCertification> certifications;

  factory BarcodeLookupResult.fromJson(Map<String, dynamic> json) {
    if (json['success'] != true ||
        json['status'] != 'completed' ||
        json['product'] is! Map ||
        json['analysis'] is! Map) {
      throw const FormatException('Invalid barcode lookup response.');
    }

    final certificationData = json['certifications'];
    return BarcodeLookupResult(
      product: BarcodeProduct.fromJson(
        Map<String, dynamic>.from(json['product'] as Map),
      ),
      analysis: BarcodeAnalysis.fromJson(
        Map<String, dynamic>.from(json['analysis'] as Map),
      ),
      certifications:
          certificationData is List
              ? certificationData
                  .whereType<Map>()
                  .map(
                    (value) => BarcodeCertification.fromJson(
                      Map<String, dynamic>.from(value),
                    ),
                  )
                  .toList(growable: false)
              : const [],
    );
  }
}

class BarcodeProduct {
  const BarcodeProduct({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.source,
    required this.ingredients,
    required this.ingredientsText,
    required this.categories,
    required this.countryOfOrigin,
    required this.originDescription,
    required this.labels,
    required this.nutriments,
  });

  final String barcode;
  final String? name;
  final String? brand;
  final String? imageUrl;
  final String? source;
  final List<String> ingredients;
  final String? ingredientsText;
  final List<String> categories;
  final String? countryOfOrigin;
  final String? originDescription;
  final List<String> labels;
  final Map<String, double> nutriments;

  factory BarcodeProduct.fromJson(Map<String, dynamic> json) {
    return BarcodeProduct(
      barcode: _requiredString(json, 'barcode'),
      name: _optionalString(json['name']),
      brand: _optionalString(json['brand']),
      imageUrl: _optionalString(json['image_url']),
      source: _optionalString(json['source']),
      ingredients: _stringList(json['ingredients']),
      ingredientsText: _optionalString(json['ingredients_text']),
      categories: _stringList(json['categories']),
      countryOfOrigin: _optionalString(json['country_of_origin']),
      originDescription: _optionalString(json['origin_description']),
      labels: _stringList(json['labels']),
      nutriments: _doubleMap(json['nutriments']),
    );
  }
}

class BarcodeAnalysis {
  const BarcodeAnalysis({
    required this.scanId,
    required this.status,
    required this.confidence,
    required this.explanation,
    this.verdict,
    this.analysisVersion,
    this.analyzedAt,
    this.warnings = const [],
    this.ingredientsAnalysis = const [],
  });

  final String scanId;
  final String status;
  final double? confidence;
  final String explanation;
  final String? verdict;
  final String? analysisVersion;
  final DateTime? analyzedAt;
  final List<String> warnings;
  final List<IngredientAnalysisItem> ingredientsAnalysis;

  factory BarcodeAnalysis.fromJson(Map<String, dynamic> json) {
    final rawItems = json['ingredients_analysis'];
    return BarcodeAnalysis(
      scanId: _requiredString(json, 'scan_id'),
      status: _requiredString(json, 'overall_status'),
      confidence:
          json['confidence_score'] is num
              ? (json['confidence_score'] as num).toDouble()
              : null,
      explanation: _requiredString(json, 'explanation'),
      verdict: _optionalString(json['verdict']),
      analysisVersion: _optionalString(json['analysis_version']),
      analyzedAt:
          json['analyzed_at'] is String
              ? DateTime.tryParse(json['analyzed_at'] as String)
              : null,
      warnings: _stringList(json['warnings']),
      ingredientsAnalysis:
          rawItems is List
              ? rawItems
                  .whereType<Map>()
                  .map(
                    (item) => IngredientAnalysisItem.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList(growable: false)
              : const [],
    );
  }
}

class IngredientAnalysisItem {
  const IngredientAnalysisItem({
    required this.originalText,
    required this.normalizedName,
    required this.status,
    required this.reason,
    this.eNumber,
    this.insNumber,
    this.sources = const [],
  });

  final String originalText;
  final String normalizedName;
  final String status;
  final String reason;
  final String? eNumber;
  final String? insNumber;
  final List<String> sources;

  factory IngredientAnalysisItem.fromJson(Map<String, dynamic> json) {
    final rawEvidence = json['evidence'];
    final sourceNames = <String>[];
    if (rawEvidence is List) {
      for (final entry in rawEvidence.whereType<Map>()) {
        final name = entry['source_name'];
        if (name is String && name.isNotEmpty) {
          sourceNames.add(name);
        }
      }
    }
    return IngredientAnalysisItem(
      originalText: _optionalString(json['original_text']) ?? '',
      normalizedName: _optionalString(json['normalized_name']) ?? '',
      status: _optionalString(json['status']) ?? 'unknown',
      reason: _optionalString(json['reason']) ?? '',
      eNumber: _optionalString(json['e_number']),
      insNumber: _optionalString(json['ins_number']),
      sources: sourceNames,
    );
  }
}

class BarcodeCertification {
  const BarcodeCertification({
    required this.issuer,
    required this.authorityStatus,
    required this.certificateNumber,
    required this.expiryDate,
    required this.verificationStatus,
    required this.evidenceUrl,
  });

  final String issuer;
  final String authorityStatus;
  final String? certificateNumber;
  final String? expiryDate;
  final String verificationStatus;
  final String? evidenceUrl;

  factory BarcodeCertification.fromJson(Map<String, dynamic> json) {
    return BarcodeCertification(
      issuer: _requiredString(json, 'issuer'),
      authorityStatus: _requiredString(json, 'issuer_authority_status'),
      certificateNumber: _optionalString(json['certificate_number']),
      expiryDate: _optionalString(json['expiry_date']),
      verificationStatus: _requiredString(json, 'verification_status'),
      evidenceUrl: _optionalString(json['evidence_url']),
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) return value;
  throw FormatException('Barcode response is missing $key.');
}

String? _optionalString(Object? value) => value is String ? value : null;

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList(growable: false);
}

Map<String, double> _doubleMap(Object? value) {
  if (value is! Map) return const {};
  return {
    for (final entry in value.entries)
      if (entry.key is String && entry.value is num)
        entry.key as String: (entry.value as num).toDouble(),
  };
}
