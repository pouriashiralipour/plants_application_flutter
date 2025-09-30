import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/utils/persian_number.dart';

import '../../components/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'change_password_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  static String routeName = './otp';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  Timer? _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
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

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'فراموشی رمز عبور',
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
                    SvgPicture.asset(
                      isLightMode
                          ? 'assets/images/Forgot_Password_Light_Frame.svg'
                          : 'assets/images/Forgot_Password_Dark_Frame.svg',
                      width: SizeConfig.getProportionateScreenWidth(150),
                      height: SizeConfig.getProportionateScreenWidth(150),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    Text(
                      "کد به شماره 22 ***** 98916+ ارسال شد",
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w500,
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(60)),
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
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(60)),
                    _secondsRemaining > 0
                        ? RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'IranBakh',
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.getProportionateScreenWidth(18),
                                color: AppColors.grey900,
                              ),
                              children: [
                                TextSpan(
                                  text: "ارسال دوباره کد در ",
                                  style: TextStyle(
                                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.getProportionateScreenWidth(16),
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
                                    fontSize: SizeConfig.getProportionateScreenWidth(16),
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
                                fontSize: SizeConfig.getProportionateScreenWidth(16),
                              ),
                            ),
                          ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(60)),
                    CustomButton(
                      text: 'تایید',
                      color: AppColors.disabledButton,
                      onTap: () {
                        final otp = _controllers.map((c) => c.text).join();
                        print("OTP: $otp");
                        Navigator.pushNamed(context, ChangePasswordScreen.routeName);
                      },
                      width: SizeConfig.getProportionateScreenWidth(77),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.2),
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
