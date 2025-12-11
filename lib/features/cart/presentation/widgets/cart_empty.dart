import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/gap.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
              child: Column(
                children: [
                  Gap(SizeConfig.getProportionateScreenHeight(15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/Logo.svg',
                            width: SizeConfig.getProportionateScreenWidth(28),
                            height: SizeConfig.getProportionateScreenWidth(28),
                          ),
                          SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                          Text(
                            'سبد خرید',
                            style: TextStyle(
                              fontSize: SizeConfig.getProportionateFontSize(24),
                              fontWeight: FontWeight.w800,
                              color: isLightMode ? AppColors.grey900 : AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/icons/Search.svg',
                        width: SizeConfig.getProportionateScreenWidth(24),
                        height: SizeConfig.getProportionateScreenWidth(24),
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                      ),
                    ],
                  ),
                  Gap(SizeConfig.getProportionateScreenHeight(24)),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(24),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          isLightMode
                              ? "assets/images/cart_empty_light.svg"
                              : 'assets/images/cart_empty_dark.svg',
                        ),
                        Gap(SizeConfig.getProportionateScreenHeight(24)),
                        Text(
                          'سبد خرید شما خالی است',
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateFontSize(18),
                            fontWeight: FontWeight.w700,
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap(SizeConfig.getProportionateScreenHeight(12)),
                        Text(
                          'هنوز هیچ محصولی به سبد خرید اضافه نکردی.\nبرای شروع خرید، به صفحه محصولات برو.',
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateFontSize(13),
                            color: isLightMode ? AppColors.grey600 : AppColors.grey300,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
