import 'package:markerplace_sales_monitor/entities.dart';
import 'package:markerplace_sales_monitor/repositores/data_repository.dart';

class DataService {
  static final dataRepository = DataRepository(); 

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

}
