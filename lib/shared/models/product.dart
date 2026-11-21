// Freezed applies JsonKey to constructor parameters, then generates the backing fields.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String barcode,
    required String name,
    String? brand,
    @JsonKey(name: 'image_url')
    String? imageUrl,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
