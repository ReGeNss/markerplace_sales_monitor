import 'package:markerplace_sales_monitor/entities.dart';

abstract class MainScreenEvents{ 
  const MainScreenEvents(); 
} 

class MarketplaceSelectButtonTapEvent extends MainScreenEvents{
  const MarketplaceSelectButtonTapEvent(this.marketplaceId); 

  final int marketplaceId; 
}
class AllCategoryButtonTapEvent extends MainScreenEvents{ 

  const AllCategoryButtonTapEvent(); 
}

class BiggestSaleCategoryButtonTapEvent extends MainScreenEvents{ 

  const BiggestSaleCategoryButtonTapEvent(); 
}

class SmallestPriceCategoryButtonTapEvent extends MainScreenEvents{ 

  const SmallestPriceCategoryButtonTapEvent(); 
}

class LipsPriceCategoryButtonTapEvent extends MainScreenEvents{ 

  const LipsPriceCategoryButtonTapEvent(); 
}

class FilterButtonTapEvent extends MainScreenEvents{ 

  const FilterButtonTapEvent(); 
}

class SearchTextFieldChangedEvent extends MainScreenEvents{ 
  const SearchTextFieldChangedEvent(this.text);

  final String text; 
}

class LoadingDataCompletedEvent extends MainScreenEvents{ 
  const LoadingDataCompletedEvent(this.data); 
  
  final FormatedMarketplacesData data; 
}

class LoadingDataFailed extends MainScreenEvents{ 
  const LoadingDataFailed(this.error); 

  final String error; 
}

class LoadingDataStarted extends MainScreenEvents{ 
  const LoadingDataStarted(); 
}
