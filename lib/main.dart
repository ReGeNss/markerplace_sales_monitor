import 'package:flutter/material.dart';
import 'package:markerplace_sales_monitor/repositores/data_handler.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    DataHandler().getSalesData();
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}
