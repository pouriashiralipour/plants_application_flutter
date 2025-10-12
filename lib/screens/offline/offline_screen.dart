import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/components/widgets/cutsom_button.dart';

import '../../components/adaptive_gap.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';

class OfflineScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(24)),
                SvgPicture.asset(
                  'assets/images/offline_internet.svg',
                  width: SizeConfig.getProportionateScreenWidth(300),
                  height: SizeConfig.getProportionateScreenWidth(300),
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(24)),
                Text(
                  'اتصال اینترنت برقرار نیست',
                  style: TextStyle(
                    fontFamily: 'Peyda',
                    fontSize: SizeConfig.getProportionateFontSize(28),
                    fontWeight: FontWeight.w700,
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(24)),
                Text(
                  'لطفاً اتصال اینترنت خود را بررسی کنید و مجدداً تلاش نمایید',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(14),
                    color: isLightMode ? AppColors.grey600 : AppColors.grey400,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(32)),
                CustomButton(
                  onTap: onRetry,
                  text: 'امتحان مجدد',
                  color: AppColors.disabledButton,
                  width: SizeConfig.designWidth,
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
