import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class CustomTitleBarOfProducts extends StatelessWidget {
  const CustomTitleBarOfProducts({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(24),
      ),
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.grey900,
              fontSize: SizeConfig.getProportionateScreenWidth(20),
              fontWeight: FontWeight.w800,
              fontFamily: 'IranYekan',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'مشاهده همه',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: SizeConfig.getProportionateScreenWidth(16),
                fontWeight: FontWeight.w700,
                fontFamily: 'IranYekan',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
