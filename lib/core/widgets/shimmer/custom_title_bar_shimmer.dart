import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/size_config.dart';

class CustomTitleBarShimmer extends StatelessWidget {
  const CustomTitleBarShimmer({super.key, required this.isLightMode});
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
              width: SizeConfig.getProportionateScreenWidth(100),
              height: SizeConfig.getProportionateScreenHeight(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
            highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
            child: Container(
              width: SizeConfig.getProportionateScreenWidth(80),
              height: SizeConfig.getProportionateScreenHeight(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
