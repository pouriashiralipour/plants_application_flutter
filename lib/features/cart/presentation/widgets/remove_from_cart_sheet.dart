import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/core/widgets/app_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/gap.dart';
import '../../data/models/cart_model.dart';
import '../../data/repository/cart_store.dart';
import 'cart_item_card.dart';

class RemoveFromCartSheet extends StatefulWidget {
  const RemoveFromCartSheet({required this.item, required this.isLightMode});

  final CartItemModel item;
  final bool isLightMode;

  @override
  State<RemoveFromCartSheet> createState() => _RemoveFromCartSheetState();
}

class _RemoveFromCartSheetState extends State<RemoveFromCartSheet> {
  bool _isRemoving = false;
  @override
  Widget build(BuildContext context) {
    final isLoading = _isRemoving;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(20),
        vertical: SizeConfig.getProportionateScreenHeight(16),
      ),
      decoration: BoxDecoration(
        color: widget.isLightMode ? AppColors.white : AppColors.dark2,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: SizeConfig.getProportionateScreenWidth(40),
              height: 4,
              decoration: BoxDecoration(
                color: widget.isLightMode ? AppColors.grey300 : AppColors.dark3,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Gap(SizeConfig.getProportionateScreenHeight(18)),
            Text(
              'حذف از سبد خرید؟',
              style: TextStyle(
                fontSize: SizeConfig.getProportionateFontSize(18),
                fontWeight: FontWeight.w900,
                color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
              ),
            ),
            Gap(SizeConfig.getProportionateScreenHeight(16)),
            CartItemCard(
              item: widget.item,
              isLightMode: widget.isLightMode,
              onIncrease: () {},
              onDecrease: () {},
              onRemove: () {},
              backgroundColor: widget.isLightMode ? AppColors.white : AppColors.dark1,
            ),
            Gap(SizeConfig.getProportionateScreenHeight(16)),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    isShadow: false,
                    width: 58,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: 'انصراف',
                    textColor: AppColors.primary,
                    color: widget.isLightMode
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.dark3,
                    fontSize: SizeConfig.getProportionateFontSize(13),
                  ),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(12)),
                Expanded(
                  child: isLoading
                      ? SizedBox(
                          width: 58,
                          height: SizeConfig.getProportionateScreenHeight(48),
                          child: const Center(child: AppProgressBarIndicator()),
                        )
                      : AppButton(
                          width: 58,
                          onTap: () async {
                            setState(() {
                              _isRemoving = true;
                            });

                            final startedAt = DateTime.now();

                            await context.read<CartStore>().removeItem(widget.item);

                            final elapsed = DateTime.now().difference(startedAt);
                            const minDuration = Duration(seconds: 1);
                            if (elapsed < minDuration) {
                              await Future.delayed(minDuration - elapsed);
                            }

                            if (!mounted) return;

                            setState(() {
                              _isRemoving = false;
                            });

                            Navigator.pop(context);
                          },
                          text: 'بله، حذف کن',
                          color: AppColors.primary,
                          fontSize: SizeConfig.getProportionateFontSize(13),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
