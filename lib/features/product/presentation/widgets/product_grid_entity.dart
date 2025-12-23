import 'package:flutter/material.dart';

import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer/product/product_grid_shimmer.dart';
import '../../domain/entities/product.dart';
import 'product_card_entity.dart';

class ProductGridEntity extends StatelessWidget {
  const ProductGridEntity({
    super.key,
    required this.isLightMode,
    required this.products,
  });

  final bool isLightMode;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return ProductGridShimmer(isLightMode: isLightMode);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
          childAspectRatio: 0.6,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCardEntity(
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
