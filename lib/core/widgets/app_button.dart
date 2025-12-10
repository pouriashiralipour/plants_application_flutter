import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/core/widgets/gap.dart';

import '../theme/app_colors.dart';
import '../utils/size_config.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.width,
    this.textColor = AppColors.white,
    this.isShadow = true,
    this.is_icon = false,
    required this.fontSize,
  });

  final VoidCallback onTap;
  final String text;
  final Color color;
  final double width;
  final Color? textColor;
  final bool? isShadow;
  final bool? is_icon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: SizeConfig.getProportionateScreenHeight(58),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            if (isShadow == true)
              BoxShadow(
                offset: Offset(4, 8),
                blurRadius: 24,
                spreadRadius: 0,
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: SizeConfig.getProportionateFontSize(fontSize),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
            is_icon!
                ? SvgPicture.asset(
                    'assets/images/icons/Bag_fill.svg',
                    color: AppColors.white,
                    width: SizeConfig.getProportionateScreenWidth(20),
                    height: SizeConfig.getProportionateScreenWidth(20),
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }
}
