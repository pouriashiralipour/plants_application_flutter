import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';

import '../../components/adaptive_gap.dart';
import '../../components/widgets/custom_dialog.dart';

import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/auth_svg_asset_widget.dart';
import 'components/remember_me.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String routeName = './change_password';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(
        title: Text(
          'ساخت رمزعبور جدید',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.getProportionateScreenWidth(21),
          ),
        ),
      ),
      header: Column(
        children: [
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
          AuthSvgAssetWidget(
            svg: isLightMode
                ? 'assets/images/new_pass_light.svg'
                : 'assets/images/new_pass_dark.svg',
          ),
        ],
      ),
      form: Column(
        children: [
          Text(
            'رمزعبور جدید خود را وارد کنید',
            style: TextStyle(
              color: isLightMode ? AppColors.grey900 : AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.getProportionateScreenWidth(16),
            ),
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          CustomTextField(
            isPassword: true,
            suffixIcon: 'assets/images/icons/Hide_bold.svg',
            isLightMode: isLightMode,
            preffixIcon: 'assets/images/icons/Lock_bold.svg',
            hintText: 'رمزعبور',
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
          CustomTextField(
            isPassword: true,
            suffixIcon: 'assets/images/icons/Hide_bold.svg',
            isLightMode: isLightMode,
            preffixIcon: 'assets/images/icons/Lock_bold.svg',
            hintText: 'رمزعبور',
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
          RememberMeWidget(),
        ],
      ),
      footer: CustomButton(
        onTap: () {
          customSuccessShowDialog(context);
        },
        text: 'ادامه',
        color: AppColors.primary,
        width: SizeConfig.getProportionateScreenWidth(98),
      ),
    );
  }

  Future<dynamic> customSuccessShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.grey900.withValues(alpha: 0.8),
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
        return CustomSuccessDialog(
          text:
              "رمز عبور شما با موفقیت تغییر کرد.\nحالا میتونی با رمزعبور جدید وارد بشی.\nشما تا لحظاتی دیگر به صفحه ورود هدایت می شوید",
        );
      },
    );
  }
}
