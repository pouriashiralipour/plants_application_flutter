import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/components/custom_logo_widget.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';

import '../../components/adaptive_gap.dart';
import '../../components/custom_text_field.dart';
import '../../components/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/auth_svg_asset_widget.dart';
import 'components/bottom_auth_text.dart';
import 'components/custom_title_auth.dart';
import 'login_screen.dart';
import 'otp_scree.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String routeName = './signUp';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      header: Column(
        children: [
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
          CustomLogoWidget(),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(60)),
          AuthSvgAssetWidget(
            svg: isLightMode
                ? 'assets/images/sign_up_frame.svg'
                : 'assets/images/sign_up_dark_frame.svg',
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(60)),
          CustomTitleAuth(title: 'عضوی از خانواده ما شو'),
        ],
      ),
      form: CustomTextField(
        isLightMode: isLightMode,
        preffixIcon: 'assets/images/icons/Message_bold.svg',
        hintText: 'ایمیل یا شماره تلفن',
        textInputType: TextInputType.emailAddress,
      ),
      footer: Column(
        children: [
          CustomButton(
            text: 'تایید',
            color: AppColors.disabledButton,
            onTap: () {
              Navigator.pushNamed(context, OTPScreen.routeName);
            },
            width: SizeConfig.screenWidth,
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          BottomAuthText(
            text: 'قبلا عضو خانوده ما بودی ؟',
            buttonText: 'ورود',
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
