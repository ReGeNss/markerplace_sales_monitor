import 'package:markerplace_sales_monitor/repositores/data_handler.dart';

abstract class MainScreenEvents{ 
  const MainScreenEvents(); 
} 

class MarketplaceSelectButtonTapEvent extends MainScreenEvents{ 
  final int marketplaceId;
  const MarketplaceSelectButtonTapEvent(this.marketplaceId); 
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
  final String text; 
  const SearchTextFieldChangedEvent(this.text); 
}

class LoadingDataCompletedEvent extends MainScreenEvents{ 
  final MarketplacesData data; 
  const LoadingDataCompletedEvent(this.data); 
}

