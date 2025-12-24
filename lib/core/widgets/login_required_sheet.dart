import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/size_config.dart';
import 'app_button.dart';
import 'gap.dart';

Future<bool?> showLoginRequiredSheet({
  required BuildContext context,
  required String message,
  String title = 'نیاز به ورود',
  IconData icon = Icons.lock_rounded,
  String loginText = 'ورود / ثبت‌نام',
  String cancelText = 'بعداً',
}) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (sheetContext) {
      final isLightMode = Theme.of(sheetContext).brightness == Brightness.light;

      return SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.getProportionateScreenWidth(20),
            right: SizeConfig.getProportionateScreenWidth(20),
            top: SizeConfig.getProportionateScreenHeight(16),
            bottom: SizeConfig.getProportionateScreenHeight(16),
          ),
          decoration: BoxDecoration(
            color: isLightMode ? AppColors.white : AppColors.dark2,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: SizeConfig.getProportionateScreenWidth(44),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isLightMode ? AppColors.grey300 : AppColors.dark3,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Gap(SizeConfig.getProportionateScreenHeight(16)),

              Container(
                width: SizeConfig.getProportionateScreenWidth(56),
                height: SizeConfig.getProportionateScreenWidth(56),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: SizeConfig.getProportionateScreenWidth(28),
                ),
              ),

              Gap(SizeConfig.getProportionateScreenHeight(12)),
              Text(
                title,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: isLightMode ? AppColors.grey900 : AppColors.white,
                  fontSize: SizeConfig.getProportionateFontSize(16),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gap(SizeConfig.getProportionateScreenHeight(8)),
              Text(
                message,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                  fontSize: SizeConfig.getProportionateFontSize(13),
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Gap(SizeConfig.getProportionateScreenHeight(16)),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      isShadow: false,
                      width: double.infinity,
                      onTap: () => Navigator.pop(sheetContext, false),
                      text: cancelText,
                      color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                      textColor: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: SizeConfig.getProportionateScreenWidth(12)),
                  Expanded(
                    child: AppButton(
                      width: double.infinity,
                      onTap: () => Navigator.pop(sheetContext, true),
                      text: loginText,
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
