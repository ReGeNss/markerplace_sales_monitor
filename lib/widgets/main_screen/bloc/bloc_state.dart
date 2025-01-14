abstract class MainScreenState{
  MainScreenState copyWith(); 
}

class InDataLoad extends MainScreenState {

  @override
  InDataLoad copyWith() {
    return InDataLoad();
  }
}

class LoadingDataExeption extends MainScreenState {
  LoadingDataExeption({this.message = 'Something went wrong'});

  final String message;

  @override
  LoadingDataExeption copyWith() {
    return LoadingDataExeption(message: message);
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
