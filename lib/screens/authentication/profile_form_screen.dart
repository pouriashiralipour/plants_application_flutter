import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';

import '../../components/adaptive_gap.dart';
import '../../components/widgets/custom_dialog.dart';
import '../../components/widgets/custom_drop_down.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import '../root/root_screen.dart';

class ProfileFormScreen extends StatelessWidget {
  const ProfileFormScreen({super.key});

  static String routeName = './profile_form';

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(
        title: Text(
          'تکمیل کردن پروفایل',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.getProportionateScreenWidth(21),
          ),
        ),
      ),
      header: Stack(
        children: [
          Container(
            width: SizeConfig.getProportionateScreenWidth(140),
            height: SizeConfig.getProportionateScreenWidth(140),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  isLightMode ? 'assets/images/profile.png' : 'assets/images/profile_dark.png',
                ),
              ),
            ),
          ),
          Positioned(
            top: 105,
            left: 105,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: SizeConfig.getProportionateScreenWidth(35),
                height: SizeConfig.getProportionateScreenWidth(35),
                child: SvgPicture.asset(
                  'assets/images/icons/Edit_squre.svg',
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      form: Column(
        children: [
          CustomTextField(isPassword: false, isLightMode: isLightMode, hintText: 'نام کامل'),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
          CustomTextField(isPassword: false, isLightMode: isLightMode, hintText: 'نام مستعار'),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
          CustomTextField(
            isPassword: false,
            isLightMode: isLightMode,
            hintText: 'تاریخ تولد',
            suffixIcon: 'assets/images/icons/Calendar_curve.svg',
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
          CustomTextField(
            isPassword: false,
            isLightMode: isLightMode,
            hintText: 'ایمیل',
            suffixIcon: 'assets/images/icons/Message_curve.svg',
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
          CustomTextField(
            isPassword: false,
            isLightMode: isLightMode,
            hintText: 'شماره موبایل',
            suffixIcon: 'assets/images/icons/Call_curve.svg',
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
          FancyDropdownFormField(hint: 'جنسیت', items: const ['زن', 'مرد'], onChanged: (v) {}),
        ],
      ),
      footer: CustomButton(
        onTap: () {
          customSuccessShowDialog(context);
        },
        text: 'ادامه',
        color: AppColors.disabledButton,
        width: SizeConfig.getProportionateScreenWidth(98),
      ),
    );
  }
}

Future<dynamic> customSuccessShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.grey900.withValues(alpha: 0.8),
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      });
      return CustomSuccessDialog(
        text: 'حساب کاربری شما فعال شد.\nتا لحظاتی دیگر به صفحه خانه هدایت می شوید',
      );
    },
  );
}
