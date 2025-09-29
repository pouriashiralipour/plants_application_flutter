import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/custom_text_field.dart';
import '../../components/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/bottom_auth_text.dart';
import 'components/custom_title_auth.dart';
import 'components/remember_me.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static String routeName = './login';

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateScreenWidth(24),
                vertical: SizeConfig.getProportionateScreenHeight(40),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'hiloropia',
                        style: TextStyle(
                          fontFamily: 'IranYekan',
                          color: AppColors.grey900,
                          fontWeight: FontWeight.w900,
                          fontSize: SizeConfig.getProportionateScreenWidth(48),
                        ),
                      ),
                      SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                      SvgPicture.asset(
                        'assets/images/Logo.svg',
                        height: SizeConfig.getProportionateScreenWidth(60),
                        width: SizeConfig.getProportionateScreenWidth(60),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
                  CustomTitleAuth(title: 'به حساب کاربری خود وارد شوید'),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
                  CustomTextField(
                    isLightMode: isLightMode,
                    preffixIcon: 'assets/images/icons/Message_bold.svg',
                    hintText: 'ایمیل یا شماره تلفن',
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                  CustomTextField(
                    isPassword: true,
                    suffixIcon: 'assets/images/icons/Hide_bold.svg',
                    isLightMode: isLightMode,
                    preffixIcon: 'assets/images/icons/Lock_bold.svg',
                    hintText: 'رمزعبور',
                  ),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                  RememberMeWidget(),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                  CustomButton(onTap: () {}, text: 'ورود', color: AppColors.disabledButton),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                  Text(
                    'فراموشی رمز  عبور',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: SizeConfig.getProportionateScreenWidth(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
                  BottomAuthText(
                    text: 'هنوز عضو خانواده ما نشدی ؟',
                    buttonText: 'ثبت نام',
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
