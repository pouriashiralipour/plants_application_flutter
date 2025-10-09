import 'package:flutter/material.dart';

import '../../../api/auth_api.dart';
import '../../../components/adaptive_gap.dart';
import '../../../components/custom_progress_bar.dart';
import '../../../components/widgets/custom_alert.dart';
import '../../../components/widgets/custom_text_field.dart';
import '../../../components/widgets/cutsom_button.dart';
import '../../../theme/colors.dart';
import '../../../utils/iran_contact.dart';
import '../../../utils/size.dart';
import '../../../utils/validators.dart';
import '../components/auth_scaffold.dart';
import '../components/auth_svg_asset_widget.dart';
import '../components/custom_title_auth.dart';
import 'otp_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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

  Future<void> _submit() async {
    setState(() {
      _showErrors = true;
      _serverErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final raw = _targetCtrl.text.trim();

    final prepared = raw.contains('@') ? raw : toEnglishDigits(raw);
    final normalized = prepared.contains('@') ? prepared : normalizeIranPhone(prepared);
    debugPrint(normalized);

    final response = await AuthApi().requestPasswordOtp(target: normalized);

    if (!mounted) return;

    if (response.success) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => OtpPasswordScreen(target: normalized)));
    } else {
      setState(() => _serverErrorMessage = response.error ?? 'ارسال کد ناموفق بود');
      _showServerError(_serverErrorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(),
      header: AuthSvgAssetWidget(
        svg: isLightMode
            ? 'assets/images/Forgot_Password_Light_Frame.svg'
            : 'assets/images/Forgot_Password_Dark_Frame.svg',
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
            CustomTitleAuth(title: 'فراموشی رمز عبور'),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
            CustomTextField(
              isLightMode: isLightMode,
              preffixIcon: 'assets/images/icons/Message_bold.svg',
              hintText: 'ایمیل یا شماره تلفن',
              showErrors: _showErrors,
              controller: _targetCtrl,
              validator: Validators.requiredTargetValidator,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ),
      footer: _isLoading
          ? CusstomProgressBar()
          : CustomButton(
              text: 'ادامه',
              color: AppColors.primary,
              onTap: _submit,
              width: SizeConfig.getProportionateScreenWidth(98),
            ),
    );
  }
}
