part of 'page_switcher_bloc.dart';

@immutable
sealed class PageSwitcherEvent {}

final class CatigoriesLoaded extends PageSwitcherEvent {
  CatigoriesLoaded(this.catigories);
  
  final List<Category> catigories;
}

final class CatigoriesLoadingFailed extends PageSwitcherEvent {
  CatigoriesLoadingFailed(this.error);

  final String error;
}

final class PageSwitched extends PageSwitcherEvent {
  PageSwitched(this.pageIndex);

  final int pageIndex;
}
