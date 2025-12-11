import 'package:flutter/material.dart';

import '../../utils/size_config.dart';
import 'custom_app_bar_shimmer.dart';
import 'custom_search_bar_shimmer.dart';
import 'custom_title_bar_shimmer.dart';
import 'special_offer_shimmer.dart';
import 'custom_category_bar_shimmer.dart';
import 'product/product_grid_shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  final bool isLightMode;

  const HomeScreenShimmer({super.key, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              CustomAppBarShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              CustomSearchBarShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              CustomTitleBarShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              SpecialOfferShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              CustomTitleBarShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              CustomCategoryBarShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              ProductGridShimmer(isLightMode: isLightMode),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
            ],
          ),
        ),
      ),
    );
  }
}
