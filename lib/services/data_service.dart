import 'package:markerplace_sales_monitor/entities.dart';
import 'package:markerplace_sales_monitor/repositores/data_repository.dart';

class DataService {
  static final dataRepository = DataRepository(); 

  Future<MarketplacesData> getSalesData() async{ 
    return await dataRepository.getData();
  }
}
