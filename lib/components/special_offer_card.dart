import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:full_plants_ecommerce_app/utils/persian_number.dart';
import 'package:full_plants_ecommerce_app/utils/price_comma_seperator.dart';
import 'package:provider/provider.dart';

import '../auth/shop_repository.dart';
import '../models/store/product_model.dart';
import '../theme/colors.dart';
import '../utils/size.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({super.key, required this.isLightMode});

  final bool isLightMode;

  Widget _buildProductCard(ProductModel product, BuildContext context) {
    final mainImage =
        product.mainImage ?? (product.images.isNotEmpty ? product.images.first.image : '');
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.getProportionateScreenWidth(200),
            height: SizeConfig.getProportionateScreenHeight(200),
            //   decoration: BoxDecoration(
            //     color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
            //     borderRadius: BorderRadius.circular(36),
            //   ),
            child: Stack(
              children: [
                if (mainImage.isNotEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(36),
                        child: Image.network(mainImage, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                Positioned(
                  top: SizeConfig.getProportionateScreenHeight(10),
                  right: SizeConfig.getProportionateScreenWidth(10),
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(5)),
                    decoration: BoxDecoration(
                      color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/images/icons/Heart_outline.svg',
                        color: AppColors.primary,
                        width: SizeConfig.getProportionateScreenWidth(24),
                        height: SizeConfig.getProportionateScreenWidth(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: SizeConfig.getProportionateScreenWidth(10),
              left: SizeConfig.getProportionateScreenWidth(10),
            ),
            child: SizedBox(
              width: SizeConfig.getProportionateScreenWidth(200),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isLightMode ? AppColors.grey900 : AppColors.white,
                  fontSize: SizeConfig.getProportionateFontSize(16),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Peyda',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: SizeConfig.getProportionateScreenWidth(10),
              left: SizeConfig.getProportionateScreenWidth(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/icons/Star.svg',
                  color: AppColors.primary,
                  width: SizeConfig.getProportionateScreenWidth(20),
                  height: SizeConfig.getProportionateScreenWidth(20),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                Text(
                  product.averageRating.toString().farsiNumber,
                  style: TextStyle(
                    color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                    fontSize: SizeConfig.getProportionateFontSize(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                Text(
                  '|',
                  style: TextStyle(
                    color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.getProportionateFontSize(14),
                  ),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                Container(
                  width: SizeConfig.getProportionateScreenWidth(69),
                  height: SizeConfig.getProportionateScreenHeight(24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: BoxBorder.all(
                      color: AppColors.primary,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Text(
                    '${product.salesCount.toString().priceFormatter} فروش'.farsiNumber,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: SizeConfig.getProportionateFontSize(10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: SizeConfig.getProportionateScreenWidth(10),
              left: SizeConfig.getProportionateScreenWidth(10),
            ),
            child: Text(
              '${product.price.toString().priceFormatter} ریال'.farsiNumber,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: SizeConfig.getProportionateFontSize(16),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            style: TextStyle(color: isLightMode ? AppColors.grey700 : AppColors.grey300),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.getProportionateScreenHeight(320),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: products.take(10).map((product) {
            return Container(
              width: SizeConfig.getProportionateScreenWidth(220),
              margin: EdgeInsets.only(left: SizeConfig.getProportionateScreenWidth(8)),
              child: _buildProductCard(product, context),
            );
          }).toList(),
        ),
      ),
    );
  }
}
