import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../auth/shop_repository.dart';
import '../theme/colors.dart';
import '../utils/size.dart';
import 'product_card.dart';

class SpecialOfferCard extends StatefulWidget {
  const SpecialOfferCard({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  State<SpecialOfferCard> createState() => _SpecialOfferCardState();
}

class _SpecialOfferCardState extends State<SpecialOfferCard> {
  @override
  Widget build(BuildContext context) {
    final shopRepository = context.watch<ShopRepository>();
    final products = shopRepository.products;

    if (products.isEmpty) {
      return SizedBox(
        height: SizeConfig.getProportionateScreenHeight(300),
        child: Center(
          child: Text(
            'محصولی موجود نیست',
            style: TextStyle(color: widget.isLightMode ? AppColors.grey700 : AppColors.grey300),
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.getProportionateScreenHeight(5),
        bottom: SizeConfig.getProportionateScreenHeight(5),
      ),
      decoration: BoxDecoration(
        color: widget.isLightMode ? AppColors.white : AppColors.dark1,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            spreadRadius: 4,
            blurRadius: 7,
            offset: Offset(0, 1),
          ),
        ],
      ),
      width: double.infinity,
      height: SizeConfig.getProportionateScreenHeight(320),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: products.take(10).map((product) {
            return Container(
              width: SizeConfig.getProportionateScreenWidth(220),
              margin: EdgeInsets.only(left: SizeConfig.getProportionateScreenWidth(8)),
              child: ProductCard(product: product, isLightMode: widget.isLightMode),
            );
          }).toList(),
        ),
      ),
    );
  }
}
