import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../custom_category_bar_shimmer.dart';
import 'product_grid_shimmer.dart';

class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              CustomCategoryBarShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              ProductGridShimmer(isLightMode: isLightMode),
            ],
          ),
        ),
      ),
    );
  }
}
