import 'package:flutter/material.dart';

import '../../api/auth_api.dart';
import '../../components/adaptive_gap.dart';
import '../../components/custom_progress_bar.dart';
import '../../components/widgets/custom_alert.dart';
import '../../components/widgets/custom_logo_widget.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/iran_contact.dart';
import '../../utils/size.dart';
import '../../utils/validators.dart';
import 'components/auth_scaffold.dart';
import 'components/auth_svg_asset_widget.dart';
import 'components/bottom_auth_text.dart';
import 'components/custom_title_auth.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetCtrl = TextEditingController();

  bool _isLoading = false;
  bool _showErrors = false;

  String? _serverErrorMessage;

  @override
  void dispose() {
    _targetCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    _showErrors = false;
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

  void _submit() async {
    setState(() {
      _showErrors = true;
      _serverErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final raw = _targetCtrl.text.trim();

    final prepared = raw.contains('@') ? raw : toEnglishDigits(raw);
    final normalized = prepared.contains('@') ? prepared : normalizeIranPhone(prepared);
    debugPrint(normalized);

    final response = await AuthApi().requestOtp(target: normalized, purpose: 'register');

    if (!mounted) return;

    if (response.success) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OTPScreen(target: normalized, purpose: 'register', fromSignup: true),
        ),
      );
    } else {
      setState(() => _serverErrorMessage = response.error ?? 'ارسال کد ناموفق بود');
      _showServerError(_serverErrorMessage!);
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
        child: Column(
          children: [
            if (_serverErrorMessage != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomAlert(text: _serverErrorMessage!, isError: true),
              ),
            ],
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
            CustomTextField(
              isLightMode: isLightMode,
              preffixIcon: 'assets/images/icons/Message_bold.svg',
              hintText: 'ایمیل یا شماره تلفن',
              textInputAction: TextInputAction.done,
              showErrors: _showErrors,
              controller: _targetCtrl,
              validator: Validators.requiredTargetValidator,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ),
      footer: Column(
        children: [
          _isLoading
              ? CusstomProgressBar()
              : CustomButton(
                  text: 'تایید',
                  color: AppColors.disabledButton,
                  onTap: _submit,
                  width: SizeConfig.screenWidth,
                ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          BottomAuthText(
            text: 'قبلا عضو خانوده ما بودی ؟',
            buttonText: 'ورود',
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
          ),
        ],
      ),
    );
  }
}
