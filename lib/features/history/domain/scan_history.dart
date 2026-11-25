class ScanHistoryItem {
  const ScanHistoryItem({
    required this.id,
    required this.scanType,
    required this.barcode,
    required this.scanStatus,
    required this.createdAt,
    required this.product,
    required this.analysis,
  });

  final String id;
  final String scanType;
  final String? barcode;
  final String scanStatus;
  final DateTime createdAt;
  final ScanProductSnapshot product;
  final ScanAnalysisSnapshot analysis;

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) =>
      ScanHistoryItem(
        id: json['id'] as String,
        scanType: json['scan_type'] as String,
        barcode: json['barcode'] as String?,
        scanStatus: json['scan_status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        product: ScanProductSnapshot.fromJson(
          Map<String, dynamic>.from(json['product'] as Map),
        ),
        analysis: ScanAnalysisSnapshot.fromJson(
          Map<String, dynamic>.from(json['analysis'] as Map),
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'scan_type': scanType,
        'barcode': barcode,
        'scan_status': scanStatus,
        'created_at': createdAt.toIso8601String(),
        'product': product.toJson(),
        'analysis': analysis.toJson(),
      };
}

class ScanProductSnapshot {
  const ScanProductSnapshot({
    required this.name,
    required this.brand,
    required this.barcode,
    required this.imageUrl,
    required this.description,
    required this.categories,
    required this.countryOfOrigin,
    required this.ingredients,
    required this.ingredientsText,
    required this.nutriments,
    required this.labels,
    required this.source,
  });

  final String? name;
  final String? brand;
  final String? barcode;
  final String? imageUrl;
  final String? description;
  final List<String> categories;
  final String? countryOfOrigin;
  final List<Map<String, dynamic>> ingredients;
  final String? ingredientsText;
  final Map<String, dynamic> nutriments;
  final List<String> labels;
  final String? source;

  factory ScanProductSnapshot.fromJson(Map<String, dynamic> json) =>
      ScanProductSnapshot(
        name: json['name'] as String?,
        brand: json['brand'] as String?,
        barcode: json['barcode'] as String?,
        imageUrl: json['image_url'] as String?,
        description: json['description'] as String?,
        categories: _stringList(json['categories']),
        countryOfOrigin: json['country_of_origin'] as String?,
        ingredients: (json['ingredients'] is List)
            ? (json['ingredients'] as List)
                .whereType<Map>()
                .map((value) => Map<String, dynamic>.from(value))
                .toList(growable: false)
            : const [],
        ingredientsText: json['ingredients_text'] as String?,
        nutriments: json['nutriments'] is Map
            ? Map<String, dynamic>.from(json['nutriments'] as Map)
            : const {},
        labels: _stringList(json['labels']),
        source: json['source'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'brand': brand,
        'barcode': barcode,
        'image_url': imageUrl,
        'description': description,
        'categories': categories,
        'country_of_origin': countryOfOrigin,
        'ingredients': ingredients,
        'ingredients_text': ingredientsText,
        'nutriments': nutriments,
        'labels': labels,
        'source': source,
      };
}

class ScanAnalysisSnapshot {
  const ScanAnalysisSnapshot({
    required this.overallStatus,
    required this.confidenceScore,
    required this.explanation,
    required this.analysisVersion,
    required this.warnings,
    required this.ingredientsAnalysis,
    required this.certifications,
  });

  final String overallStatus;
  final double? confidenceScore;
  final String explanation;
  final String analysisVersion;
  final List<String> warnings;
  final List<Map<String, dynamic>> ingredientsAnalysis;
  final List<Map<String, dynamic>> certifications;

  factory ScanAnalysisSnapshot.fromJson(Map<String, dynamic> json) =>
      ScanAnalysisSnapshot(
        overallStatus: json['overall_status'] as String? ?? 'UNKNOWN',
        confidenceScore: json['confidence_score'] is num
            ? (json['confidence_score'] as num).toDouble()
            : null,
        explanation: json['explanation'] as String? ?? 'Analysis unavailable.',
        analysisVersion: json['analysis_version'] as String? ?? 'foundation-v1',
        warnings: _stringList(json['warnings']),
        ingredientsAnalysis: (json['ingredients_analysis'] is List)
            ? (json['ingredients_analysis'] as List)
                .whereType<Map>()
                .map((value) => Map<String, dynamic>.from(value))
                .toList(growable: false)
            : const [],
        certifications: (json['certifications'] is List)
            ? (json['certifications'] as List)
                .whereType<Map>()
                .map((value) => Map<String, dynamic>.from(value))
                .toList(growable: false)
            : const [],
      );

  Map<String, dynamic> toJson() => {
        'overall_status': overallStatus,
        'confidence_score': confidenceScore,
        'explanation': explanation,
        'analysis_version': analysisVersion,
        'warnings': warnings,
        'ingredients_analysis': ingredientsAnalysis,
        'certifications': certifications,
      };
}

class ScanDetails extends ScanHistoryItem {
  const ScanDetails({
    required super.id,
    required super.scanType,
    required super.barcode,
    required super.scanStatus,
    required super.createdAt,
    required super.product,
    required super.analysis,
    required this.imageUrl,
    required this.originalIngredientsText,
    required this.detectedLanguage,
    required this.analysisCompletedAt,
  });

  final String? imageUrl;
  final String? originalIngredientsText;
  final String? detectedLanguage;
  final DateTime? analysisCompletedAt;

  factory ScanDetails.fromJson(Map<String, dynamic> json) => ScanDetails(
        id: json['id'] as String,
        scanType: json['scan_type'] as String,
        barcode: json['barcode'] as String?,
        scanStatus: json['scan_status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        product: ScanProductSnapshot.fromJson(
          Map<String, dynamic>.from(json['product'] as Map),
        ),
        analysis: ScanAnalysisSnapshot.fromJson(
          Map<String, dynamic>.from(json['analysis'] as Map),
        ),
        imageUrl: json['image_url'] as String?,
        originalIngredientsText: json['original_ingredients_text'] as String?,
        detectedLanguage: json['detected_language'] as String?,
        analysisCompletedAt: json['analysis_completed_at'] is String
            ? DateTime.parse(json['analysis_completed_at'] as String)
            : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'image_url': imageUrl,
        'original_ingredients_text': originalIngredientsText,
        'detected_language': detectedLanguage,
        'analysis_completed_at': analysisCompletedAt?.toIso8601String(),
      };
}

List<String> _stringList(Object? value) =>
    value is List ? value.whereType<String>().toList(growable: false) : const [];
