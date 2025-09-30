import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:full_plants_ecommerce_app/utils/persian_number.dart';
import 'package:full_plants_ecommerce_app/utils/price_comma_seperator.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.getProportionateScreenHeight(300),
      child: Container(
        width: SizeConfig.getProportionateScreenWidth(220),
        height: SizeConfig.getProportionateScreenHeight(300),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(6, (index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(16)),
                    width: SizeConfig.getProportionateScreenWidth(200),
                    height: SizeConfig.getProportionateScreenHeight(200),
                    decoration: BoxDecoration(
                      color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset('assets/images/Plants2.png', fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: SizeConfig.getProportionateScreenHeight(16),
                          right: SizeConfig.getProportionateScreenWidth(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {},
                            child: SvgPicture.asset(
                              'assets/images/icons/Heart_outline.svg',
                              color: AppColors.primary,
                              width: SizeConfig.getProportionateScreenWidth(24),
                              height: SizeConfig.getProportionateScreenWidth(24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(16)),
                    child: Text(
                      'سانسوریا',
                      style: TextStyle(
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                        fontSize: SizeConfig.getProportionateFontSize(22),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/icons/Star.svg',
                          color: AppColors.primary,
                          width: SizeConfig.getProportionateScreenWidth(20),
                          height: SizeConfig.getProportionateScreenWidth(20),
                        ),
                        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                        Text(
                          '4.8'.farsiNumber,
                          style: TextStyle(
                            color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                            fontSize: SizeConfig.getProportionateFontSize(14),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                        Text(
                          '|',
                          style: TextStyle(
                            fontFamily: 'IranYekan',
                            color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.getProportionateFontSize(14),
                          ),
                        ),
                        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                        Container(
                          width: SizeConfig.getProportionateScreenWidth(69),
                          height: SizeConfig.getProportionateScreenHeight(24),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: BoxBorder.all(
                              color: AppColors.primary,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Text(
                            '${4268.toString().priceFormatter} فروش'.farsiNumber,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: SizeConfig.getProportionateFontSize(10),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(16)),
                    child: Text(
                      '${1233000.toString().priceFormatter} تومان'.farsiNumber,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: SizeConfig.getProportionateFontSize(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
