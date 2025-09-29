import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/custom_text_field.dart';
import '../../components/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/auth_svg_asset_widget.dart';
import 'components/bottom_auth_text.dart';
import 'components/custom_title_auth.dart';
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateScreenWidth(24),
            vertical: SizeConfig.getProportionateScreenHeight(48),
          ),
          child: CustomRegisterLoginData(isLightMode: isLightMode),
        ),
      ),
    );
  }
}

class CustomRegisterLoginData extends StatelessWidget {
  const CustomRegisterLoginData({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AuthSvgAssetWidget(svg: 'assets/images/sign_up_frame.svg'),
        Spacer(),
        CustomTitleAuth(title: 'عضوی از خانواده ما شو'),
        Spacer(),
        CustomTextField(
          obscureText: false,
          isLightMode: isLightMode,
          preffixIcon: 'assets/images/icons/Message_bold.svg',
          hintText: 'ایمیل یا شماره تلفن',
          textInputType: TextInputType.emailAddress,
        ),
        Spacer(),
        CustomButton(
          text: 'تایید',
          color: AppColors.disabledButton,
          onTap: () {
            Navigator.pushNamed(context, OTPScreen.routeName);
          },
        ),
        Spacer(),
        BottomAuthText(text: 'قبلا عضو خانوده ما بودی ؟', buttonText: 'ورود', onTap: () {}),
      ],
    );
  }
}

// CustomTextField(
//                 obscureText: true,
//                 suffixIcon: 'assets/images/icons/Hide_bold.svg',
//                 isLightMode: isLightMode,
//                 preffixIcon: 'assets/images/icons/Lock_bold.svg',
//                 hintText: 'رمزعبور',
//               ),
