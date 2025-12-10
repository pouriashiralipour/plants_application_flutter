import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/size_config.dart';

class AppTitleBar extends StatelessWidget {
  const AppTitleBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
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
              color: isLightMode ? AppColors.grey900 : AppColors.white,
              fontSize: SizeConfig.getProportionateFontSize(16),
              fontWeight: FontWeight.w800,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'مشاهده همه',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: SizeConfig.getProportionateFontSize(12),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
