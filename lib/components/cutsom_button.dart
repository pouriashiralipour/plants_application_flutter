import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.text, required this.color});

  final VoidCallback onTap;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.getProportionateScreenHeight(58),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 8),
              blurRadius: 24,
              spreadRadius: 0,
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.white,
            fontSize: SizeConfig.getProportionateScreenWidth(18),
            fontFamily: 'IranYekan',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
