import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/size.dart';

class ProductCardShimmer extends StatelessWidget {
  final bool isLightMode;

  const ProductCardShimmer({super.key, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
      highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.getProportionateScreenWidth(200),
            height: SizeConfig.getProportionateScreenHeight(200),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(36)),
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.getProportionateScreenWidth(30),
                height: SizeConfig.getProportionateScreenHeight(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(5)),
              Container(
                width: SizeConfig.getProportionateScreenWidth(10),
                height: SizeConfig.getProportionateScreenHeight(10),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(5)),
              Container(
                width: SizeConfig.getProportionateScreenWidth(10),
                height: SizeConfig.getProportionateScreenHeight(10),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(5)),
              Container(
                width: SizeConfig.getProportionateScreenWidth(10),
                height: SizeConfig.getProportionateScreenHeight(10),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(5)),
              Container(
                width: SizeConfig.getProportionateScreenWidth(10),
                height: SizeConfig.getProportionateScreenHeight(10),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
