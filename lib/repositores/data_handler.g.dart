// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplacesData _$MarketplacesDataFromJson(Map<String, dynamic> json) =>
    MarketplacesData(
      (json['marketplaces'] as List<dynamic>).map((e) => e as String).toList(),
      (json['brands'] as List<dynamic>)
          .map((e) => Brand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      json['name'] as String,
      (json['products'] as List<dynamic>)
          .map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      false,
    );

ProductCard _$ProductCardFromJson(Map<String, dynamic> json) => ProductCard(
      json['title'] as String,
      json['currentPrice'] as String,
      json['oldPrice'] as String?,
      json['imgSrc'] as String,
      json['volume'] as String?,
      json['marketplace'] as String,
    );
