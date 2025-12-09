import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/size.dart';

class CustomAppBarShimmer extends StatelessWidget {
  const CustomAppBarShimmer({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Shimmer.fromColors(
            baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
            highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
            child: Container(
              width: SizeConfig.getProportionateScreenWidth(48),
              height: SizeConfig.getProportionateScreenWidth(48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Shimmer.fromColors(
                baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
                highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
                child: Container(
                  width: SizeConfig.getProportionateScreenWidth(120),
                  height: SizeConfig.getProportionateScreenHeight(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(4)),
              Shimmer.fromColors(
                baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
                highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
                child: Container(
                  width: SizeConfig.getProportionateScreenWidth(80),
                  height: SizeConfig.getProportionateScreenHeight(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
