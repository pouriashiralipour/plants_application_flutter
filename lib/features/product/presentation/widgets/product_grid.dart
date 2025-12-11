import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer/product/product_grid_shimmer.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../../../core/utils/size_config.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.isLightMode, this.shopRepository, this.products});

  final bool isLightMode;
  final List<ProductModel>? products;
  final ShopRepository? shopRepository;

  List<ProductModel> get _items {
    if (products != null) {
      return products!;
    }
    return shopRepository!.products;
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) {
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
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
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
