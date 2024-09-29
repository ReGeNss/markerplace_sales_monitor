abstract class MainScreenState{
  MainScreenState copyWith(); 
}

class LoadingData extends MainScreenState {
  LoadingData copyWith() {
    return LoadingData();
  }
}

class BiggestSaleCategorySelected extends MainScreenState {
  BiggestSaleCategorySelected copyWith() {
    return BiggestSaleCategorySelected();
  }
}

class SmallestPriceCategorySelected extends MainScreenState {

  SmallestPriceCategorySelected copyWith() {
    return SmallestPriceCategorySelected();
  }
}

class LipsPriceCategorySelected extends MainScreenState {

  LipsPriceCategorySelected copyWith() {
    return LipsPriceCategorySelected();
  }}