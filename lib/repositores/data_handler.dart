import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:markerplace_sales_monitor/repositores/internet_connection_handler.dart';
part 'data_handler.g.dart';

class DataHandler {
  static const String _url = 'container-function.grayplant-56db7559.westeurope.azurecontainerapps.io';
  static const String _unencodetPath = '/api/httpGetScrapedData';
  static final InternetConnectionHandler _internetConnectionHandler = InternetConnectionHandler(); 

  Future<MarketplacesData> getSalesData() async{ 
    final dataInString = await _internetConnectionHandler.getData(_url, _unencodetPath);
    final dataJson = jsonDecode(utf8.decode(dataInString.codeUnits));
    final data = MarketplacesData.fromJson(dataJson[0]);
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
    if(oldPrice == null || oldPrice!.isEmpty || oldPrice == 'null') {
      percentOfSale = null;
       return; 
    } // TODO: FIX IN FUTURE
    final current= getCurrentPriceAsDouble();
    final old = getOldPriceAsDouble();
    final percent = 100 - ((current / old) * 100);
    percentOfSale = percent.toInt();
  }

  factory ProductCard.fromJson(Map<String, dynamic> json) => _$ProductCardFromJson(json);
  
  final String title; 
  final String currentPrice;
  final String? oldPrice; 
  final String imgSrc;
  final String? volume; 
  final String marketplace; 
  late final int? percentOfSale;


  double getCurrentPriceAsDouble(){
    final price = currentPrice.split(' ')[0].replaceAll(',', '.');
    return double.parse(price);
  }

  double getOldPriceAsDouble(){
    if(oldPrice == null ){
      throw Error();
    }
    final price = oldPrice!.split(' ')[0].replaceAll(',', '.');
    final parsedPrice = double.parse(price);
    return parsedPrice;
  } 

  @override 
  String toString() => 'title: $title, currentPrice: $currentPrice, oldPrice: $oldPrice, imgSrc: $imgSrc, percentOfSale: $percentOfSale';
}
