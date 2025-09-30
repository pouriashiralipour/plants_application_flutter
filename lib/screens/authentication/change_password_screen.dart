import 'package:flutter/material.dart';

import '../../components/custom_dialog.dart';

import '../../components/custom_text_field.dart';
import '../../components/cutsom_button.dart';
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
    return Scaffold(
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
                  children: [
                    AuthSvgAssetWidget(
                      svg: isLightMode
                          ? 'assets/images/new_pass_light.svg'
                          : 'assets/images/new_pass_dark.svg',
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    Text(
                      'رمزعبور جدید خود را وارد کنید',
                      style: TextStyle(
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.getProportionateScreenWidth(16),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                    Column(
                      children: List.generate(
                        2,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.getProportionateScreenHeight(24),
                          ),
                          child: CustomTextField(
                            isPassword: true,
                            suffixIcon: 'assets/images/icons/Hide_bold.svg',
                            isLightMode: isLightMode,
                            preffixIcon: 'assets/images/icons/Lock_bold.svg',
                            hintText: index == 0 ? 'رمزعبور' : 'تکرار رمزعبور',
                          ),
                        ),
                      ),
                    ),
                    RememberMeWidget(),
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    CustomButton(
                      onTap: () {
                        customSuccessShowDialog(context);
                      },
                      text: 'ادامه',
                      color: AppColors.primary,
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
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        });
        return CustomSuccessDialog();
      },
    );
  }
}
