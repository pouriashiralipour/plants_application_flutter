import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer/product_grid_shimmer.dart';
import '../../data/repositories/product_repository.dart';
import '../../../../core/utils/size_config.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.shopRepository, required this.isLightMode});

  final ShopRepository shopRepository;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    if (shopRepository.products.isEmpty) {
      return ProductGridShimmer(isLightMode: isLightMode);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(16)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
          childAspectRatio: 0.6,
        ),
        itemCount: shopRepository.products.length,
        itemBuilder: (context, index) {
          final product = shopRepository.products[index];
          return ProductCard(
            product: product,
            isLightMode: isLightMode,
            isGrid: true,
            boxSize: 182,
            textSize: 14,
          );
        },
      ),
    );
  }
}
