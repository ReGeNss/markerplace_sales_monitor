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
    MarketplaceData data = MarketplaceData.fromJson(dataJson[3]); 
    return [data]; // TODO: return all data  
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

  factory ProductCard.fromJson(Map<String, dynamic> json) => _$ProductCardFromJson(json);

  ProductCard(this.title, this.currentPrice, this.oldPrice, this.imgSrc); 
}