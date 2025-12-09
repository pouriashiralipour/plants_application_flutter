import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/size_config.dart';

class CustomCategoryBarShimmer extends StatelessWidget {
  const CustomCategoryBarShimmer({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(38),
      child: Shimmer.fromColors(
        baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
        highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: SizeConfig.getProportionateScreenWidth(24)),
              ...List.generate(5, (index) {
                return Container(
                  height: SizeConfig.getProportionateScreenHeight(38),
                  margin: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(12)),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(20),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      width: SizeConfig.getProportionateScreenWidth(40),
                      height: SizeConfig.getProportionateScreenHeight(12),
                      color: Colors.white,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
