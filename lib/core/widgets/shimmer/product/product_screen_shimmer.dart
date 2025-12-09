import 'package:flutter/material.dart';

import '../../../../core/utils/size.dart';
import 'product_card_shimmer.dart';
import 'product_detail_shimmer.dart';

class ProductScreenShimmer extends StatelessWidget {
  const ProductScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              SizedBox(
                height: SizeConfig.screenHeight * 0.3,
                width: double.infinity,
                child: ProductCardShimmer(isLightMode: isLightMode),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              ProductDetailShimmer(isLightMode: isLightMode),
            ],
          ),
        ),
      ),
    );
  }
}
