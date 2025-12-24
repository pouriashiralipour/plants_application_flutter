import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/gap.dart';
import '../../data/models/cart_model.dart';
import '../../data/repository/cart_store.dart';
import '../widgets/cart_empty.dart';
import '../widgets/cart_summery_bar.dart';
import '../widgets/remove_from_cart_sheet.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final cart = context.watch<CartStore>();
    final items = cart.items;

    if (cart.isLoading && items.isEmpty) {
      return const Center(child: AppProgressBarIndicator());
    }

    if (items.isEmpty) {
      return CartEmpty(isLightMode: isLightMode);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
              child: Column(
                children: [
                  Gap(SizeConfig.getProportionateScreenHeight(15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/Logo.svg',
                            width: SizeConfig.getProportionateScreenWidth(28),
                            height: SizeConfig.getProportionateScreenWidth(28),
                          ),
                          SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                          Text(
                            'سبد خرید',
                            style: TextStyle(
                              fontSize: SizeConfig.getProportionateFontSize(24),
                              fontWeight: FontWeight.w800,
                              color: isLightMode ? AppColors.grey900 : AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/icons/Search.svg',
                        width: SizeConfig.getProportionateScreenWidth(24),
                        height: SizeConfig.getProportionateScreenWidth(24),
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                      ),
                    ],
                  ),
                  Gap(SizeConfig.getProportionateScreenHeight(24)),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(16),
                  vertical: SizeConfig.getProportionateScreenHeight(16),
                ),
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    Gap(SizeConfig.getProportionateScreenHeight(24)),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return CartItemCard(
                    item: item,
                    isLightMode: isLightMode,
                    onIncrease: () {
                      context.read<CartStore>().changeQuantity(item, item.quantity + 1);
                    },
                    onDecrease: () {
                      context.read<CartStore>().changeQuantity(item, item.quantity - 1);
                    },
                    onRemove: () => _showRemoveFromCartSheet(context, item, isLightMode),
                  );
                },
              ),
            ),
            CartSummaryBar(totalPrice: cart.displaytotalPrice, isLightMode: isLightMode),
          ],
        ),
      ),
    );
  }

  void _showRemoveFromCartSheet(BuildContext context, CartItemModel item, bool isLightMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (context) {
        return RemoveFromCartSheet(item: item, isLightMode: isLightMode);
      },
    );
  }
}
