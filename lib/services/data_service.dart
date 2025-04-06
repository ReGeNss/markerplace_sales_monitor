import 'package:markerplace_sales_monitor/entities.dart';
import 'package:markerplace_sales_monitor/repositores/data_repository_worker.dart';

class DataService {
  static final dataRepository = ProxyDataRepository(); 

  Future<FormatedMarketplacesData> getSalesData(String category) async{ 
    final data = await dataRepository.getData(category);
    final brandsNames = data.brands.keys.toList();
    final products = data.brands.values.toList();
    final brands = <Brand>[];
    for( int i = 0; i < brandsNames.length; i++){
      brands.add(Brand(brandsNames[i], products[i], false));
    }
    return FormatedMarketplacesData(data.marketplaces, brands);
  }

  Future<List<Category>> getCatigoriesData() async{
    return await dataRepository.getCatigoriesData();
  }

  Future<bool?> getThemeData() async {
    return await dataRepository.getThemeData();
  }

  Future<void> setThemeData(bool value) async {
    await dataRepository.setThemeData(value);
  }
}
