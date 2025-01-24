// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplacesData _$MarketplacesDataFromJson(Map<String, dynamic> json) =>
    MarketplacesData(
      (json['marketplaces'] as List<dynamic>).map((e) => e as String).toList(),
      (json['brands'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );


ProductCard _$ProductCardFromJson(Map<String, dynamic> json) => ProductCard(
      json['title'] as String,
      double.parse(json['currentPrice'].split(' ')[0].replaceAll(',', '.')),
      json['oldPrice'] == null
          ? null
          : double.parse(json['oldPrice'].split(' ')[0].replaceAll(',', '.')),
      json['imgSrc'] as String,
      json['volume'] as String?,
      json['marketplace'] as String,
    );
