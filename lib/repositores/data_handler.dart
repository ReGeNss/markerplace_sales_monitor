import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:markerplace_sales_monitor/repositores/internet_connection_handler.dart';
part 'data_handler.g.dart';

class DataHandler {
  static const String _url = 'container-function.grayplant-56db7559.westeurope.azurecontainerapps.io';
  static const String _unencodetPath = '/api/httpGetMarketplaces';
  static final InternetConnectionHandler _internetConnectionHandler = InternetConnectionHandler(); 

  Future<List<MarketplaceData>> getSalesData() async{ 
    final dataInString = await _internetConnectionHandler.getData(_url, _unencodetPath);
    final dataJson = jsonDecode(dataInString);
    final data = <MarketplaceData>[]; 
    for(var e in dataJson){
      data.add(MarketplaceData.fromJson(e));
    }
    return data;
  }

}


@JsonSerializable(createToJson: false)
class MarketplaceData{
  final String marketplace;
  final List<ProductCard> products;

  factory MarketplaceData.fromJson(Map<String, dynamic> json) => _$MarketplaceDataFromJson(json);

  MarketplaceData(this.marketplace, this.products); 
}

@JsonSerializable(createToJson: false)
class ProductCard{
  final String title; 
  final String currentPrice;
  final String? oldPrice; 
  final String imgSrc;
  late final int? percentOfSale;

  factory ProductCard.fromJson(Map<String, dynamic> json) => _$ProductCardFromJson(json);


  double getCurrentPriceAsDouble(){
    final price = currentPrice.split(' ')[0].replaceAll(',', '.');
    return double.parse(price);
  }
  double getOldPriceAsDouble(){
    // print('$this ${oldPrice == null}' ); 
    if(oldPrice == null ){
      throw Error();
    }
    final price = oldPrice!.split(' ')[0].replaceAll(',', '.');
    final parsedPrice = double.parse(price);
    return parsedPrice;
  }

  ProductCard(this.title, this.currentPrice, this.oldPrice, this.imgSrc){
    if(oldPrice == null || oldPrice!.isEmpty || oldPrice == 'null') {percentOfSale = null; return; } // TODO: FIX IN FUTURE
    final current= getCurrentPriceAsDouble();
    final old = getOldPriceAsDouble();
    final percent = 100 - ((current / old) * 100);
    percentOfSale = percent.toInt();
  } 

  @override 
  String toString() => 'title: $title, currentPrice: $currentPrice, oldPrice: $oldPrice, imgSrc: $imgSrc, percentOfSale: $percentOfSale';
}