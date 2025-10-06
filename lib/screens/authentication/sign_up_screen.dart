import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/api/auth/otp_services.dart';
import 'package:full_plants_ecommerce_app/components/widgets/custom_logo_widget.dart';
import 'package:full_plants_ecommerce_app/models/otp_models.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/otp_scree.dart';

import '../../components/adaptive_gap.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/iran_contact.dart';
import '../../utils/size.dart';
import 'components/auth_svg_asset_widget.dart';
import 'components/bottom_auth_text.dart';
import 'components/custom_title_auth.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String routeName = './signUp';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isApiCalled = false;
  late OtpRequestModels otpRequestModels;
  late OtpServices otpServices;

  final _emailOrPhoneCtrl = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    otpServices = OtpServices();
    otpRequestModels = OtpRequestModels();
  }

  @override
  void reassemble() {
    super.reassemble();
    _showErrors = false;
  }

  String? _requiredValidator(String? v) {
    final value = (v ?? '').trim();
    if (v == null || v.trim().isEmpty) {
      return 'شماره موبایل یا ایمیل خود را وارد کنید';
    }
    if (value.contains('@')) {
      if (!isValidEmail(value)) {
        return 'ایمیل را به‌درستی وارد کنید';
      }
    } else {
      if (!isValidIranPhone(value)) {
        return 'شماره موبایل را به‌درستی وارد کنید ';
      }
    }
    return null;
  }

  void _submit() async {
    setState(() => _showErrors = true);

    if (_formKey.currentState!.validate()) {
      final raw = _emailOrPhoneCtrl.text.trim();
      if (raw.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فیلد خالی است')));
        return;
      }

      final prepared = raw.contains('@') ? raw : toEnglishDigits(raw);
      final normalized = prepared.contains('@') ? prepared : normalizeIranPhone(prepared);

      if (normalized.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('مقدار ارسالی معتبر نیست')));
        return;
      }

      final model = OtpRequestModels(target: normalized, purpose: 'register');

      debugPrint('Will send target="$normalized" purpose="register"');

      final ok = await OtpServices().requestOtp(model);
      if (!mounted) return;

      if (ok) {
        Navigator.of(context).pushNamed(OTPScreen.routeName);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ارسال کد با خطا مواجه شد')));
      }

      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      header: Column(
        children: [
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
          CustomLogoWidget(),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(60)),
          AuthSvgAssetWidget(
            svg: isLightMode
                ? 'assets/images/sign_up_frame.svg'
                : 'assets/images/sign_up_dark_frame.svg',
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(60)),
          CustomTitleAuth(title: 'عضوی از خانواده ما شو'),
        ],
      ),
      form: Form(
        key: _formKey,
        child: CustomTextField(
          isLightMode: isLightMode,
          preffixIcon: 'assets/images/icons/Message_bold.svg',
          hintText: 'ایمیل یا شماره تلفن',
          initialValue: otpRequestModels.target,
          showErrors: _showErrors,
          onChanged: (value) {
            setState(() {
              otpRequestModels.target = value;
            });
          },
          controller: _emailOrPhoneCtrl,
          validator: _requiredValidator,
          textDirection: TextDirection.ltr,
        ),
      ),
      footer: Column(
        children: [
          CustomButton(
            text: 'تایید',
            color: AppColors.disabledButton,
            onTap: _submit,
            width: SizeConfig.screenWidth,
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          BottomAuthText(
            text: 'قبلا عضو خانوده ما بودی ؟',
            buttonText: 'ورود',
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
