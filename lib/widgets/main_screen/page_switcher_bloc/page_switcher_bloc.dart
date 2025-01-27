import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:markerplace_sales_monitor/entities.dart';
import 'package:markerplace_sales_monitor/services/data_service.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/category_bloc/category_events.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/category_bloc/category_view_bloc.dart';

part 'page_switcher_event.dart';
part 'page_switcher_state.dart';

const delayTime = Duration(seconds: 10);

class PageSwitcherBloc extends Bloc<PageSwitcherEvent, PageSwitcherState> {
  PageSwitcherBloc() : super(CatigoriesLoading()) {
    loadCatigoriesData();

    on<PageSwitched>((event, emit) => _onPageSwitched(event, emit));
    on<CatigoriesLoaded>((event, emit) => _onCatigoriesLoaded(event, emit));
    on<CatigoriesLoadingFailed>((event, emit) => _onCatigoriesLoadFailed(event, emit));
  }

  final DataService _dataService = DataService();
  final List<Category> catigories = [];
  int currentCatigoryIndex = 0;
  final controller = PageController();
  final List<MainScreenBloc> mainScreenBlocs = [];

  Future<void> loadCatigoriesData() async {
    try {
      final catigoriesData = await _dataService.getCatigoriesData();
      add(CatigoriesLoaded(catigoriesData));
    } on SocketException {
      add(CatigoriesLoadingFailed('Error: '));
    } catch(e) {
      add(CatigoriesLoadingFailed('Something went wrong. Error: $e'));
    }
  }

  void loadBlocs() { 
    mainScreenBlocs.clear();
    catigories.forEach((category) => mainScreenBlocs.add(MainScreenBloc(category.apiRoute)));
  } 

  void setupPageController() {
    controller.addListener(() {
      final currentPage = controller.page!.round();
      if (currentPage != currentCatigoryIndex) {
        currentCatigoryIndex = currentPage;
      }
      add(PageSwitched(currentPage));
    });
    
  }

  void _onPageSwitched(PageSwitched event, Emitter<PageSwitcherState> emit) {
    final isDataLoaded = mainScreenBlocs[event.pageIndex].isDataLoaded;
    final isDataLoading = mainScreenBlocs[event.pageIndex].loading; 
    if(isDataLoaded || isDataLoading) {
      emit(CatigoriesHandled(event.pageIndex));
      return;
    }else{
      mainScreenBlocs[event.pageIndex].add(const LoadingDataStarted());
    }
    emit(CatigoriesHandled(event.pageIndex));
  }

  void _onCatigoriesLoaded(CatigoriesLoaded event, Emitter<PageSwitcherState> emit) {
    catigories.addAll(event.catigories);
    setupPageController();
    loadBlocs();
    mainScreenBlocs[currentCatigoryIndex].add(const LoadingDataStarted());
    emit(CatigoriesHandled(currentCatigoryIndex));
  }

  void _onCatigoriesLoadFailed(CatigoriesLoadingFailed event, Emitter<PageSwitcherState> emit) {
    Future.delayed(delayTime, () => loadCatigoriesData());
    emit(Error(event.error));
  }

}
