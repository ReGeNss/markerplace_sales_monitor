import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:markerplace_sales_monitor/entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository{
  final getCatigoryPath = 'categories';
  final apiUrl = dotenv.env['API_URL'];

  Future<MarketplacesData> getData(String category) async {
      if(apiUrl == null){
        throw Exception('API_URL is not set');
      }
      final client = http.Client(); 
      final requestUrl = Uri.https(apiUrl!, '$getCatigoryPath/$category');
      print('request: $requestUrl');
      final response = await client.get(requestUrl);
      if( response.statusCode != 200){
        throw Exception('Failed to load data: ${response.statusCode}'); 
      }
      client.close();
      final responseJson = response.body;
      final data = jsonDecode(responseJson);
      return MarketplacesData.fromJson(data[0]);
  }

  Future<List<Category>> getCatigoriesData() async { 
      if(apiUrl == null){
        throw Exception('API_URL is not set');
      }
      final client = http.Client(); 
      final requestUrl = Uri.https(apiUrl!, getCatigoryPath);
      print('requestUrl: $requestUrl');
      final response = await client.get(requestUrl);
      if( response.statusCode != 200){
        throw Exception('Failed to load data: ${response.statusCode}'); 
      }
      client.close();
      final responseJson = response.body;
      final dataJson = jsonDecode(responseJson);
      final data =  dataJson.map<Category>((e) => Category.fromJson(e)).toList();
      return data;
  }

  Future<bool?> getThemeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('ligthTheme');
  }

  Future<void> setThemeData(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ligthTheme', value);
  }