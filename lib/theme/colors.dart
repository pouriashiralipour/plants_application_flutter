import 'package:flutter/material.dart';

class AppColors {
  // Main
  static const Color primary = Color(0xFF01B763);
  static const Color secondary = Color(0xFF797979);

  // Alert & Status
  static const Color info = Color(0xFF01B763);
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFF75555);
  static const Color disabled = Color(0xFFD8D8D8);
  static const Color disabledButton = Color(0xFF109C5B);

  // Greyscale
  static const Color grey900 = Color(0xFF212121);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey50 = Color(0xFFFAFAFA);

  // Dark Colors
  static const Color dark1 = Color(0xFF181A20);
  static const Color dark2 = Color(0xFF1F222A);
  static const Color dark3 = Color(0xFF35383F);

  // Others
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFF44336);
  static const Color pink = Color(0xFFE91E63);
  static const Color purple = Color(0xFF9C27B0);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color blue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF03A9F4);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color teal = Color(0xFF009688);
  static const Color green = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color lime = Color(0xFFCDDC39);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color amber = Color(0xFFFFC107);
  static const Color orange = Color(0xFFFF9800);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color brown = Color(0xFF795548);
  static const Color blueGrey = Color(0xFF607D8B);

  // Background
  static const Color bgSilver1 = Color(0xFFF8F8F8);
  static const Color bgSilver2 = Color(0xFFF3F3F3);
  static const Color bgGreen = Color(0xFFF2FFF6);
  static const Color bgPurple = Color(0xFFF4ECFF);
  static const Color bgBlue = Color(0xFFF1FAFD);
  static const Color bgOrange = Color(0xFFFFF8ED);
  static const Color bgYellow = Color(0xFFFFFEE0);

  // Transparent
  static const Color transparentGreen = Color(0xFF01B763);
  static const Color transparentSilver = Color(0xFF101010);
  static const Color transparentPurple = Color(0xFF720CFF);
  static const Color transparentBlue = Color(0xFF335FF7);
  static const Color transparentOrange = Color(0xFFFF9800);
  static const Color transparentYellow = Color(0xFFFACC15);
  static const Color transparentRed = Color(0xFFF75555);
  static const Color transparentCyan = Color(0xFF00BCD4);

  // Gradianet
  static const LinearGradient gradientGreen = LinearGradient(
    colors: [AppColors.primary, Color(0xFF14E585)],
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
  );
}
