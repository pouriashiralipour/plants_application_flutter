import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;
  static late double textScale;

  // دیوایس مرجع (iPhone X)
  static const double designWidth = 375.0;
  static const double designHeight = 812.0;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    textScale = _mediaQueryData.textScaleFactor;
  }

  static double getProportionateScreenHeight(double inputHeight) {
    return (inputHeight / designHeight) * screenHeight;
  }

  static double getProportionateScreenWidth(double inputWidth) {
    return (inputWidth / designWidth) * screenWidth;
  }

  static double getProportionateFontSize(double inputFontSize) {
    return (inputFontSize / designWidth) * screenWidth / textScale;
  }

  static double responsiveWidth(double inputWidth, {double max = 600}) {
    double calculated = getProportionateScreenWidth(inputWidth);
    return calculated > max ? max : calculated;
  }

  static double responsiveHeight(double inputHeight, {double max = 1000}) {
    double calculated = getProportionateScreenHeight(inputHeight);
    return calculated > max ? max : calculated;
  }
}
