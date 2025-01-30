import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:markerplace_sales_monitor/services/data_service.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(
    LoadingTheme(),
  ) {
    loadTheme();

    on<ThemeChanged>((event, emit) {
      if(event.themeMode != null){
        emit( event.themeMode == ThemeMode.light ? LightTheme() : DarkTheme());
      } else{
        emit(state is LightTheme ? DarkTheme() : LightTheme());
        _dataService.setThemeData(state is LightTheme); 
      }
    });
  }

  final _dataService = DataService(); 

  Future<void> loadTheme() async { 
    final isLightTheme = await _dataService.getThemeData();
    if( isLightTheme == null){
      add(ThemeChanged(ThemeMode.light));
    } else if(isLightTheme){
      add(ThemeChanged(ThemeMode.light));
    } else{
      add(ThemeChanged(ThemeMode.dark));
    }
  }

  ThemeMode getTheme() {
      return state is LightTheme ? ThemeMode.light : ThemeMode.dark;
  }

  void changeTheme() { 
    add(ThemeChanged(null));
  }
}
