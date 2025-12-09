import 'package:flutter/material.dart';

import '../../core/utils/size.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.width,
    this.textColor = AppColors.white,
    this.isShadow = true,
  });

  final VoidCallback onTap;
  final String text;
  final Color color;
  final double width;
  final Color? textColor;
  final bool? isShadow;

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
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: SizeConfig.getProportionateFontSize(18),
            fontFamily: 'Peyda',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
