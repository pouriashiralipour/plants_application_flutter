import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/colors.dart';
import '../../utils/size.dart';

class CustomLogoWidget extends StatelessWidget {
  const CustomLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/Logo.svg',
          height: SizeConfig.getProportionateScreenWidth(60),
          width: SizeConfig.getProportionateScreenWidth(60),
        ),
        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
        Text(
          'فیلوروپیا',
          style: TextStyle(
            fontFamily: 'Peyda',
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.w900,
            fontSize: SizeConfig.getProportionateFontSize(48),
          ),
        ),
      ],
    );
  }
}
