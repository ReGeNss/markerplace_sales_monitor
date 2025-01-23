import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:markerplace_sales_monitor/entities.dart';

class DataRepository{
  Future<MarketplacesData> getData() async {
      final apiUrl = dotenv.env['API_URL'];
      if(apiUrl == null){
        throw Exception('API_URL is not set');
      }
      final client = http.Client(); 
      final requestUrl = Uri.https(apiUrl);
      final response = await client.get(requestUrl);
      if( response.statusCode != 200){
        throw Exception('Failed to load data: ${response.statusCode}'); 
      }
      client.close();
      final responseJson = response.body;
      final data = jsonDecode(responseJson);
      return MarketplacesData.fromJson(data[0]);
  }
}
