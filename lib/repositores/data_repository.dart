import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:markerplace_sales_monitor/entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DataRepositoryRequests {
  getMarketplacesData,
  getCatigories,
  getTheme,
  setTheme,
}

abstract class IDataRepository {
  Future<MarketplacesData> getData(String category);
  Future<List<Category>> getCatigoriesData();
  Future<bool?> getThemeData();
  Future<void> setThemeData(bool value);
}

class DataRepository implements IDataRepository { 
  DataRepository(this.apiUrl);

  final String apiUrl; 
  final getCatigoryPath = 'categories';

  @override
  Future<MarketplacesData> getData(String category) async {
    final client = http.Client();
    final requestUrl = Uri.https(apiUrl, '$getCatigoryPath/$category');
    final response = await client.get(requestUrl);
    if (response.statusCode != 200) {
      client.close();
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    client.close();
    final responseJson = response.body;
    final data = jsonDecode(responseJson);
    return MarketplacesData.fromJson(data[0]);
  }

  @override
  Future<List<Category>> getCatigoriesData() async {
    final client = http.Client();
    final requestUrl = Uri.https(apiUrl, getCatigoryPath);
    final response = await client.get(requestUrl);
    if (response.statusCode != 200) {
      client.close();
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    client.close();
    final responseJson = response.body;
    final dataJson = jsonDecode(responseJson);
    final data = dataJson.map<Category>((e) => Category.fromJson(e)).toList();
    return data;
  }

  @override
  Future<bool?> getThemeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('ligthTheme');
  }

  @override
  Future<void> setThemeData(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ligthTheme', value);
  }
}
