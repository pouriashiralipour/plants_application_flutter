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
  const OTPScreen({super.key, this.fromSignup = false, required this.target});

  static String routeName = './otp';

  final bool fromSignup;
  final String target;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.ltr,
        maxLength: 1,
        style: TextStyle(
          fontFamily: 'Peyda',
          fontSize: SizeConfig.getProportionateScreenWidth(24),
          fontWeight: FontWeight.w700,
          height: 1.0,
          color: isLightMode ? AppColors.grey900 : AppColors.white,
        ),
        cursorHeight: SizeConfig.getProportionateScreenWidth(24) * 0.65,
        cursorWidth: 2,
        cursorRadius: const Radius.circular(2),
        strutStyle: const StrutStyle(height: 1.0, forceStrutHeight: true),
        decoration: InputDecoration(
          counterText: "",
          isDense: true,
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

            if (index < _controllers.length - 1) {
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

  String _maskPhone(String p) {
    final digits = p.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 10) {
      final tail2 = digits.substring(digits.length - 2);
      final head4 = digits.substring(0, 4);
      return '${p.startsWith('+') ? '+' : ''}$head4******$tail2';
    }
    return p;
  }

  String _maskEmail(String e) {
    final parts = e.split('@');
    if (parts.length != 2) return e;
    final user = parts[0];
    final domain = parts[1];
    final safeUser = user.length <= 2 ? user : '${user.substring(0, 2)}***';
    return '$safeUser@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final target = widget.target;
    final masked = target.contains('@') ? _maskEmail(target) : _maskPhone(target);
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
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: target.contains('@') ? 'کد به ایمیل ' : 'کد به شماره ',
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(16),
                    fontWeight: FontWeight.w500,
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      masked,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(16),
                        fontWeight: FontWeight.w500,
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                      ),
                    ),
                  ),
                ),
                TextSpan(
                  text: ' ارسال شد',
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(16),
                    fontWeight: FontWeight.w500,
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                ),
              ],
            ),
            textDirection: TextDirection.rtl,
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: List.generate(6, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AspectRatio(aspectRatio: 5 / 6, child: _buildOtpBox(index)),
                ),
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
