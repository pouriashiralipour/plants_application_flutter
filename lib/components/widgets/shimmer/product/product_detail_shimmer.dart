import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/size.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
      child: Shimmer.fromColors(
        baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
        highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.getProportionateScreenWidth(200),
                  height: SizeConfig.getProportionateScreenHeight(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(30),
                  height: SizeConfig.getProportionateScreenHeight(30),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Row(
              children: [
                Container(
                  width: SizeConfig.getProportionateScreenWidth(69),
                  height: SizeConfig.getProportionateScreenHeight(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(30),
                  height: SizeConfig.getProportionateScreenHeight(30),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(60),
                  height: SizeConfig.getProportionateScreenHeight(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(69),
                  height: SizeConfig.getProportionateScreenHeight(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Divider(thickness: 2),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Container(
              width: SizeConfig.getProportionateScreenWidth(120),
              height: SizeConfig.getProportionateScreenHeight(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Container(
              width: double.infinity,
              height: SizeConfig.getProportionateScreenHeight(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
            Container(
              width: SizeConfig.screenWidth - 100,
              height: SizeConfig.getProportionateScreenHeight(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
            Container(
              width: SizeConfig.screenWidth - 200,
              height: SizeConfig.getProportionateScreenHeight(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Container(
              width: SizeConfig.getProportionateScreenWidth(150),
              height: SizeConfig.getProportionateScreenHeight(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.getProportionateScreenWidth(120),
                  height: SizeConfig.getProportionateScreenHeight(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(150),
                  height: SizeConfig.getProportionateScreenHeight(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Divider(thickness: 2),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.getProportionateScreenWidth(150),
                  height: SizeConfig.getProportionateScreenHeight(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.getProportionateScreenWidth(50),
                      height: SizeConfig.getProportionateScreenHeight(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(5)),
                    Container(
                      width: SizeConfig.getProportionateScreenWidth(150),
                      height: SizeConfig.getProportionateScreenHeight(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
