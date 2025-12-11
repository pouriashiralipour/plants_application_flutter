import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({required this.icon, required this.onTap, required this.isLightMode});

  final IconData icon;
  final VoidCallback onTap;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: SizeConfig.getProportionateScreenWidth(28),
        height: SizeConfig.getProportionateScreenHeight(28),
        decoration: BoxDecoration(
          color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(icon, size: 18, color: isLightMode ? AppColors.primary : AppColors.white),
      ),
    );
  }
}
