import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';
import 'package:full_plants_ecommerce_app/utils/persian_number.dart';

import '../../components/adaptive_gap.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'change_password_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, this.fromSignup = false});

  static String routeName = './otp';

  final bool fromSignup;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  int _secondsRemaining = 120;

  Timer? _timer;

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  Widget _buildOtpBox(int index) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    bool isFocused = _focusNodes[index].hasFocus;
    return SizedBox(
      width: SizeConfig.getProportionateScreenWidth(50),
      height: SizeConfig.getProportionateScreenWidth(60),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: SizeConfig.getProportionateScreenWidth(24),
          fontWeight: FontWeight.w700,
          color: isLightMode ? AppColors.grey900 : AppColors.white,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: isLightMode
              ? (isFocused ? AppColors.primary.withValues(alpha: 0.08) : AppColors.grey50)
              : (isFocused ? AppColors.primary.withValues(alpha: 0.08) : AppColors.dark2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isLightMode ? AppColors.grey200 : AppColors.dark3,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            final persian = value.farsiNumber;
            _controllers[index].value = TextEditingValue(
              text: persian,
              selection: TextSelection.collapsed(offset: persian.length),
            );

            if (index < 4) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
          setState(() {});
        },
      ),
    );
  }

  void _startTimer() {
    _secondsRemaining = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(
        title: Text(
          widget.fromSignup ? 'ثبت‌نام' : 'فراموشی رمز عبور',
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
          SvgPicture.asset(
            isLightMode
                ? 'assets/images/Forgot_Password_Light_Frame.svg'
                : 'assets/images/Forgot_Password_Dark_Frame.svg',
            width: SizeConfig.getProportionateScreenWidth(150),
            height: SizeConfig.getProportionateScreenWidth(150),
          ),
        ],
      ),
      form: Column(
        children: [
          Text(
            "کد به شماره 22 ***** 98916+ ارسال شد",
            style: TextStyle(
              fontSize: SizeConfig.getProportionateFontSize(16),
              fontWeight: FontWeight.w500,
              color: isLightMode ? AppColors.grey900 : AppColors.white,
            ),
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildOtpBox(index),
              );
            }),
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
          _secondsRemaining > 0
              ? RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Shabnam',
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.getProportionateFontSize(16),
                      color: AppColors.grey900,
                    ),
                    children: [
                      TextSpan(
                        text: "ارسال دوباره کد در ",
                        style: TextStyle(
                          color: isLightMode ? AppColors.grey900 : AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.getProportionateFontSize(16),
                        ),
                      ),
                      TextSpan(
                        text: '$_secondsRemaining'.farsiNumber,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: " ثانیه",
                        style: TextStyle(
                          color: isLightMode ? AppColors.grey900 : AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.getProportionateFontSize(16),
                        ),
                      ),
                    ],
                  ),
                )
              : TextButton(
                  onPressed: _startTimer,
                  child: Text(
                    "ارسال مجدد",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: SizeConfig.getProportionateFontSize(16),
                    ),
                  ),
                ),
        ],
      ),
      footer: CustomButton(
        text: 'تایید',
        color: AppColors.disabledButton,
        onTap: () {
          final otp = _controllers.map((c) => c.text).join();
          print("OTP: $otp");
          Navigator.pushNamed(context, ChangePasswordScreen.routeName);
        },
        width: SizeConfig.getProportionateScreenWidth(77),
      ),
    );
  }
}
