import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/password_reset_repository.dart';

import '../../../../core/widgets/app_dialog.dart';

import '../../../../core/widgets/app_text_field.dart';

import '../../../../core/utils/validators.dart';
import '../widgets/auth_illustration.dart';

import '../widgets/auth_scaffold.dart';
import '../widgets/remember_me_checkbox.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static String routeName = './change_password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();

  bool _isLoading = false;
  bool _showErrors = false;

  String? _serverErrorMessage;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<dynamic> customSuccessShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.grey900.withValues(alpha: 0.8),
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
        return AppDialog(
          text:
              "رمز عبور شما با موفقیت تغییر کرد.\nحالا میتونی با رمزعبور جدید وارد بشی.\nشما تا لحظاتی دیگر به صفحه ورود هدایت می شوید",
        );
      },
    );
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

  Future<void> _submit() async {
    setState(() {
      _showErrors = true;
      _serverErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    if (_passCtrl.text != _confirmCtrl.text) {
      setState(() => _showServerError('رمز عبور و تکرار آن یکسان نیستند'));
      return;
    }

    final passwordRepostory = context.read<PasswordResetRepository>();
    final token = passwordRepostory.resetToken;

    if (token == null) {
      setState(() => _showServerError('توکن بازیابی در دسترس نیست. دوباره OTP را تأیید کنید.'));
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthApi().setNewPassword(
      resetToken: token,
      newPassword: _passCtrl.text,
      confirmNewPassword: _confirmCtrl.text,
    );

    if (!mounted) return;

    if (response.success) {
      passwordRepostory.clear();
      customSuccessShowDialog(context);
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
      setState(() => _showServerError(response.error ?? 'تغییر پسورد ناموفق بود'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(
        title: Text(
          'ساخت رمزعبور جدید',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.getProportionateScreenWidth(21),
          ),
        ),
      ),
      header: Column(
        children: [
          Gap(SizeConfig.getProportionateScreenHeight(20)),
          AuthSvgAssetWidget(
            svg: isLightMode
                ? 'assets/images/new_pass_light.svg'
                : 'assets/images/new_pass_dark.svg',
          ),
        ],
      ),
      form: Column(
        children: [
          if (_serverErrorMessage != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AppAlertDialog(text: _serverErrorMessage!, isError: true),
            ),
          ],
          Gap(SizeConfig.getProportionateScreenHeight(20)),
          Text(
            'رمزعبور جدید خود را وارد کنید',
            style: TextStyle(
              color: isLightMode ? AppColors.grey900 : AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.getProportionateScreenWidth(16),
            ),
          ),
          Gap(SizeConfig.getProportionateScreenHeight(40)),
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  isPassword: true,
                  suffixIcon: 'assets/images/icons/Hide_bold.svg',
                  isLightMode: isLightMode,
                  preffixIcon: 'assets/images/icons/Lock_bold.svg',
                  hintText: 'رمزعبور',
                  validator: Validators.requiredPasswordValidator,
                  showErrors: _showErrors,
                  controller: _passCtrl,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
          Gap(SizeConfig.getProportionateScreenHeight(20)),
          AppTextField(
            isPassword: true,
            suffixIcon: 'assets/images/icons/Hide_bold.svg',
            isLightMode: isLightMode,
            preffixIcon: 'assets/images/icons/Lock_bold.svg',
            hintText: 'تایید رمز عبور',
            validator: Validators.requiredPasswordValidator,
            showErrors: _showErrors,
            controller: _confirmCtrl,
            textDirection: TextDirection.ltr,
          ),
          Gap(SizeConfig.getProportionateScreenHeight(20)),
          RememberMeWidget(),
        ],
      ),
      footer: _isLoading
          ? AppProgressBarIndicator()
          : AppButton(
              onTap: _submit,
              text: 'ادامه',
              color: AppColors.primary,
              width: SizeConfig.getProportionateScreenWidth(98),
            ),
    );
  }
}
