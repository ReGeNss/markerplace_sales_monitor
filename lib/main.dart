import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:markerplace_sales_monitor/main_app.dart';

void main() async {
  await dotenv.load();
  runApp(const MainApp());
}
