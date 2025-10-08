import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/utils/persian_number.dart';

import '../../api/auth_api.dart';
import '../../components/adaptive_gap.dart';
import '../../components/custom_progress_bar.dart';
import '../../components/widgets/custom_alert.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/auth_scaffold.dart';
import 'profile_form_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    this.fromSignup = false,
    required this.target,
    this.purpose = 'register',
  });

  final bool fromSignup;
  final String purpose;
  final String target;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  int _secondsRemaining = 120;

  String? _serverErrorMessage;
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

  String normalizeDigits(String input) {
    const fa = '۰۱۲۳۴۵۶۷۸۹';
    const ar = '٠١٢٣٤٥٦٧٨٩';
    const en = '0123456789';

    return input.replaceAllMapped(RegExp(r'[۰-۹٠-٩]'), (m) {
      final ch = m.group(0)!;
      final iFa = fa.indexOf(ch);
      if (iFa != -1) return en[iFa];
      final iAr = ar.indexOf(ch);
      if (iAr != -1) return en[iAr];
      return ch;
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
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9۰-۹٠-٩]')),
          LengthLimitingTextInputFormatter(1),
        ],
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

  String _maskEmail(String e) {
    final parts = e.split('@');
    if (parts.length != 2) return e;
    final user = parts[0];
    final domain = parts[1];
    final safeUser = user.length <= 2 ? user : '${user.substring(0, 2)}***';
    return '$safeUser@$domain';
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

  void _resendOtp() async {
    if (_isLoading) return;
    if (_secondsRemaining > 0) return;

    setState(() {
      _serverErrorMessage = null;
    });

    final response = await AuthApi().requestOtp(target: widget.target, purpose: widget.purpose);

    if (!mounted) return;

    if (response.success) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      _secondsRemaining = 120;
      _startTimer();
    } else {
      _showServerError(response.error ?? 'ارسال مجدد ناموفق بود');
    }
  }

  void _showServerError(String message) {
    setState(() {
      _serverErrorMessage = message;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _serverErrorMessage = null;
        });
      }
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

  void _verify() async {
    setState(() {
      _serverErrorMessage = null;
    });

    final raw = _controllers.map((c) => c.text).join();
    final cleaned = normalizeDigits(raw).replaceAll(RegExp(r'\s+'), '');
    debugPrint(cleaned);
    final expectedLen = _controllers.length;

    if (cleaned.length != expectedLen || !RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      _showServerError('کد ۶ رقمی را کامل و صحیح وارد کنید');
      return;
    }

    final response = await AuthApi().veriftOtp(cleaned);

    if (!mounted) return;

    if (response.success && response.data != null) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileFormScreen(
            target: widget.target,
            token: response.data!.tokens,
            purpose: widget.purpose,
          ),
        ),
      );
    } else {
      _showServerError(response.error ?? 'تایید کد با خطا مواجه شد');
    }
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
          if (_serverErrorMessage != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomAlert(text: _serverErrorMessage!, isError: true),
            ),
          ],
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
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
                  onPressed: _resendOtp,
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
      footer: _isLoading
          ? CusstomProgressBar()
          : CustomButton(
              text: 'تایید',
              color: AppColors.disabledButton,
              onTap: _verify,
              width: SizeConfig.getProportionateScreenWidth(77),
            ),
    );
  }
}
