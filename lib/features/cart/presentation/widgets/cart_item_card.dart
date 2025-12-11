import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/gap.dart';
import '../../data/models/cart_model.dart';
import 'quantity_button.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    required this.isLightMode,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    this.backgroundColor,
  });

  final CartItemModel item;
  final bool isLightMode;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(15)),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isLightMode ? AppColors.white : AppColors.dark2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (isLightMode)
            BoxShadow(color: AppColors.grey200, blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: SizeConfig.getProportionateScreenWidth(100),
            height: SizeConfig.getProportionateScreenWidth(100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
              image: product.image.isNotEmpty
                  ? DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover)
                  : null,
            ),
            child: product.image.isEmpty
                ? Icon(
                    Icons.local_florist,
                    color: AppColors.primary,
                    size: SizeConfig.getProportionateScreenWidth(32),
                  )
                : null,
          ),
          SizedBox(width: SizeConfig.getProportionateScreenWidth(20)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(14),
                    fontWeight: FontWeight.bold,
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(SizeConfig.getProportionateScreenHeight(4)),
                Text(
                  '${product.price.toString().priceFormatter} ریال'.farsiNumber,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(14),
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                Gap(SizeConfig.getProportionateScreenHeight(8)),
                Row(
                  children: [
                    QuantityButton(icon: Icons.remove, onTap: onDecrease, isLightMode: isLightMode),
                    SizedBox(
                      width: SizeConfig.getProportionateScreenWidth(40),
                      child: Center(
                        child: Text(
                          item.quantity.toString().farsiNumber,
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateFontSize(14),
                            fontWeight: FontWeight.w700,
                            color: isLightMode ? AppColors.primary : AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    QuantityButton(icon: Icons.add, onTap: onIncrease, isLightMode: isLightMode),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onRemove,
            icon: SvgPicture.asset(
              'assets/images/icons/Delete.svg',
              color: isLightMode ? AppColors.grey900 : AppColors.grey300,
              width: SizeConfig.getProportionateScreenWidth(20),
              height: SizeConfig.getProportionateScreenWidth(20),
            ),
          ),
        ],
      ),
    );
  }
}
