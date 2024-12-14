abstract class MainScreenState{
  MainScreenState copyWith(); 
}

class LoadingData extends MainScreenState {
  @override
  LoadingData copyWith() {
    return LoadingData();
  }
}

class BiggestSaleCategorySelected extends MainScreenState {

  @override
  BiggestSaleCategorySelected copyWith() {
    return BiggestSaleCategorySelected();
  }
}

class SmallestPriceCategorySelected extends MainScreenState {

  SmallestPriceCategorySelected();
  @override
  SmallestPriceCategorySelected copyWith() {
    return SmallestPriceCategorySelected();
  }
}

class LipsPriceCategorySelected extends MainScreenState {

  @override
  LipsPriceCategorySelected copyWith() {
    return LipsPriceCategorySelected();
  }}
