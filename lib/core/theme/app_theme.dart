import 'package:flightbooking/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor:AppColors.scaffoldBg,),
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    textTheme: TextTheme(),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
    )
  );
}