import 'package:flutter/material.dart';

import 'package:full_plants_ecommerce_app/components/custom_progress_bar.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';
import 'package:full_plants_ecommerce_app/screens/root/root_screen.dart';
import 'package:provider/provider.dart';

import '../../api/auth_api.dart';
import '../../auth/auth_repository.dart';
import '../../components/adaptive_gap.dart';
import '../../components/widgets/custom_alert.dart';
import '../../components/widgets/custom_logo_widget.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../models/auth/auth_models.dart';
import '../../theme/colors.dart';
import '../../utils/iran_contact.dart';
import '../../utils/size.dart';
import '../../utils/validators.dart';
import 'components/bottom_auth_text.dart';
import 'components/custom_title_auth.dart';
import 'components/remember_me.dart';
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
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
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
          CustomLogoWidget(),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(60)),
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
                child: CustomAlert(text: _serverErrorMessage!, isError: true),
              ),
            ],
            CustomTextField(
              isLightMode: isLightMode,
              preffixIcon: 'assets/images/icons/Message_bold.svg',
              hintText: 'ایمیل یا شماره تلفن',
              textDirection: TextDirection.ltr,
              showErrors: _showErrors,
              validator: Validators.requiredTargetValidator,
              controller: _loginCtrl,
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
            CustomTextField(
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
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(20)),
            RememberMeWidget(),
          ],
        ),
      ),
      footer: Column(
        children: [
          _isLoading
              ? CusstomProgressBar()
              : CustomButton(
                  onTap: _submit,
                  text: 'ورود',
                  color: AppColors.disabledButton,
                  width: SizeConfig.screenWidth,
                ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
            child: Text(
              'فراموشی رمز  عبور',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: SizeConfig.getProportionateFontSize(16),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
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
