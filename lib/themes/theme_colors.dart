import 'package:flutter/material.dart';
import 'package:markerplace_sales_monitor/themes/app_colors.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.unSelectedWidgetsColor,
    required this.selectedWidgetsColor,
    required this.cardTextColor,
    required this.textColor,
    required this.backgroundClolor,
  });

  final Color unSelectedWidgetsColor;
  final Color selectedWidgetsColor;
  final Color cardTextColor;
  final Color textColor;
  final Color backgroundClolor; 

  @override
  ThemeExtension<ThemeColors> copyWith(
    {
      Color? unSelectedWidgetsColor,
      Color? selectedWidgetsColor,
      Color? cardTextAndBackgroundColor,
      Color? textColor,
      Color? backgroundClolor,
    }
  ) {
    return ThemeColors(
      backgroundClolor: backgroundClolor ?? this.backgroundClolor,
      unSelectedWidgetsColor: unSelectedWidgetsColor ?? this.unSelectedWidgetsColor,
      selectedWidgetsColor: selectedWidgetsColor ?? this.selectedWidgetsColor,
      cardTextColor: cardTextAndBackgroundColor ?? this.cardTextColor,
      textColor: textColor ?? this.cardTextColor,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(covariant ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      backgroundClolor: Color.lerp(backgroundClolor, other.backgroundClolor, t)!,
      unSelectedWidgetsColor: Color.lerp(unSelectedWidgetsColor, other.unSelectedWidgetsColor, t)!,
      selectedWidgetsColor: Color.lerp(selectedWidgetsColor, other.selectedWidgetsColor, t)!,
      cardTextColor: Color.lerp(cardTextColor, other.cardTextColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
    );
  }

  static ThemeColors get ligth => const ThemeColors(
    backgroundClolor: Colors.white,
    unSelectedWidgetsColor: AppColors.lightBrown,
    selectedWidgetsColor: AppColors.brown,
    cardTextColor: AppColors.gainsboro,
    textColor: AppColors.black,
  );

  static ThemeColors get dark => const ThemeColors(
    backgroundClolor: AppColors.black,
    unSelectedWidgetsColor: AppColors.ultraLightBlack,
    selectedWidgetsColor: AppColors.ligthBlack,
    cardTextColor: AppColors.ultraLightBlack,
    textColor: AppColors.white,
  );

}
