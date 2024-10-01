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
  set productLisTestingtSet(List<ProductCard> list){
    _productList.clear();
    _productList.addAll(list);
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
    on<LipsPriceCategoryButtonTapEvent>(_lipsPriceCategoryButtonTapEvent);
    on<FilterButtonTapEvent>(_filterButtonTapEvent);
    on<LoadingDataCompletedEvent>(_loadingDataCompletedEvent);
  }

  void createMarketsList(){
    marketplaceList.forEach((e){
      final name = e.marketplace; 
      marketsList.add(name);
    }); 
  }

  void _createAllMarketsProductsList(){
    _productList.clear(); 
    print('${_productList.length} createAllMarketsProductsList call');
    for(var e in marketplaceList){
      for(var product in e.products){
        _productList.add(product);
      }
    }
  }

  void _selectMarketplace(int? index){
    if( index == null) {_createAllMarketsProductsList(); return;}
    selectedMarketplace = index;
    final selectedMarketplaceName = marketsList[index];
    final selectedMarketplaceData = marketplaceList.firstWhere((element) => element.marketplace == selectedMarketplaceName);
    _productList.clear();
    _productList.addAll(selectedMarketplaceData.products);
  }

  void rebuildProductList(MainScreenState newState){
    switch(newState){
      case BiggestSaleCategorySelected _:
        _selectMarketplace(selectedMarketplace);
        final newList =_biggestSaleCategoryListBuild(_productList).toList();
        _productList.clear();
        _productList.addAll(newList);
        break;
      case SmallestPriceCategorySelected _:
        _selectMarketplace(selectedMarketplace);
        final newList = _smallestPriceFilter(_productList).toList(); 
        _productList.clear();
        _productList.addAll(newList);
        break;
      case LipsPriceCategorySelected _:

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
    // final old = productList.toList(); 
    selectedMarketplace = null;
    _createAllMarketsProductsList();
    rebuildProductList(state); 
    // print(productList == old);
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

  // List<ProductCard> _biggestSaleCategoryListBuild(List <ProductCard> productList){
  //   final productListWithSale = <ProductCard>[];
  //   productList.forEach((e){
  //       // if(e.title == 'Солодка енергія') print(e);
  //       if(e.percentOfSale != null && e.oldPrice != null) productListWithSale.add(e);
  //   });
  //   productListWithSale.sort((a,b) => b.percentOfSale!.compareTo(a.percentOfSale!));
  //   // productListWithSale.forEach((e) => print(e.percentOfSale));
  //   return productListWithSale;
  // }

List<ProductCard> _biggestSaleCategoryListBuild(List<ProductCard> productList) {
  final productListWithSale = productList.where((e) => e.percentOfSale != null).toList();
  productListWithSale.sort((a, b) => b.percentOfSale!.compareTo(a.percentOfSale!));
  return productListWithSale;
}

  void _smallestPriceCategoryButtonTapEvent(SmallestPriceCategoryButtonTapEvent event, Emitter<MainScreenState> emit){
    rebuildProductList(SmallestPriceCategorySelected()); 
    emit(SmallestPriceCategorySelected());
  }

  void _lipsPriceCategoryButtonTapEvent(LipsPriceCategoryButtonTapEvent event, Emitter<MainScreenState> emit){
    emit(state);
  }

  void _filterButtonTapEvent(FilterButtonTapEvent event, Emitter<MainScreenState> emit){
    emit(state);
  }

  void _loadingDataCompletedEvent(LoadingDataCompletedEvent event, Emitter<MainScreenState> emit){
    marketplaceList = event.data;
    createMarketsList();
    // _createAllMarketsProductsList(); 
    add(const BiggestSaleCategoryButtonTapEvent());
    // emit(BiggestSaleCategorySelected());
  }

}