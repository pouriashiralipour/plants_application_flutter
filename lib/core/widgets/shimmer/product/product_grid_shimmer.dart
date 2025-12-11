import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/size_config.dart';

class ProductGridShimmer extends StatelessWidget {
  final bool isLightMode;

  const ProductGridShimmer({super.key, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(16)),
      child: Shimmer.fromColors(
        baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
        highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.6,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: SizeConfig.getProportionateScreenHeight(140),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(100),
                  height: SizeConfig.getProportionateScreenHeight(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
                Row(
                  children: [
                    Container(
                      width: SizeConfig.getProportionateScreenWidth(50),
                      height: SizeConfig.getProportionateScreenHeight(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateScreenWidth(4)),
                    Container(
                      width: SizeConfig.getProportionateScreenWidth(30),
                      height: SizeConfig.getProportionateScreenHeight(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(60),
                  height: SizeConfig.getProportionateScreenHeight(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
