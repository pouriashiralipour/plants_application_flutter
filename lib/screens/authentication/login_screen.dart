import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';

import '../../components/adaptive_gap.dart';
import '../../components/widgets/custom_logo_widget.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/bottom_auth_text.dart';
import 'components/custom_title_auth.dart';
import 'components/remember_me.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static String routeName = './login';

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(),
      header: Column(
        children: [
          CustomLogoWidget(),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(60)),
          CustomTitleAuth(title: 'به حساب کاربری خود وارد شوید'),
        ],
      ),
      form: Column(
        children: [
          CustomTextField(
            isLightMode: isLightMode,
            preffixIcon: 'assets/images/icons/Message_bold.svg',
            hintText: 'ایمیل یا شماره تلفن',
            textInputType: TextInputType.emailAddress,
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
      footer: Column(
        children: [
          CustomButton(
            onTap: () {},
            text: 'ورود',
            color: AppColors.disabledButton,
            width: SizeConfig.screenWidth,
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
            child: Text(
              'فراموشی رمز  عبور',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: SizeConfig.getProportionateFontSize(16),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          BottomAuthText(
            text: 'هنوز عضو خانواده ما نشدی ؟',
            buttonText: 'ثبت نام',
            onTap: () {
              Navigator.pushNamed(context, SignUpScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
