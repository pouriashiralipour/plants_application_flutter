import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/gap.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({required this.totalPrice, required this.isLightMode});

  final int totalPrice;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(24),
        vertical: SizeConfig.getProportionateScreenHeight(12),
      ),
      decoration: BoxDecoration(
        color: isLightMode ? AppColors.white : AppColors.dark2,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قیمت کل',
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateFontSize(12),
                      color: isLightMode ? AppColors.grey600 : AppColors.grey300,
                    ),
                  ),
                  Gap(SizeConfig.getProportionateScreenHeight(4)),
                  Text(
                    '${totalPrice.toString().priceFormatter} ریال'.farsiNumber,
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateFontSize(16),
                      fontWeight: FontWeight.w700,
                      color: isLightMode ? AppColors.grey900 : AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: SizeConfig.getProportionateScreenWidth(160),
              child: AppButton(
                width: 50,
                onTap: () {},
                text: 'تسویه حساب',
                color: AppColors.primary,
                is_icon: true,
                fontSize: SizeConfig.getProportionateFontSize(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
