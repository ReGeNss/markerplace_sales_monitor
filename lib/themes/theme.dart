import 'package:flutter/material.dart';
import 'package:markerplace_sales_monitor/themes/theme_colors.dart';

ThemeData ligthTheme() { 
  return ThemeData(
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.ligth,
    ],
  );  
}

ThemeData darkTheme() { 
  return ThemeData(
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.dark,
    ],
  );  
}
