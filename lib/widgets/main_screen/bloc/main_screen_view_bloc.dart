import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markerplace_sales_monitor/entities.dart';
import 'package:markerplace_sales_monitor/services/data_service.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_events.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvents, MainScreenState>{ // null means all marketplaces
  MainScreenBloc() : super(InDataLoad()){
    _dataService.getSalesData().then((data) => {
      add(LoadingDataCompletedEvent(data)),
    },);

    on<AllCategoryButtonTapEvent>(_onAllCategoryButtonTapEvent);
    on<MarketplaceSelectButtonTapEvent>(_onMarketplaceSelectButtonTapEvent);  
    on<BiggestSaleCategoryButtonTapEvent>(_onBiggestSaleCategoryButtonTapEvent);
    on<SmallestPriceCategoryButtonTapEvent>(_onSmallestPriceCategoryButtonTapEvent); 
    on<FilterButtonTapEvent>(_onFilterButtonTapEvent);
    on<SearchTextFieldChangedEvent>(_onSearchTextFieldChangedEvent); 
    on<LoadingDataCompletedEvent>(_onLoadingDataCompletedEvent);
  }

  static final DataService _dataService = DataService();
  late final MarketplacesData marketplacesData;
  final List<Brand> brands = []; 
  final _productList = <ProductCard>[]; 
  bool isBrandFilersActive = false;
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

  List<ProductCard> _createAllMarketsProductsList(bool isSelectedBrandsExist){ 
    final List<ProductCard> products = [];
    final brands = marketplacesData.brands;
    if(isSelectedBrandsExist){
      for(final brand in brands){
        if(brand.isSelected){
          brand.products.forEach((product) => products.add(product));
        }
      }
    }
    else {
      for(final brand in brands){
        brand.products.forEach((product) =>  products.add(product));
      }
    }
    return products;
  }

  List<ProductCard> _getSelectedMarketplaceProducts(int? index){
    bool isSelectedBrandsExist = false; 
    for(final brand in brands){
      if(brand.isSelected){
        isSelectedBrandsExist = true; 
        break;
      }
    }
    if(index == null) {
      final products =  _createAllMarketsProductsList(isSelectedBrandsExist);
      return products;
    }
    selectedMarketplace = index;
    final selectedMarketplaceName = marketsList[index];
    final selectedMarketplaceData = <ProductCard>[]; 
    if(isSelectedBrandsExist){
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
    late final List<ProductCard> rebuildProductList;
    if (newState is BiggestSaleCategorySelected) {
      final selectedProducts = _getSelectedMarketplaceProducts(selectedMarketplace);
      final sortedProducts =_biggestSaleCategoryListBuild(selectedProducts).toList();
      rebuildProductList = _filterListBySearchQuery(productList: sortedProducts);
    }else if (newState is SmallestPriceCategorySelected) {
      final selectedProducts = _getSelectedMarketplaceProducts(selectedMarketplace);
      final sortedProducts = _smallestPriceFilter(selectedProducts).toList(); 
      rebuildProductList = _filterListBySearchQuery(productList: sortedProducts);
    }
    _addDataToProductList(rebuildProductList);
  }

  List<ProductCard> _smallestPriceFilter(List<ProductCard> productList) {
    final sortedProudcts = productList.toSet().toList();
    sortedProudcts.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
    return sortedProudcts; 
  }

  int get countOfCategories => marketsList.length;
  int get countOfProducts => _productList.length;

  List<Brand> getBrands(){
    return brands.toList();
  }

  void _onSearchTextFieldChangedEvent(SearchTextFieldChangedEvent event, Emitter<MainScreenState> emit){
    final searchQuery = event.text;
    _searchQuery = searchQuery; 
    if(event.text.isEmpty){
      rebuildProductList(state);
      emit(state.copyWith());
      return;
    }
    final filteredList = _filterListBySearchQuery(searchQuery: searchQuery, productList: _productList);
    _addDataToProductList(filteredList);
    emit(state.copyWith());
  }

  List<ProductCard> _filterListBySearchQuery({String? searchQuery, required List<ProductCard> productList}){
    if(_searchQuery.isEmpty) {
      return productList; 
    } 
    final searchQuery = _searchQuery.toLowerCase(); 
    final filteredList = productList.where((element) => element.title.toLowerCase().contains(searchQuery)).toList();
    return filteredList;
  }

  void _onAllCategoryButtonTapEvent(AllCategoryButtonTapEvent event, Emitter<MainScreenState> emit){ 
    selectedMarketplace = null;
    final isSelectedBrandsExist = brands.any((element) => element.isSelected);
    final allProducts = _createAllMarketsProductsList(isSelectedBrandsExist);
    _addDataToProductList(allProducts); 
    rebuildProductList(state); 
    emit(state.copyWith());
  }

  void _onMarketplaceSelectButtonTapEvent(MarketplaceSelectButtonTapEvent event, Emitter<MainScreenState> emit){
    selectedMarketplace = event.marketplaceId;
    rebuildProductList(state);
    emit(state.copyWith());
  }

  void _onBiggestSaleCategoryButtonTapEvent(BiggestSaleCategoryButtonTapEvent event, Emitter<MainScreenState> emit){
    rebuildProductList(BiggestSaleCategorySelected());
    emit(BiggestSaleCategorySelected());
  }

  List<ProductCard> _biggestSaleCategoryListBuild(List<ProductCard> productList) {
    final productListWithSale = productList.where((e) => e.percentOfSale != null).toList();
    productListWithSale.sort((a, b) => b.percentOfSale!.compareTo(a.percentOfSale!));
    return productListWithSale;
  }

  void _onSmallestPriceCategoryButtonTapEvent(SmallestPriceCategoryButtonTapEvent event, Emitter<MainScreenState> emit){
    rebuildProductList(SmallestPriceCategorySelected()); 
    emit(SmallestPriceCategorySelected());
  }

  void _onFilterButtonTapEvent(FilterButtonTapEvent event, Emitter<MainScreenState> emit){
    rebuildProductList(state);
    if(brands.any((element) => element.isSelected)){
      isBrandFilersActive = true;
    }else {
      isBrandFilersActive = false;
    }
    emit(state.copyWith());
  }

  void _onLoadingDataCompletedEvent(LoadingDataCompletedEvent event, Emitter<MainScreenState> emit){
    marketplacesData = event.data;
    createMarketsList();
    createBrandsList();
    add(const BiggestSaleCategoryButtonTapEvent());
  }

}
