import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_button.dart';

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
                Gap(SizeConfig.getProportionateScreenHeight(24)),
                SvgPicture.asset(
                  'assets/images/offline_internet.svg',
                  width: SizeConfig.getProportionateScreenWidth(300),
                  height: SizeConfig.getProportionateScreenWidth(300),
                ),
                Gap(SizeConfig.getProportionateScreenHeight(24)),
                Text(
                  'اتصال اینترنت برقرار نیست',
                  style: TextStyle(
                    fontFamily: 'Peyda',
                    fontSize: SizeConfig.getProportionateFontSize(28),
                    fontWeight: FontWeight.w700,
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                ),
                Gap(SizeConfig.getProportionateScreenHeight(24)),
                Text(
                  'لطفاً اتصال اینترنت خود را بررسی کنید و مجدداً تلاش نمایید',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(14),
                    color: isLightMode ? AppColors.grey600 : AppColors.grey400,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(32)),
                AppButton(
                  onTap: onRetry,
                  text: 'امتحان مجدد',
                  color: AppColors.disabledButton,
                  width: SizeConfig.designWidth,
                ),
                Gap(SizeConfig.getProportionateScreenHeight(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
