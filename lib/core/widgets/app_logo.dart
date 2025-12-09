import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../utils/size.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.iconSize = 60, this.textSize = 48});

  final double iconSize;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/Logo.svg',
          height: SizeConfig.getProportionateScreenWidth(iconSize),
          width: SizeConfig.getProportionateScreenWidth(iconSize),
        ),
        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
        Text(
          'فیلوروپیا',
          style: TextStyle(
            fontFamily: 'Peyda',
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.w900,
            fontSize: SizeConfig.getProportionateFontSize(textSize),
          ),
        ),
      ],
    );
  }
}
