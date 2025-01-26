part of 'page_switcher_bloc.dart';

@immutable
sealed class PageSwitcherState {}

final class PageSwitcherInitial extends PageSwitcherState {}

final class CatigoriesLoading extends PageSwitcherState {}

final class CatigoriesHandled extends PageSwitcherState {
  CatigoriesHandled(this.currentPage);

  final int currentPage;
}

final class Error extends PageSwitcherState {
  Error(this.error);

  final String error;
}
