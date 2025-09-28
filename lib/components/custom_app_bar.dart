import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(52),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/Ellipse.png',
                  width: SizeConfig.getProportionateScreenWidth(48) * 2,
                  height: SizeConfig.getProportionateScreenWidth(48) * 2,
                  fit: BoxFit.contain,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'صبح بخیر 👋',
                    style: TextStyle(
                      color: isLightMode ? AppColors.grey600 : AppColors.grey300,
                      fontSize: SizeConfig.getProportionateScreenWidth(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'پوریا شیرالی پور',
                    style: TextStyle(
                      color: isLightMode ? AppColors.grey800 : AppColors.white,
                      fontSize: SizeConfig.getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/icons/Notification.svg',
                height: SizeConfig.getProportionateScreenWidth(24),
                width: SizeConfig.getProportionateScreenWidth(24),
                color: isLightMode ? AppColors.grey900 : AppColors.white,
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(16)),
              SvgPicture.asset(
                'assets/images/icons/Heart.svg',
                height: SizeConfig.getProportionateScreenWidth(24),
                width: SizeConfig.getProportionateScreenWidth(24),
                color: isLightMode ? AppColors.grey900 : AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
