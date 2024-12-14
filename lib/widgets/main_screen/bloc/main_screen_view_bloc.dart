import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markerplace_sales_monitor/repositores/data_handler.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_events.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvents, MainScreenState>{ // null means all marketplaces
  MainScreenBloc() : super(LoadingData()){
    _dataHandler.getSalesData().then((value) => {
      add(LoadingDataCompletedEvent(value)),
    },);
    on<AllCategoryButtonTapEvent>(_onAllCategoryButtonTapEvent);
    on<MarketplaceSelectButtonTapEvent>(_marketplaceSelectButtonTapEvent);  
    on<BiggestSaleCategoryButtonTapEvent>(_biggestSaleCategoryButtonTapEvent);
    on<SmallestPriceCategoryButtonTapEvent>(_smallestPriceCategoryButtonTapEvent); 
    on<FilterButtonTapEvent>(_filterButtonTapEvent);
    on<SearchTextFieldChangedEvent>(_searchTextFieldChangedEvent); 
    on<LoadingDataCompletedEvent>(_loadingDataCompletedEvent);
  }

  static final DataHandler _dataHandler = DataHandler();
  late final MarketplacesData marketplacesData;
  final List<Brand> brands = []; 
  bool isBrandFilersActive = false;
  final _productList = <ProductCard>[]; 
  String _searchQuery = ''; 

  List<ProductCard> get productList  {
    return _productList;
  } 

  final List<String> marketsList = []; 
  int? selectedMarketplace;

  void createMarketsList(){
    marketplacesData.marketplaces.forEach((element) => marketsList.add(element));
  }
  
  void createBrandsList(){
    brands.addAll(marketplacesData.brands);
  }

  void _addDataToProductList(List<ProductCard> products){
    _productList.clear(); 
    _productList.addAll(products);
  }

  void _createAllMarketsProductsList(bool isSelectedBrandsExist){ 
    final List<ProductCard> products = [];
    final brands = marketplacesData.brands;
    if(isSelectedBrandsExist){
      for(final brand in brands){
        if(brand.isSelected){
          brand.products.forEach((product) => products.add(product));
        }
      }
    }
    else{
    for(final brand in brands){
      brand.products.forEach((product) {products.add(product);});
    }}
    _addDataToProductList(products);
  }

  List<ProductCard> _selectMarketplace(int? index){
    bool selectedBrandsExist = false; 
    for(final brand in brands){
      if(brand.isSelected){
        selectedBrandsExist = true; 
        break;
      }
    }
    if( index == null) {
      _createAllMarketsProductsList(selectedBrandsExist); 
      return _productList;
    }
    selectedMarketplace = index;
    final selectedMarketplaceName = marketsList[index];
    final selectedMarketplaceData = <ProductCard>[]; 
    if(selectedBrandsExist){
      for(final brand in brands){
        if(brand.isSelected){
          for(final product in brand.products){
            if(product.marketplace == selectedMarketplaceName){
              selectedMarketplaceData.add(product);
            }
          }
        }
      }
    }
    else{
    for(final e in marketplacesData.brands){
      for(final product in e.products){
        if(product.marketplace == selectedMarketplaceName){
          selectedMarketplaceData.add(product);
        }
      }
    }}
    return selectedMarketplaceData; 
  }

  void rebuildProductList(MainScreenState newState){
    switch(newState){
      case BiggestSaleCategorySelected _:
        final productList= _selectMarketplace(selectedMarketplace);
        final newList =_biggestSaleCategoryListBuild(productList).toList();
        filterListBySearchQuery(productList: newList);
        break;
      case SmallestPriceCategorySelected _:
        final productList= _selectMarketplace(selectedMarketplace);
        final newList = _smallestPriceFilter(productList).toList(); 
        filterListBySearchQuery(productList: newList); 
        break;
    }
  }

  List<ProductCard> _smallestPriceFilter(List<ProductCard> productList) {
    final newList = productList.toSet().toList();
    newList.sort((a, b) => a.getCurrentPriceAsDouble().compareTo(b.getCurrentPriceAsDouble()));
    return newList; 
  }

  int get countOfCategories => marketsList.length;
  int get countOfProducts => _productList.length;

  List<Brand> getBrands(){
    return brands.toList();
  }

  void _searchTextFieldChangedEvent(SearchTextFieldChangedEvent event, Emitter<MainScreenState> emit){
    final searchQuery = event.text;
    _searchQuery = searchQuery; 
    if(event.text.isEmpty){
      rebuildProductList(state);
      emit(state.copyWith());
      return;
    }
    filterListBySearchQuery(searchQuery: searchQuery, productList: _productList);
    emit(state.copyWith());
  }

  void filterListBySearchQuery({String? searchQuery, required List<ProductCard> productList}){
    if(_searchQuery.isEmpty) {
      _addDataToProductList(productList);
      return;
    } 
    final searchQuery = _searchQuery.toLowerCase(); 
    final filteredList = productList.where((element) => element.title.toLowerCase().contains(searchQuery)).toList();
    _addDataToProductList(filteredList);
  }

  void _onAllCategoryButtonTapEvent(AllCategoryButtonTapEvent event, Emitter<MainScreenState> emit){ 
    selectedMarketplace = null;
    final isSelectedBrandsExist = brands.any((element) => element.isSelected);
    _createAllMarketsProductsList(isSelectedBrandsExist);
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
    rebuildProductList(state);
    if(brands.any((element) => element.isSelected)){
      isBrandFilersActive = true;
    }else {
      isBrandFilersActive = false;
    }
    emit(state.copyWith());
  }

  void _loadingDataCompletedEvent(LoadingDataCompletedEvent event, Emitter<MainScreenState> emit){
    marketplacesData = event.data;
    createMarketsList();
    createBrandsList();
    // _createAllMarketsProductsList(); 
    add(const BiggestSaleCategoryButtonTapEvent());
    // emit(BiggestSaleCategorySelected());
  }

}
