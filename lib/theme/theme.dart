import 'package:flutter/material.dart';
import './colors.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'IranBakh',
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'IranBakh',
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.dark1,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.dark2,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
  );
}
