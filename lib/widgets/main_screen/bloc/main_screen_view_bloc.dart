import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markerplace_sales_monitor/repositores/data_handler.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_events.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvents, MainScreenState>{
  static final DataHandler _dataHandler = DataHandler();
  late final List<MarketplaceData> marketplaceList;
  final _productList = <ProductCard>[]; 
  get productList  {
    return _productList;
  } 

  final List<String> marketsList = []; 
  int? selectedMarketplace; // null means all marketplaces

  MainScreenBloc() : super(LoadingData()){
    _dataHandler.getSalesData().then((value) => {
      add(LoadingDataCompletedEvent(value))
    });
    on<AllCategoryButtonTapEvent>(_onAllCategoryButtonTapEvent);
    on<MarketplaceSelectButtonTapEvent>(_marketplaceSelectButtonTapEvent);  
    on<BiggestSaleCategoryButtonTapEvent>(_biggestSaleCategoryButtonTapEvent);
    on<SmallestPriceCategoryButtonTapEvent>(_smallestPriceCategoryButtonTapEvent); 
    on<FilterButtonTapEvent>(_filterButtonTapEvent);
    on<LoadingDataCompletedEvent>(_loadingDataCompletedEvent);
  }

  void createMarketsList(){
    marketplaceList.forEach((e){
      final name = e.marketplace; 
      marketsList.add(name);
    }); 
  }

  void _addDataToProductList(List<ProductCard> products){
    _productList.clear(); 
    _productList.addAll(products);
  }

  void _createAllMarketsProductsList(){ 
    List<ProductCard> products = [];
    for(var e in marketplaceList){
      for(var product in e.products){
        products.add(product);
      }
    }
    _addDataToProductList(products);
  }

  void _selectMarketplace(int? index){
    if( index == null) {_createAllMarketsProductsList(); return;}
    selectedMarketplace = index;
    final selectedMarketplaceName = marketsList[index];
    final selectedMarketplaceData = marketplaceList.firstWhere((element) => element.marketplace == selectedMarketplaceName);
    _addDataToProductList(selectedMarketplaceData.products);
  }

  void rebuildProductList(MainScreenState newState){
    switch(newState){
      case BiggestSaleCategorySelected _:
        _selectMarketplace(selectedMarketplace);
        final newList =_biggestSaleCategoryListBuild(_productList).toList();
        _addDataToProductList(newList); 
        break;
      case SmallestPriceCategorySelected _:
        _selectMarketplace(selectedMarketplace);
        final newList = _smallestPriceFilter(_productList).toList(); 
        _addDataToProductList(newList); 
        break;
    }
  }

  List<ProductCard> _smallestPriceFilter(List<ProductCard> productList) {
  final newList = productList.toSet().toList();
  newList.sort((a, b) => a.getCurrentPriceAsDouble().compareTo(b.getCurrentPriceAsDouble()));
  return newList;
}

  get countOfCategories => marketsList.length;
  get countOfProducts => _productList.length;

  String? getCurrentMarketplace(String title) {
    if (selectedMarketplace != null) {
      return null;
    } else {
      for (var element in marketplaceList) {
        final marketplace = element.marketplace;
        for (var e in element.products) {
          if (e.title == title) {
            return marketplace;
          }
        }
      }
    }
    return null;
  }

  void _onAllCategoryButtonTapEvent(AllCategoryButtonTapEvent event, Emitter<MainScreenState> emit){ 
    selectedMarketplace = null;
    _createAllMarketsProductsList();
    rebuildProductList(state); 
    emit(state.copyWith());
  }

  void _marketplaceSelectButtonTapEvent(MarketplaceSelectButtonTapEvent event, Emitter<MainScreenState> emit){
    _selectMarketplace(event.marketplaceId);
    rebuildProductList(state);
    emit(state.copyWith());
  }

  void _biggestSaleCategoryButtonTapEvent(BiggestSaleCategoryButtonTapEvent event, Emitter<MainScreenState> emit){
    rebuildProductList(BiggestSaleCategorySelected()); 
    emit(BiggestSaleCategorySelected());
  }

  List<ProductCard> _biggestSaleCategoryListBuild(List<ProductCard> productList) {
    final productListWithSale = productList.where((e) => e.percentOfSale != null).toList();
    productListWithSale.sort((a, b) => b.percentOfSale!.compareTo(a.percentOfSale!));
    return productListWithSale;
  }

  void _smallestPriceCategoryButtonTapEvent(SmallestPriceCategoryButtonTapEvent event, Emitter<MainScreenState> emit){
    rebuildProductList(SmallestPriceCategorySelected()); 
    emit(SmallestPriceCategorySelected());
  }


  void _filterButtonTapEvent(FilterButtonTapEvent event, Emitter<MainScreenState> emit){
    // emit(state);
  }

  void _loadingDataCompletedEvent(LoadingDataCompletedEvent event, Emitter<MainScreenState> emit){
    marketplaceList = event.data;
    createMarketsList();
    // _createAllMarketsProductsList(); 
    add(const BiggestSaleCategoryButtonTapEvent());
    // emit(BiggestSaleCategorySelected());
  }

}