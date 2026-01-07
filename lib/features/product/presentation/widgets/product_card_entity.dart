import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import '../screens/product_details_screen.dart';
import '../../domain/entities/product.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/login_required_sheet.dart';

import 'package:full_plants_ecommerce_app/features/wishlist/presentation/notifiers/wishlist_notifier.dart';

class ProductCardEntity extends rp.ConsumerWidget {
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
  Widget build(BuildContext context, rp.WidgetRef ref) {
    final wishlistState = ref.watch(wishlistNotifierProvider);

    final isFav = wishlistState.items.any((e) => e.product.id == product.id);

    final mainImage = _mainImage;

    Future<void> toggleWishlist() async {
      final isAuthed = context.read<AuthController>().isAuthed;

      if (!isAuthed) {
        final goLogin = await showLoginRequiredSheet(
          context: context,
          title: 'علاقه‌مندی‌ها',
          message: 'برای افزودن یا حذف از علاقه‌مندی‌ها ابتدا وارد حساب کاربری شوید.',
          icon: "assets/images/icons/HeartBold.svg",
          loginText: 'ورود / ثبت‌نام',
          cancelText: 'بعداً',
        );

        if (goLogin != true || !context.mounted) return;

        await Navigator.push<bool>(
          context,
          MaterialPageRoute(fullscreenDialog: true, builder: (_) => const LoginScreen()),
        );

        if (!context.mounted) return;
        if (!context.read<AuthController>().isAuthed) return;
      }

      await ref.read(wishlistNotifierProvider.notifier).toggle(productId: product.id);
    }

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
            SizedBox(
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
                        onTap: toggleWishlist,
                        child: SvgPicture.asset(
                          isFav
                              ? 'assets/images/icons/HeartBold.svg'
                              : 'assets/images/icons/Heart_outline.svg',
                          colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
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
                    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
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
                      border: Border.all(
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
