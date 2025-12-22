import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/config/root_screen.dart';
import '../../../../core/services/app_message_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/iran_contact_validator.dart';
import '../../../../core/utils/persian_digits_input_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';

import '../widgets/auth_bottom_action.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/remember_me_checkbox.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isLoading = false;
  bool _showErrors = false;

  String? _serverErrorMessage;

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
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

    final raw = _loginCtrl.text.trim();

    final prepared = raw.contains('@') ? raw : toEnglishDigits(raw);
    final login = prepared.contains('@') ? prepared : normalizeIranPhone(prepared);
    final password = _passCtrl.text;

    debugPrint(login);

    final response = await AuthApi().login(login: login, password: password);
    if (!mounted) return;

    if (response.success && response.data != null) {
      await context.read<AuthRepository>().setTokens(response.data!.tokens);

      if (!mounted) return;

      context.read<AppMessageController>().showSuccess(response.message ?? 'خوش برگشتی');

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => RootScreen()),
        (route) => false,
      );
      return;
    } else {
      setState(() => _serverErrorMessage = response.error ?? 'ورود ناموفق بود');
      _showServerError(_serverErrorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(),
      header: Column(
        children: [
          AppLogo(),
          Gap(SizeConfig.getProportionateScreenHeight(60)),
          CustomTitleAuth(title: 'به حساب کاربری خود وارد شوید'),
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
            AppTextField(
              isLightMode: isLightMode,
              preffixIcon: 'assets/images/icons/Message_bold.svg',
              hintText: 'ایمیل یا شماره تلفن',
              textDirection: TextDirection.ltr,
              showErrors: _showErrors,
              validator: Validators.requiredTargetValidator,
              controller: _loginCtrl,
              inputFormatters: const [PersianDigitsTextInputFormatter()],
            ),
            Gap(SizeConfig.getProportionateScreenHeight(20)),
            AppTextField(
              isPassword: true,
              suffixIcon: 'assets/images/icons/Hide_bold.svg',
              isLightMode: isLightMode,
              preffixIcon: 'assets/images/icons/Lock_bold.svg',
              hintText: 'رمزعبور',
              textDirection: TextDirection.ltr,
              showErrors: _showErrors,
              validator: Validators.requiredPasswordValidator,
              controller: _passCtrl,
            ),
            Gap(SizeConfig.getProportionateScreenHeight(20)),
            RememberMeWidget(),
          ],
        ),
      ),
      footer: Column(
        children: [
          _isLoading
              ? AppProgressBarIndicator()
              : AppButton(
                  onTap: _submit,
                  text: 'ورود',
                  color: AppColors.disabledButton,
                  width: SizeConfig.screenWidth,
                  fontSize: SizeConfig.getProportionateFontSize(16),
                ),
          Gap(SizeConfig.getProportionateScreenHeight(40)),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
            ),
            child: Text(
              'فراموشی رمز  عبور',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: SizeConfig.getProportionateFontSize(16),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Gap(SizeConfig.getProportionateScreenHeight(40)),
          BottomAuthText(
            text: 'هنوز عضو خانواده ما نشدی ؟',
            buttonText: 'ثبت نام',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
          ),
        ],
      ),
    );
  }
}
