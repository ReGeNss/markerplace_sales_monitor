import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:markerplace_sales_monitor/main_app.dart';
import 'package:markerplace_sales_monitor/repositores/data_repository_worker.dart';

void main() async {
  await dotenv.load();
  await ProxyDataRepository().ready; 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}
