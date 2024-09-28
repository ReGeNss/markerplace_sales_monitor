// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceData _$MarketplaceDataFromJson(Map<String, dynamic> json) =>
    MarketplaceData(
      json['marketplace'] as String,
      (json['products'] as List<dynamic>)
          .map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ProductCard _$ProductCardFromJson(Map<String, dynamic> json) => ProductCard(
      json['title'] as String,
      json['currentPrice'] as String,
      json['oldPrice'] as String?,
      json['imgSrc'] as String,
    );
