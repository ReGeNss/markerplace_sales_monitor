import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markerplace_sales_monitor/themes/theme.dart';
import 'package:markerplace_sales_monitor/themes/theme_colors.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/main_screen.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/theme_bloc/theme_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: Builder(
        builder: (context) {
          final themeBloc = context.watch<ThemeBloc>();
          if(themeBloc.state is LoadingTheme) {
            return const Center(child: CircularProgressIndicator());
          } 
          return MaterialApp(
            home: const MainScreen(),
            theme: ligthTheme(),
            darkTheme: darkTheme(),
            themeMode: themeBloc.getTheme(),
          );
        },
      ),
    );
  }
}

extension BuildContextExt on BuildContext {
  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;
}
