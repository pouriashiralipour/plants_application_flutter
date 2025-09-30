import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/components/custom_logo_widget.dart';

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
  static String routeName = './signUp';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomLogoWidget(),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    AuthSvgAssetWidget(
                      svg: isLightMode
                          ? 'assets/images/sign_up_frame.svg'
                          : 'assets/images/sign_up_dark_frame.svg',
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    CustomTitleAuth(title: 'عضوی از خانواده ما شو'),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
                    CustomTextField(
                      isLightMode: isLightMode,
                      preffixIcon: 'assets/images/icons/Message_bold.svg',
                      hintText: 'ایمیل یا شماره تلفن',
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                    CustomButton(
                      text: 'تایید',
                      color: AppColors.disabledButton,
                      onTap: () {
                        Navigator.pushNamed(context, OTPScreen.routeName);
                      },
                      width: SizeConfig.screenWidth,
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
                    BottomAuthText(
                      text: 'قبلا عضو خانوده ما بودی ؟',
                      buttonText: 'ورود',
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
