abstract class MainScreenState{
  MainScreenState copyWith(); 
}

class InDataLoad extends MainScreenState {

  @override
  InDataLoad copyWith() {
    return InDataLoad();
  }
}

class BiggestSaleCategorySelected extends MainScreenState {

  @override
  BiggestSaleCategorySelected copyWith() {
    return BiggestSaleCategorySelected();
  }
}

class SmallestPriceCategorySelected extends MainScreenState {

  @override
  SmallestPriceCategorySelected copyWith() {
    return SmallestPriceCategorySelected();
  }
}
