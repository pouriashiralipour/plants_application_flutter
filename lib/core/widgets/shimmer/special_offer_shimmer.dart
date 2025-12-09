import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/size_config.dart';

class SpecialOfferShimmer extends StatelessWidget {
  const SpecialOfferShimmer({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.getProportionateScreenHeight(5),
        bottom: SizeConfig.getProportionateScreenHeight(5),
      ),

      width: double.infinity,
      height: SizeConfig.getProportionateScreenHeight(320),
      child: Shimmer.fromColors(
        baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
        highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(3, (index) {
              return Container(
                width: SizeConfig.getProportionateScreenWidth(220),
                margin: EdgeInsets.only(
                  left: SizeConfig.getProportionateScreenWidth(8),
                  right: index == 2 ? SizeConfig.getProportionateScreenWidth(8) : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.getProportionateScreenWidth(200),
                      height: SizeConfig.getProportionateScreenHeight(200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
                    Container(
                      width: SizeConfig.getProportionateScreenWidth(120),
                      height: SizeConfig.getProportionateScreenHeight(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
                    Row(
                      children: [
                        Container(
                          width: SizeConfig.getProportionateScreenWidth(60),
                          height: SizeConfig.getProportionateScreenHeight(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: SizeConfig.getProportionateScreenWidth(8)),
                        Container(
                          width: SizeConfig.getProportionateScreenWidth(40),
                          height: SizeConfig.getProportionateScreenHeight(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
                    Container(
                      width: SizeConfig.getProportionateScreenWidth(80),
                      height: SizeConfig.getProportionateScreenHeight(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
