import 'package:flutter/material.dart';

import '../../components/custom_text_field.dart';
import '../../components/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/auth_svg_asset_widget.dart';
import 'components/custom_title_auth.dart';
import 'otp_scree.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = './forgot_password';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(24),
                  vertical: SizeConfig.getProportionateScreenHeight(40),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AuthSvgAssetWidget(
                        svg: isLightMode
                            ? 'assets/images/Forgot_Password_Light_Frame.svg'
                            : 'assets/images/Forgot_Password_Dark_Frame.svg',
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.1),
                      CustomTitleAuth(title: 'فراموشی رمز عبور'),
                      SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
                      CustomTextField(
                        isLightMode: isLightMode,
                        preffixIcon: 'assets/images/icons/Message_bold.svg',
                        hintText: 'ایمیل یا شماره تلفن',
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.1),
                      CustomButton(
                        text: 'ادامه',
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.pushNamed(context, OTPScreen.routeName);
                        },
                        width: SizeConfig.getProportionateScreenWidth(98),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
