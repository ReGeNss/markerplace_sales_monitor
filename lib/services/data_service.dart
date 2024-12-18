import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:markerplace_sales_monitor/repositores/data_repository.dart';

part 'data_service.g.dart';

class DataService {
  static final dataRepository = DataRepository(); 

  Future<MarketplacesData> getSalesData() async{ 
    final dataInString = await dataRepository.getData();
    final dataJson = jsonDecode(dataInString);
    final data = MarketplacesData.fromJson(dataJson);
    return data;
  }
}

@JsonSerializable(createToJson: false)
class MarketplacesData{
  MarketplacesData(this.marketplaces, this.brands);

  factory MarketplacesData.fromJson(Map<String, dynamic> json) => _$MarketplacesDataFromJson(json);
  
  final List<String> marketplaces;
  final List<Brand> brands; 
}

@JsonSerializable(createToJson: false)
class Brand{
  Brand(this.name, this.products,this.isSelected);

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  bool isSelected; 
  final String name;
  final List<ProductCard> products; 
}

@JsonSerializable(createToJson: false)
class ProductCard{
  ProductCard(this.title, this.currentPrice, this.oldPrice, this.imgSrc, this.volume, this.marketplace){
    if(oldPrice == null) {
      percentOfSale = null;
      return; 
    }
    final stringPersentOfSale = 100 - ((currentPrice / oldPrice!) * 100);
    percentOfSale = stringPersentOfSale.toInt();
  }

  factory ProductCard.fromJson(Map<String, dynamic> json) => _$ProductCardFromJson(json);
  
  final String title; 
  final double currentPrice;
  final double? oldPrice; 
  final String imgSrc;
  final String? volume; 
  final String marketplace; 
  late final int? percentOfSale;

  @override 
  String toString() => 'title: $title, currentPrice: $currentPrice, oldPrice: $oldPrice, imgSrc: $imgSrc, percentOfSale: $percentOfSale';
}
