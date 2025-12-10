import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/auth_remote_data_source.dart';

import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_text_field.dart';

import '../../../../core/utils/iran_contact_validator.dart';
import '../../../../core/utils/validators.dart';

import '../widgets/auth_bottom_action.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_illustration.dart';
import '../widgets/auth_scaffold.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';

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
          builder: (_) => OTPScreen(target: normalized, purpose: 'register'),
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
          Gap(SizeConfig.getProportionateScreenHeight(20)),
          AppLogo(),
          Gap(SizeConfig.getProportionateScreenHeight(60)),
          AuthSvgAssetWidget(
            svg: isLightMode
                ? 'assets/images/sign_up_frame.svg'
                : 'assets/images/sign_up_dark_frame.svg',
          ),
          Gap(SizeConfig.getProportionateScreenHeight(60)),
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
                child: AppAlertDialog(text: _serverErrorMessage!, isError: true),
              ),
            ],
            Gap(SizeConfig.getProportionateScreenHeight(20)),
            AppTextField(
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
              ? AppProgressBarIndicator()
              : AppButton(
                  text: 'تایید',
                  color: AppColors.disabledButton,
                  onTap: _submit,
                  width: SizeConfig.screenWidth,
                  fontSize: SizeConfig.getProportionateFontSize(16),
                ),
          Gap(SizeConfig.getProportionateScreenHeight(40)),
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
