import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/custom_text_field.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = './signUp';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/sign_up_frame.svg'),
              Spacer(),
              Text(
                'عضوی از خانواده ما شو',
                style: TextStyle(
                  color: AppColors.grey900,
                  fontSize: SizeConfig.getProportionateScreenWidth(28),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              CustomTextField(
                obscureText: false,
                isLightMode: isLightMode,
                preffixIcon: 'assets/images/icons/Message_bold.svg',
                hintText: 'ایمیل یا شماره تلفن',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.getProportionateScreenHeight(58),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.disabledButton,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4, 8),
                      blurRadius: 24,
                      spreadRadius: 0,
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                  ],
                ),
                child: Text(
                  'تایید',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.getProportionateScreenWidth(18),
                    fontFamily: 'IranYekan',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'قبلا عضو خانوده ما بودی ؟',
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateScreenWidth(14),
                      color: AppColors.grey500,
                    ),
                  ),
                  SizedBox(width: SizeConfig.getProportionateScreenWidth(5)),
                  Text(
                    'ورود',
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateScreenWidth(14),
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
