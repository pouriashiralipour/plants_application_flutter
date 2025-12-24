import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../../domain/entities/product.dart';
import '../../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/utils/size_config.dart';

class ProductCardEntity extends StatelessWidget {
  const ProductCardEntity({
    super.key,
    required this.product,
    required this.isLightMode,
    this.isGrid = false,
    this.boxSize = 180,
    this.textSize = 14,
  });

  final double boxSize;
  final bool isGrid;
  final bool isLightMode;
  final Product product;
  final double textSize;

  int get _displayPrice => product.price ~/ 10;
  String get _formattedDisplayPrice =>
      '${_displayPrice.toString().priceFormatter} تومان'.farsiNumber;

  String get _mainImage {
    if (product.mainImage != null && product.mainImage!.isNotEmpty) {
      return product.mainImage!;
    }
    final byFlag = product.mainPicture?.image;
    if (byFlag != null && byFlag.isNotEmpty) return byFlag;

    if (product.images.isNotEmpty) return product.images.first.image;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistController>();
    final isFav = wishlist.isWishlisted(product.id);

    final mainImage = _mainImage;

    return Padding(
      padding: !isGrid
          ? EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(24))
          : EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen(productId: product.id)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: SizeConfig.getProportionateScreenWidth(boxSize),
              height: SizeConfig.getProportionateScreenHeight(boxSize),
              child: Stack(
                children: [
                  if (mainImage.isNotEmpty)
                    Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(32),
                          child: Image.network(mainImage, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  Positioned(
                    top: isGrid ? 0 : SizeConfig.getProportionateScreenWidth(10),
                    right: isGrid ? 0 : SizeConfig.getProportionateScreenWidth(10),
                    child: Container(
                      padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(5)),
                      decoration: BoxDecoration(
                        color: isLightMode ? AppColors.grey200 : AppColors.dark3,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          context.read<WishlistController>().toggle(product.id);
                        },
                        child: SvgPicture.asset(
                          isFav
                              ? 'assets/images/icons/HeartBold.svg'
                              : 'assets/images/icons/Heart_outline.svg',
                          color: AppColors.primary,
                          width: SizeConfig.getProportionateScreenWidth(20),
                          height: SizeConfig.getProportionateScreenWidth(20),
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
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                    fontSize: SizeConfig.getProportionateFontSize(textSize),
                    fontWeight: FontWeight.w700,
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
                _formattedDisplayPrice,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: SizeConfig.getProportionateFontSize(textSize),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
