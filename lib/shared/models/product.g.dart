// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'barcode': instance.barcode,
      'name': instance.name,
      'brand': instance.brand,
      'image_url': instance.imageUrl,
    };
